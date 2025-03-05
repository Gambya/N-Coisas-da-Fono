import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ncoisasdafono/domain/entities/patient.dart';
import 'package:ncoisasdafono/ui/patient/viewmodels/patient_register_view_model.dart';
import 'package:ncoisasdafono/ui/patient/viewmodels/patient_view_model.dart';
import 'package:ncoisasdafono/ui/patient/views/patient_details_view.dart';
import 'package:ncoisasdafono/ui/patient/views/patient_register_view.dart';
import 'package:provider/provider.dart';
import 'package:result_command/result_command.dart';

class PatientView extends StatefulWidget {
  const PatientView({super.key});

  @override
  State<PatientView> createState() => _PatientViewState();
}

class _PatientViewState extends State<PatientView> {
  late PatientViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<PatientViewModel>();
    _viewModel.loadPatientsCommand.addListener(_onLoadPatientCommandChanged);
    _viewModel.loadPatientsCommand.execute();
  }

  void _onLoadPatientCommandChanged() {
    if (_viewModel.loadPatientsCommand.isFailure) {
      final failure = _viewModel.loadPatientsCommand.value as FailureCommand;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(failure.error.toString()),
      ));
    }
  }

  @override
  void dispose() {
    _viewModel.loadPatientsCommand.removeListener(_onLoadPatientCommandChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Patient>>(
        stream: _viewModel.patientsStream,
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
              itemBuilder: (context, index) {
                Patient patient = snapshot.data![index];
                return _buildPatientItem(patient);
              },
              itemCount: snapshot.data?.length ?? 0,
            );
          } else {
            return const Center(
              child: Text('Nenhum paciente encontrado.'),
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
                  PatientRegisterView(
                viewModel: context.read<PatientRegisterViewModel>(),
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
        child: const Icon(Icons.person_add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildPatientItem(Patient patient) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        PatientDetailsView(
                      patient: patient,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      if (patient.photoUrl != null &&
                          patient.photoUrl!.isNotEmpty)
                        Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color.fromARGB(255, 215, 186, 232),
                                width: 3.0,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundImage:
                                  Image.file(File(patient.photoUrl!)).image,
                            ))
                      else
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color.fromARGB(255, 215, 186, 232),
                              width: 3.0,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 215, 186, 232),
                            child: Text(
                              patient.name.substring(0, 2).toUpperCase(),
                              style: TextStyle(
                                color: Color.fromARGB(255, 193, 214, 255),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 200.0,
                            child: Text(
                              patient.name,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Text(
                            patient.email,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12.0,
                              color: Colors.grey,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    color: Color.fromARGB(255, 215, 186, 232),
                    onPressed: () {},
                  ),
                ],
              )),
        ),
        SizedBox(height: 10),
        Divider(
          color: Colors.grey[200], // Cor da linha
          thickness: 1.0, // Espessura da linha
          height: 0.0, // Altura total (sem espaço extra)
        ),
      ],
    );
  }
}
