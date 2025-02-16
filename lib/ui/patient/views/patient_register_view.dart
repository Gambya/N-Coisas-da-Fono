import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:ncoisasdafono/domain/dtos/patient_dto.dart';
import 'package:ncoisasdafono/domain/validators/patient_validator.dart';
import 'package:ncoisasdafono/routing/routes.dart';
import 'package:ncoisasdafono/ui/patient/viewmodels/patient_register_view_model.dart';
import 'package:result_command/result_command.dart';

class PatientRegisterView extends StatefulWidget {
  final PatientRegisterViewModel viewModel;

  const PatientRegisterView({super.key, required this.viewModel});

  @override
  State<PatientRegisterView> createState() => _PatientRegisterViewState();
}

class _PatientRegisterViewState extends State<PatientRegisterView> {
  late PatientRegisterViewModel _viewModel;
  final PatientValidator _validator = PatientValidator();
  final PatientDto _patient = PatientDto();

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    _viewModel.registerPatientCommand
        .addListener(_onRegisterPatientCommandChanged);
  }

  void _onRegisterPatientCommandChanged() {
    if (_viewModel.registerPatientCommand.isSuccess) {
      context.go(Routes.home);
      // Navigator.of(context).pop();
    } else if (_viewModel.registerPatientCommand.isFailure) {
      final failure = _viewModel.registerPatientCommand.value as FailureCommand;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(failure.error.toString()),
      ));
    }
  }

  @override
  void dispose() {
    _viewModel.registerPatientCommand
        .removeListener(_onRegisterPatientCommandChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Text('Paciente'),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  _patient.name = value;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _validator.byField(_patient, 'name'),
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  _patient.email = value;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _validator.byField(_patient, 'email'),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  _patient.phone = value;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _validator.byField(_patient, 'phone'),
                inputFormatters: [
                  MaskTextInputFormatter(
                      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')}),
                ],
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Celular/Telefone',
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  _patient.cpf = value;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _validator.byField(_patient, 'cpf'),
                inputFormatters: [
                  MaskTextInputFormatter(
                      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')}),
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'CPF',
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  _patient.rg = value;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'RG',
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 40),
              ListenableBuilder(
                listenable: _viewModel.registerPatientCommand,
                builder: (context, _) {
                  return ElevatedButton(
                    onPressed: _viewModel.registerPatientCommand.isRunning
                        ? null
                        : () {
                            if (_validator.validate(_patient).isValid) {
                              _viewModel.registerPatientCommand
                                  .execute(_patient);
                            }
                          },
                    child: const Text('Salvar'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
