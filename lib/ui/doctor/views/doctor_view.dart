import 'package:flutter/material.dart';
import 'package:ncoisasdafono/domain/entities/doctor.dart';
import 'package:ncoisasdafono/ui/doctor/viewmodels/doctor_view_model.dart';
import 'package:provider/provider.dart';
import 'package:result_command/result_command.dart';

class DoctorView extends StatefulWidget {
  const DoctorView({super.key});

  @override
  State<DoctorView> createState() => _DoctorViewState();
}

class _DoctorViewState extends State<DoctorView> {
  late DoctorViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<DoctorViewModel>();
    _viewModel.loadDoctorsCommand.addListener(_onLoadDoctorCommandChanged);
    _viewModel.loadDoctorsCommand.execute();
  }

  void _onLoadDoctorCommandChanged() {
    if (_viewModel.loadDoctorsCommand.isFailure) {
      final failure = _viewModel.loadDoctorsCommand.value as FailureCommand;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(failure.error.toString()),
      ));
    }
  }

  @override
  void dispose() {
    _viewModel.loadDoctorsCommand.removeListener(_onLoadDoctorCommandChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 215, 186, 232),
      body: _buildDoctorProfile(),
    );
  }

  Widget _showEditBottomSheet(BuildContext context) {
    return Text("edit");
  }

  Widget _buildDoctorProfile() {
    return StreamBuilder(
      stream: _viewModel.doctorsStream,
      builder: (BuildContext context, AsyncSnapshot<Doctor> snapshot) {
        if (_viewModel.loadDoctorsCommand.isRunning) {
          return Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 193, 214, 255),
            ),
          );
        } else if (_viewModel.loadDoctorsCommand.isFailure) {
          final failure = _viewModel.loadDoctorsCommand.value as FailureCommand;
          return SnackBar(
            content: Text(failure.error.toString()),
          );
        } else if (_viewModel.loadDoctorsCommand.isSuccess) {
          if (snapshot.hasData) {
            Doctor doctor = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        if (doctor.photoUrl != null &&
                            doctor.photoUrl!.isNotEmpty)
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(doctor.photoUrl!),
                          )
                        else
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Color.fromARGB(255, 193, 214, 255),
                            child: Text(
                              doctor.name.substring(0, 2).toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Color.fromARGB(255, 193, 214, 255),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      Center(
                        child: Text(
                          doctor.name,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mail_rounded,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            doctor.email,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.medical_services_rounded,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            doctor.specialty,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone_iphone_rounded,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            doctor.phone,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.fingerprint_rounded,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            doctor.crfa,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home_rounded,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              textAlign: TextAlign.center,
                              doctor.address,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16.0,
                                color: Colors.white,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            Color.fromARGB(255, 193, 214, 255),
                          ),
                        ),
                        icon: Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 25.0,
                        ),
                        label: Text(
                          'Compartilhar',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () =>
                            _showShareDigitalCardBottomSheet(context),
                      ),
                      ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            Color.fromARGB(255, 193, 214, 255),
                          ),
                        ),
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 25.0,
                        ),
                        label: Text(
                          'Editar',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Nenhum médico encontrado.'),
            );
          }
        } else {
          return const Center(
            child: Text('Nenhum médico encontrado.'),
          );
        }
      },
    );
  }

  Widget _showShareDigitalCardBottomSheet(BuildContext context) {
    return Text("share");
  }
}
