import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:ncoisasdafono/domain/dtos/doctor_dto.dart';
import 'package:ncoisasdafono/domain/validators/doctor_dto_validator.dart';
import 'package:ncoisasdafono/routing/routes.dart';
import 'package:ncoisasdafono/ui/doctor/viewmodels/doctor_register_view_model.dart';
import 'package:result_command/result_command.dart';

class DoctorRegisterView extends StatefulWidget {
  final DoctorRegisterViewModel viewModel;
  final Future<void> Function()? onDoctorRegistered;

  const DoctorRegisterView(
      {super.key, required this.viewModel, this.onDoctorRegistered});

  @override
  State<DoctorRegisterView> createState() => _DoctorRegisterViewState();
}

class _DoctorRegisterViewState extends State<DoctorRegisterView> {
  late DoctorRegisterViewModel _viewModel;
  final DoctorDtoValidator _validator = DoctorDtoValidator();
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
      if (widget.onDoctorRegistered != null) {
        widget.onDoctorRegistered!().then((_) {
          if (!mounted) return;
          context.go(Routes.home);
        });
      } else {
        context.go(Routes.home);
      }
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
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 30.0,
          bottom: 16.0,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Text("Especialista"),
              const SizedBox(height: 20),
              Stack(
                children: [
                  InkWell(
                    onTap: () async {
                      String? image = await _showDialogSelectImage(context);
                      if (image != null) {
                        _doctor.photoUrl = image;
                        setState(() {});
                      }
                    },
                    child:
                        _doctor.photoUrl != null && _doctor.photoUrl!.isNotEmpty
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
                                      Image.file(File(_doctor.photoUrl!)).image,
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
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  _doctor.specialty = value;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Especialidade',
                  border: OutlineInputBorder(),
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
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
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
                      mask: '#-#####', filter: {"#": RegExp(r'[0-9]')}),
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'CRFa',
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(color: Colors.red),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
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
                    onPressed: _viewModel.registerDoctorCommand.isRunning
                        ? null
                        : () {
                            if (_validator.validate(_doctor).isValid) {
                              _viewModel.registerDoctorCommand.execute(_doctor);
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
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
        final fileCropped = await _crop(file: file);
        if (fileCropped != null) {
          return fileCropped.path;
        }
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
        final fileCropped = await _crop(file: file);
        if (fileCropped != null) {
          return fileCropped.path;
        }
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

  Future<CroppedFile?> _crop({required XFile file}) async {
    final imageCropper = ImageCropper();
    return await imageCropper.cropImage(sourcePath: file.path, uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Imagem',
        toolbarColor: Color.fromARGB(255, 215, 186, 232),
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
    ]);
  }
}
