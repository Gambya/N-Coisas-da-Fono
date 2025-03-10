import 'package:flutter/material.dart';
import 'package:ncoisasdafono/domain/entities/document.dart';
import 'package:ncoisasdafono/ui/patient/widgets/document_viewer_screen.dart';

class AnnotationCard extends StatefulWidget {
  final String text;
  final VoidCallback? onEditPressed;
  final List<Document> files;
  final Function(int)? onDeleteFile;

  const AnnotationCard({
    super.key,
    required this.text,
    this.onEditPressed,
    this.files = const [], // Lista padrão vazia
    this.onDeleteFile,
  });

  @override
  State<AnnotationCard> createState() => _AnnotationCardState();
}

class _AnnotationCardState extends State<AnnotationCard> {
  final Map<int, bool> _isDeleting = {};

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.files.length; i++) {
      _isDeleting[i] = false;
    }
  }

  @override
  void didUpdateWidget(covariant AnnotationCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.files.length != oldWidget.files.length) {
      setState(() {
        _isDeleting.clear();
        for (int i = 0; i < widget.files.length; i++) {
          _isDeleting[i] = false;
        }
      });
    }
  }

  String _getFileType(String? fileName) {
    if (fileName == null) return 'unknown';
    final extension = fileName.split('.').last.toLowerCase();
    return extension;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 193, 214, 255),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 100.0,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Positioned(
                top: 0.0,
                right: 0.0,
                child: IconButton(
                  padding: EdgeInsets.all(0.0),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Color.fromARGB(255, 215, 186, 232),
                    ),
                  ),
                  onPressed: widget.onEditPressed,
                  icon: const Icon(Icons.edit),
                  iconSize: 18.0,
                  color: Colors.white,
                ),
              ),
              Text(
                widget.text,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10.0),
              if (widget.files.isNotEmpty)
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: List.generate(widget.files.length, (index) {
                    final document = widget.files[index];
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
                            backgroundColor:
                                const Color.fromARGB(255, 193, 214, 255)
                                    .withOpacity(0.8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          icon: Icon(
                            fileType == 'pdf'
                                ? Icons.picture_as_pdf
                                : fileType == 'png'
                                    ? Icons.image
                                    : Icons.insert_drive_file,
                            size: 16.0,
                          ),
                          label: Text(
                            fileName,
                            style: const TextStyle(fontSize: 12.0),
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
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  if (widget.onDeleteFile != null &&
                                      document.id != 0) {
                                    setState(() {
                                      _isDeleting[index] = true;
                                    });
                                    try {
                                      await Future.delayed(
                                        const Duration(
                                          seconds: 1,
                                        ),
                                      );
                                      widget.onDeleteFile!(index);
                                    } finally {
                                      setState(() {
                                        _isDeleting[index] = false;
                                      });
                                    }
                                  }
                                },
                              ),
                      ],
                    );
                  }),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
