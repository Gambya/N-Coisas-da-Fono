import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:ncoisasdafono/domain/entities/patient.dart';
import 'package:ncoisasdafono/domain/validators/patient_validator.dart';
import 'package:ncoisasdafono/ui/patient/viewmodels/patient_details_view_model.dart';
import 'package:provider/provider.dart';
import 'package:result_command/result_command.dart';
import 'package:social_sharing_plus/social_sharing_plus.dart';

class PatientDetailsView extends StatefulWidget {
  final Patient patient;
  const PatientDetailsView({super.key, required this.patient});

  @override
  State<PatientDetailsView> createState() => _PatientDetailsViewState();
}

class _PatientDetailsViewState extends State<PatientDetailsView> {
  late PatientDetailsViewModel _viewModel;
  final PatientValidator _validator = PatientValidator();

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<PatientDetailsViewModel>();
    _viewModel.patient = widget.patient;
    _viewModel.onSavePatientCommand.addListener(_onSave);
  }

  void _onSave() {
    if (_viewModel.onSavePatientCommand.isFailure) {
      final failure = _viewModel.onSavePatientCommand.value as FailureCommand;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(failure.error.toString()),
      ));
    }
  }

  @override
  void dispose() {
    _viewModel.onSavePatientCommand.removeListener(_onSave);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 215, 186, 232),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Perfil do Paciente",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () => _showShareBottomSheet(context),
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () => _showEditBottomSheet(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  InkWell(
                    onTap: () async {
                      String? image = await _showDialogSelectImage(context);
                      if (image != null) {
                        _viewModel.patient.photoUrl = image;
                        _viewModel.onSavePatientCommand.execute();
                        setState(() {});
                      }
                    },
                    child: _viewModel.patient.photoUrl != null &&
                            _viewModel.patient.photoUrl!.isNotEmpty
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
                                  Image.file(File(_viewModel.patient.photoUrl!))
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
                                _viewModel.patient.name
                                    .substring(0, 2)
                                    .toUpperCase(),
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
                    _viewModel.patient.name,
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
                      _viewModel.patient.email,
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Color.fromARGB(255, 193, 214, 255),
                    ),
                  ),
                  icon: Icon(
                    Icons.phone_in_talk,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onPressed: () => _showPhoneCallBottomSheet(context),
                ),
                IconButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Color.fromARGB(255, 193, 214, 255),
                    ),
                  ),
                  icon: Icon(
                    Icons.chat,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onPressed: () => _showPhoneCallBottomSheet(context),
                ),
                IconButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Color.fromARGB(255, 193, 214, 255),
                    ),
                  ),
                  icon: Icon(
                    Icons.mail,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onPressed: () => _showPhoneCallBottomSheet(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.white),
            const SizedBox(height: 16),
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
                      _viewModel.patient.phone,
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
                    if (_viewModel.patient.cpf != null &&
                        _viewModel.patient.cpf!.isNotEmpty)
                      Icon(
                        Icons.fingerprint_rounded,
                        color: Colors.white,
                      ),
                    const SizedBox(width: 5),
                    Text(
                      _viewModel.patient.cpf ?? '',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_viewModel.patient.rg != null &&
                        _viewModel.patient.rg!.isNotEmpty)
                      Icon(
                        Icons.badge_rounded,
                        color: Colors.white,
                      ),
                    const SizedBox(width: 5),
                    Text(
                      _viewModel.patient.rg ?? '',
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
                const Text(
                  "Anotações",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Color.fromARGB(255, 193, 214, 255),
                    ),
                  ),
                  icon: Icon(
                    Icons.post_add_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => _addAnotation(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditBottomSheet(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateBottomSheet) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.80,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Text('Paciente'),
                      const SizedBox(height: 20),
                      if (_viewModel.patient.photoUrl != null &&
                          _viewModel.patient.photoUrl!.isNotEmpty)
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
                                Image.file(File(_viewModel.patient.photoUrl!))
                                    .image,
                          ),
                        )
                      else
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Color.fromARGB(255, 193, 214, 255),
                          child: Text(
                            _viewModel.patient.name
                                .substring(0, 2)
                                .toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      TextFormField(
                        initialValue: _viewModel.patient.name,
                        onChanged: (value) {
                          _viewModel.patient.name = value;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator:
                            _validator.byField(_viewModel.patient, 'name'),
                        decoration: InputDecoration(
                          labelText: 'Nome',
                          border: OutlineInputBorder(),
                          errorStyle: TextStyle(color: Colors.red),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        initialValue: _viewModel.patient.email,
                        onChanged: (value) {
                          _viewModel.patient.email = value;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator:
                            _validator.byField(_viewModel.patient, 'email'),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          border: OutlineInputBorder(),
                          errorStyle: TextStyle(color: Colors.red),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        initialValue: _viewModel.patient.phone,
                        onChanged: (value) {
                          _viewModel.patient.phone = value;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator:
                            _validator.byField(_viewModel.patient, 'phone'),
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
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        initialValue: _viewModel.patient.cpf,
                        onChanged: (value) {
                          _viewModel.patient.cpf = value;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator:
                            _validator.byField(_viewModel.patient, 'cpf'),
                        inputFormatters: [
                          MaskTextInputFormatter(
                              mask: '###.###.###-##',
                              filter: {"#": RegExp(r'[0-9]')}),
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
                        initialValue: _viewModel.patient.rg,
                        onChanged: (value) {
                          _viewModel.patient.rg = value;
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
                        listenable: _viewModel.onSavePatientCommand,
                        builder: (context, _) {
                          return ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                Color.fromARGB(255, 193, 214, 255),
                              ),
                              foregroundColor: WidgetStateProperty.all<Color>(
                                Colors.white,
                              ),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: _viewModel.onSavePatientCommand.isRunning
                                ? null
                                : () {
                                    if (_validator
                                        .validate(_viewModel.patient)
                                        .isValid) {
                                      _viewModel.onSavePatientCommand.execute();
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
      },
    );
  }

  Widget _showPhoneCallBottomSheet(BuildContext context) {
    return Center(child: Text('Phone call'));
  }

  Widget _addAnotation(BuildContext context) {
    return Center(child: Text('Add anotation'));
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

  void _showShareBottomSheet(BuildContext context) {
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
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centraliza os ícones
              children: <Widget>[
                IconButton(
                  icon: Image.asset('assets/icons/whatsapp.png',
                      height: 48, width: 48),
                  onPressed: () {
                    _share(SocialPlatform.whatsapp);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: Image.asset('assets/icons/telegram.png',
                      height: 48, width: 48),
                  onPressed: () {
                    _share(SocialPlatform.telegram);
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

  void _share(SocialPlatform platform) async {
    final contentText =
        'Nome: ${_viewModel.patient.name}\nEmail:${_viewModel.patient.email}\nTelefone:${_viewModel.patient.phone}';
    await SocialSharingPlus.shareToSocialMedia(platform, contentText);
  }
}
