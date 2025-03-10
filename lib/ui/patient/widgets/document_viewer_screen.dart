import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class DocumentViewerScreen extends StatelessWidget {
  final String fileName;
  final Uint8List bytes;
  final String fileType;

  const DocumentViewerScreen({
    super.key,
    required this.fileName,
    required this.bytes,
    required this.fileType,
  });

  Future<String> _saveToTempFile() async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/$fileName');
    await tempFile.writeAsBytes(bytes);
    return tempFile.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(fileName)),
      body: FutureBuilder<String>(
        future: _saveToTempFile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar o arquivo: ${snapshot.error}'),
            );
          }

          final filePath = snapshot.data!;

          switch (fileType.toLowerCase()) {
            case 'pdf':
              return FlutterPDFView(
                filePath: filePath,
                onError: (error) {
                  return Center(child: Text('Erro ao abrir PDF: $error'));
                },
              );
            case 'png':
              return Center(
                child: Image.memory(
                  bytes,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('Erro ao carregar a imagem');
                  },
                ),
              );
            default:
              return const Center(child: Text('Tipo de arquivo não suportado'));
          }
        },
      ),
    );
  }
}

class FlutterPDFView extends StatelessWidget {
  final String filePath;

  const FlutterPDFView({super.key, required this.filePath, this.onError});

  final Function(dynamic)? onError;

  @override
  Widget build(BuildContext context) {
    return PDFView(
      filePath: filePath,
      onError: onError,
    );
  }
}
