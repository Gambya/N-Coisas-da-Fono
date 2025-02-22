import 'package:flutter/material.dart';
import 'package:ncoisasdafono/domain/dtos/consultation_with_doctor_and_patient_dto.dart';
import 'package:ncoisasdafono/ui/consultation/viewmodels/consultation_register_view_model.dart';
import 'package:ncoisasdafono/ui/consultation/views/consultation_detail_view.dart';
import 'package:ncoisasdafono/ui/consultation/views/consultation_register_view.dart';
import 'package:ncoisasdafono/ui/consultation/viewmodels/consultation_view_model.dart';
import 'package:ncoisasdafono/ui/consultation/widgets/consultation_card.dart';
import 'package:provider/provider.dart';
import 'package:result_command/result_command.dart';

class ConsultationView extends StatefulWidget {
  const ConsultationView({super.key});

  @override
  State<ConsultationView> createState() => _ConsultationViewState();
}

class _ConsultationViewState extends State<ConsultationView> {
  late ConsultationViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<ConsultationViewModel>();
    _viewModel.loadConsultationCommand
        .addListener(_onLoadConsultationCommandChanged);

    _viewModel.loadConsultationCommand.execute();
  }

  void _onLoadConsultationCommandChanged() {
    if (_viewModel.loadConsultationCommand.isFailure) {
      final failure =
          _viewModel.loadConsultationCommand.value as FailureCommand;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(failure.error.toString()),
      ));
    }
  }

  @override
  void dispose() {
    _viewModel.loadConsultationCommand
        .removeListener(_onLoadConsultationCommandChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<ConsultationWithDoctorAndPatientDto>>(
        stream: _viewModel.consultationStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 193, 214, 255),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Nenhuma consulta encontrada.'),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final consultation = snapshot.data![index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ConsultationDetailView(
                          consultation: consultation,
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end).chain(
                            CurveTween(curve: curve),
                          );

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: ConsultationCard(
                    patientName: consultation.patient.name,
                    photoUrl: consultation.patient.photoUrl,
                    consultationDate: consultation.dateTime,
                    consultationTime:
                        TimeOfDay.fromDateTime(consultation.dateTime),
                    consultationDuration: int.tryParse(consultation.duration)!,
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('Nenhuma consulta disponível para esta data.'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 193, 214, 255),
        mini: true,
        shape: CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  ConsultationRegisterView(
                viewModel: context.read<ConsultationRegisterViewModel>(),
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end).chain(
                  CurveTween(curve: curve),
                );

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        },
        child: const Icon(Icons.post_add),
      ),
    );
  }
}
