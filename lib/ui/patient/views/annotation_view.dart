import 'package:flutter/material.dart';
import 'package:ncoisasdafono/domain/entities/annotation.dart';
import 'package:ncoisasdafono/domain/entities/patient.dart';
import 'package:ncoisasdafono/ui/patient/viewmodels/annotation_view_model.dart';
import 'package:result_command/result_command.dart';

class AnnotationView extends StatefulWidget {
  final AnnotationViewModel viewModel;
  final Patient patient;
  final Annotation? annotation;
  const AnnotationView(
      {super.key,
      required this.viewModel,
      required this.patient,
      this.annotation});

  @override
  State<AnnotationView> createState() => _AnnotationViewState();
}

class _AnnotationViewState extends State<AnnotationView> {
  late AnnotationViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    _viewModel.onRegisterAnnotationCommand
        .addListener(_onRegisterAnnotationCommandChanged);

    _viewModel.onSaveAnnotationCommand
        .addListener(_onSaveAnnotationCommandChanged);

    if (widget.annotation != null) {
      _viewModel.annotation = widget.annotation!;
    } else {
      _viewModel.annotation = Annotation(text: "");
      _viewModel.annotation.patient.target = widget.patient;
    }
  }

  void _onSaveAnnotationCommandChanged() {
    if (_viewModel.onSaveAnnotationCommand.isSuccess) {
      Navigator.of(context).pop();
    } else if (_viewModel.onSaveAnnotationCommand.isFailure) {
      final failure =
          _viewModel.onSaveAnnotationCommand.value as FailureCommand;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(failure.error.toString()),
      ));
    }
  }

  void _onRegisterAnnotationCommandChanged() {
    if (_viewModel.onRegisterAnnotationCommand.isSuccess) {
      Navigator.of(context).pop();
    } else if (_viewModel.onRegisterAnnotationCommand.isFailure) {
      final failure =
          _viewModel.onRegisterAnnotationCommand.value as FailureCommand;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(failure.error.toString()),
      ));
    }
  }

  @override
  void dispose() {
    _viewModel.onRegisterAnnotationCommand
        .removeListener(_onRegisterAnnotationCommandChanged);
    _viewModel.onSaveAnnotationCommand
        .removeListener(_onSaveAnnotationCommandChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _showAppBar(),
      body: _showBody(),
    );
  }

  _showAppBar() {
    return AppBar(
      title: Text('Anotação'),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.transparent,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Container(
          color: Colors.grey,
          height: 1.0,
        ),
      ),
    );
  }

  _showBody() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Color.fromARGB(255, 193, 214, 255),
                    ),
                    minimumSize: WidgetStateProperty.all(const Size(80, 20)),
                    padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    elevation: WidgetStateProperty.all(.5),
                  ),
                  icon: Icon(
                    Icons.attach_file,
                    color: Colors.white,
                    size: 14.0,
                  ),
                  label: Text(
                    'Anexar',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12.0,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {},
                ),
                SizedBox(width: 10.0),
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Color.fromARGB(255, 193, 214, 255),
                    ),
                    minimumSize: WidgetStateProperty.all(const Size(80, 20)),
                    padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    elevation: WidgetStateProperty.all(.5),
                  ),
                  icon: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 14.0,
                  ),
                  label: Text(
                    'Photo',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12.0,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            TextFormField(
              initialValue: _viewModel.annotation.text,
              onChanged: (value) {
                _viewModel.annotation.text = value;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              minLines: 20,
              maxLines: 20,
              textAlign: TextAlign.justify,
              decoration: InputDecoration(
                labelText: 'Anotação',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
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
              onPressed: _viewModel.onRegisterAnnotationCommand.isRunning ||
                      _viewModel.onSaveAnnotationCommand.isRunning
                  ? null
                  : () {
                      if (_viewModel.annotation.text.isNotEmpty) {
                        if (_viewModel.annotation.id == 0) {
                          _viewModel.onRegisterAnnotationCommand.execute();
                        } else {
                          _viewModel.onSaveAnnotationCommand.execute();
                        }
                      }
                    },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
