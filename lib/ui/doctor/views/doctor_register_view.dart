import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:ncoisasdafono/domain/dtos/doctor_dto.dart';
import 'package:ncoisasdafono/domain/validators/doctor_validator.dart';
import 'package:ncoisasdafono/routing/routes.dart';
import 'package:ncoisasdafono/ui/doctor/viewmodels/doctor_register_view_model.dart';
import 'package:result_command/result_command.dart';

class DoctorRegisterView extends StatefulWidget {
  final DoctorRegisterViewModel viewModel;

  const DoctorRegisterView({super.key, required this.viewModel});

  @override
  State<DoctorRegisterView> createState() => _DoctorRegisterViewState();
}

class _DoctorRegisterViewState extends State<DoctorRegisterView> {
  late DoctorRegisterViewModel _viewModel;
  final DoctorValidator _validator = DoctorValidator();
  final DoctorDto _doctor = DoctorDto();

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    _viewModel.registerDoctorCommand
        .addListener(_onRegisterDoctorCommandChanged);
  }

  void _onRegisterDoctorCommandChanged() {
    if (_viewModel.registerDoctorCommand.isSuccess) {
      context.go(Routes.home);
      // Navigator.of(context).pop();
    } else if (_viewModel.registerDoctorCommand.isFailure) {
      final failure = _viewModel.registerDoctorCommand.value as FailureCommand;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(failure.error.toString()),
      ));
    }
  }

  @override
  void dispose() {
    _viewModel.registerDoctorCommand
        .removeListener(_onRegisterDoctorCommandChanged);
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
              Text('Registrar Fonoaudióloga'),
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
                  _doctor.name = value;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _validator.byField(_doctor, 'name'),
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  _doctor.email = value;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _validator.byField(_doctor, 'email'),
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
                  _doctor.phone = value;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _validator.byField(_doctor, 'phone'),
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
                  _doctor.crfa = value;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _validator.byField(_doctor, 'crfa'),
                inputFormatters: [
                  MaskTextInputFormatter(
                      mask: '#-####', filter: {"#": RegExp(r'[0-9]')}),
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'CRFa',
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  _doctor.address = value;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _validator.byField(_doctor, 'address'),
                decoration: InputDecoration(
                  labelText: 'Endereço',
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 40),
              ListenableBuilder(
                  listenable: _viewModel.registerDoctorCommand,
                  builder: (context, _) {
                    return ElevatedButton(
                      onPressed: _viewModel.registerDoctorCommand.isRunning
                          ? null
                          : () {
                              if (_validator.validate(_doctor).isValid) {
                                _viewModel.registerDoctorCommand
                                    .execute(_doctor);
                              }
                            },
                      child: const Text('Salvar'),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
