import 'package:flutter/material.dart';
import 'package:ncoisasdafono/data/services/utils/picker_service.dart';
import 'package:ncoisasdafono/domain/entities/annotation.dart';
import 'package:ncoisasdafono/domain/entities/document.dart';
import 'package:ncoisasdafono/domain/entities/patient.dart';
import 'package:ncoisasdafono/ui/patient/viewmodels/annotation_view_model.dart';
import 'package:ncoisasdafono/ui/patient/widgets/document_viewer_screen.dart';
import 'package:ncoisasdafono/ui/themes/colors.dart';
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
  final PickerService _pickerService = PickerService();
  final Map<int, bool> _isDeleting = {};

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
      for (int i = 0; i < _viewModel.annotation.documents.length; i++) {
        _isDeleting[i] = false;
      }
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

  String _getFileType(String? fileName) {
    if (fileName == null) return 'unknown';
    final extension = fileName.split('.').last.toLowerCase();
    return extension;
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
                  onPressed: () async {
                    final fileSource =
                        await _pickerService.showFileSourceDialog(context);
                    if (fileSource != null) {
                      _viewModel.annotation.documents.add(
                        Document(
                          bytes: fileSource.bytes,
                          fileName: fileSource.fileName,
                        ),
                      );
                      _viewModel.onSaveAnnotationCommand.execute();
                    }
                  },
                ),
              ],
            ),
            TextFormField(
              initialValue: _viewModel.annotation.text,
              onChanged: (value) {
                _viewModel.annotation.text = value;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              minLines: 15,
              maxLines: 15,
              textAlign: TextAlign.justify,
              decoration: InputDecoration(
                labelText: 'Anotação',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize:
                    MainAxisSize.min, // Usa apenas o espaço necessário
                children: [
                  if (_viewModel.annotation.documents.isNotEmpty)
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: List.generate(
                          _viewModel.annotation.documents.length, (index) {
                        final document = _viewModel.annotation.documents[index];
                        final fileName = document.fileName;
                        final fileType = _getFileType(document.fileName);
                        final bytes = document.bytes;

                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white),
                                foregroundColor: Colors.white,
                                backgroundColor: AppColors.blueSecontary
                                    .withValues(alpha: .8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 4.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              icon: Icon(
                                fileType == 'pdf'
                                    ? Icons.picture_as_pdf
                                    : (fileType == 'png' ||
                                            fileType == 'jpg' ||
                                            fileType == 'jpeg')
                                        ? Icons.image
                                        : Icons.insert_drive_file,
                                size: 16.0,
                              ),
                              label: SizedBox(
                                width: 200.0,
                                child: Text(
                                  fileName,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12.0),
                                ),
                              ),
                              onPressed: bytes != null
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DocumentViewerScreen(
                                            fileName: fileName,
                                            bytes: bytes,
                                            fileType: fileType,
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                            ),
                            _isDeleting[index] ?? false
                                ? const SizedBox(
                                    width: 16.0,
                                    height: 16.0,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.0,
                                    ),
                                  )
                                : IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      size: 16.0,
                                      color: AppColors.blueSecontary,
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        _viewModel.annotation.documents
                                            .removeAt(index);
                                      });
                                    },
                                  ),
                          ],
                        );
                      }),
                    ),
                  // Espaçador para altura mínima se não houver arquivos
                  if (_viewModel.annotation.documents.isEmpty)
                    const SizedBox(height: 20.0),
                ],
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
