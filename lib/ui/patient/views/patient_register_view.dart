import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:ncoisasdafono/domain/dtos/patient_dto.dart';
import 'package:ncoisasdafono/domain/validators/patient_dto_validator.dart';
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
  final PatientDtoValidator _validator = PatientDtoValidator();
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
      Navigator.of(context).pop();
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
      appBar: AppBar(
        title: Text('Paciente'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0), // Altura da linha
          child: Container(
            color: Colors.grey, // Cor da linha
            height: 1.0, // Espessura da linha
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Stack(
                children: [
                  InkWell(
                    onTap: () async {
                      String? image = await _showDialogSelectImage(context);
                      if (image != null) {
                        _patient.photoUrl = image;
                        setState(() {});
                      }
                    },
                    child: _patient.photoUrl != null &&
                            _patient.photoUrl!.isNotEmpty
                        ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color.fromARGB(255, 193, 214, 255),
                                width: 5.0,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  Image.file(File(_patient.photoUrl!)).image,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color.fromARGB(255, 193, 214, 255),
                                width: 2.0,
                              ),
                            ),
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
                        Icons.photo_camera_rounded,
                        color: Color.fromARGB(255, 193, 214, 255),
                      ),
                    ),
                  ),
                ],
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
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        Color.fromARGB(255, 193, 214, 255),
                      ),
                      foregroundColor: WidgetStateProperty.all<Color>(
                        Colors.white,
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
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

  Future<String?> _showDialogSelectImage(BuildContext context) async {
    return await showDialog<String?>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Selecione Opções"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text("Câmera"),
                  onTap: () async {
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context, await _selectCameraImage(context));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo),
                  title: Text("Galeria"),
                  onTap: () async {
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context, await _selectGalletyImage(context));
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<String?> _selectCameraImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    try {
      XFile? file = await picker.pickImage(source: ImageSource.camera);
      if (file != null) {
        return file.path;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }
    }
    return null;
  }

  Future<String?> _selectGalletyImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    try {
      XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        return file.path;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }
    }
    return null;
  }
}
