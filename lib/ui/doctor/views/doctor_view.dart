import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:ncoisasdafono/domain/entities/doctor.dart';
import 'package:ncoisasdafono/domain/validators/doctor_validator.dart';
import 'package:ncoisasdafono/ui/doctor/viewmodels/doctor_view_model.dart';
import 'package:ncoisasdafono/ui/doctor/widgets/shimmer_loading_doctor_view.dart';
import 'package:provider/provider.dart';
import 'package:result_command/result_command.dart';
import 'package:social_sharing_plus/social_sharing_plus.dart';

class DoctorView extends StatefulWidget {
  const DoctorView({super.key});

  @override
  State<DoctorView> createState() => _DoctorViewState();
}

class _DoctorViewState extends State<DoctorView> {
  late DoctorViewModel _viewModel;
  final DoctorValidator _validator = DoctorValidator();

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<DoctorViewModel>();
    _viewModel.loadDoctorsCommand.addListener(_onLoadDoctorCommandChanged);
    _viewModel.loadDoctorsCommand.execute();
    _viewModel.onSaveDoctorCommand.addListener(_onSaveDoctorCommandChanged);
  }

  void _onLoadDoctorCommandChanged() {
    if (_viewModel.loadDoctorsCommand.isFailure) {
      final failure = _viewModel.loadDoctorsCommand.value as FailureCommand;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(failure.error.toString()),
      ));
    }
  }

  void _onSaveDoctorCommandChanged() {
    if (_viewModel.onSaveDoctorCommand.isFailure) {
      final failure = _viewModel.onSaveDoctorCommand.value as FailureCommand;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(failure.error.toString()),
      ));
    }
  }

  @override
  void dispose() {
    _viewModel.loadDoctorsCommand.removeListener(_onLoadDoctorCommandChanged);
    _viewModel.onSaveDoctorCommand.removeListener(_onSaveDoctorCommandChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 215, 186, 232),
      body: _buildDoctorProfile(),
    );
  }

  Widget _buildDoctorProfile() {
    return StreamBuilder(
      stream: _viewModel.doctorsStream,
      builder: (BuildContext context, AsyncSnapshot<Doctor> snapshot) {
        if (_viewModel.loadDoctorsCommand.isRunning) {
          return ShimmerLoadingDoctorView();
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
                        InkWell(
                          onTap: () async {
                            String? image =
                                await _showDialogSelectImage(context);
                            if (image != null) {
                              doctor.photoUrl = image;
                              _viewModel.onSaveDoctorCommand.execute(doctor);
                              setState(() {});
                            }
                          },
                          child: doctor.photoUrl != null &&
                                  doctor.photoUrl!.isNotEmpty
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
                                        Image.file(File(doctor.photoUrl!))
                                            .image,
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
                                    backgroundColor:
                                        Color.fromARGB(255, 193, 214, 255),
                                    child: Text(
                                      doctor.name.substring(0, 2).toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                      ),
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
                        onPressed: () => _showShareBottomSheet(context, doctor),
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
                        onPressed: () => _showEditBottomSheet(context, doctor),
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

  void _showEditBottomSheet(BuildContext context, Doctor doctor) {
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.80,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Text(doctor.specialty),
                  const SizedBox(height: 20),
                  if (doctor.photoUrl != null && doctor.photoUrl!.isNotEmpty)
                    Container(
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
                            Image.file(File(doctor.photoUrl!)).image,
                      ),
                    )
                  else
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Color.fromARGB(255, 193, 214, 255),
                      child: Text(
                        doctor.name.substring(0, 2).toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: doctor.name,
                    onChanged: (value) {
                      doctor.name = value;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: _validator.byField(doctor, 'name'),
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: doctor.email,
                    onChanged: (value) {
                      doctor.email = value;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: _validator.byField(doctor, 'email'),
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
                    initialValue: doctor.phone,
                    onChanged: (value) {
                      doctor.phone = value;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: _validator.byField(doctor, 'phone'),
                    inputFormatters: [
                      MaskTextInputFormatter(
                          mask: '(##) #####-####',
                          filter: {"#": RegExp(r'[0-9]')}),
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
                    initialValue: doctor.crfa,
                    onChanged: (value) {
                      doctor.crfa = value;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: _validator.byField(doctor, 'crfa'),
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
                    initialValue: doctor.specialty,
                    onChanged: (value) {
                      doctor.specialty = value;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: 'Especialidade',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: doctor.address,
                    onChanged: (value) {
                      doctor.address = value;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: _validator.byField(doctor, 'address'),
                    decoration: InputDecoration(
                      labelText: 'Endereço',
                      border: OutlineInputBorder(),
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ListenableBuilder(
                    listenable: _viewModel.onSaveDoctorCommand,
                    builder: (context, _) {
                      return ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            Color.fromARGB(255, 193, 214, 255),
                          ),
                          foregroundColor: WidgetStateProperty.all<Color>(
                            Colors.white,
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: _viewModel.onSaveDoctorCommand.isRunning
                            ? null
                            : () {
                                if (_validator.validate(doctor).isValid) {
                                  _viewModel.onSaveDoctorCommand
                                      .execute(doctor);
                                  Navigator.pop(context);
                                  setState(() {});
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
      },
    );
  }

  void _showShareBottomSheet(BuildContext context, Doctor doctor) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          spacing: 8.0,
          children: <Widget>[
            Center(
              child: const Text(
                "Compartilhar",
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: const Divider(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Image.asset(
                    'assets/icons/whatsapp.png',
                    height: 48,
                    width: 48,
                  ),
                  onPressed: () {
                    _share(SocialPlatform.whatsapp, doctor);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: Image.asset('assets/icons/telegram.png',
                      height: 48, width: 48),
                  onPressed: () {
                    _share(SocialPlatform.telegram, doctor);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _share(SocialPlatform platform, Doctor doctor) async {
    final contentText =
        '${doctor.specialty} - ${doctor.crfa}\nNome: ${doctor.name}\nEmail:${doctor.email}\nTelefone:${doctor.phone}';
    await SocialSharingPlus.shareToSocialMedia(platform, contentText);
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
