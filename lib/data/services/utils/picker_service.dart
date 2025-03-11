import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ncoisasdafono/ui/themes/colors.dart';

class PickedFile {
  final String path;
  final Uint8List? bytes;
  final String fileName;

  PickedFile({
    required this.path,
    this.bytes,
    required this.fileName,
  });
}

class PickerService {
  final ImagePicker _picker = ImagePicker();
  final ImageCropper _cropper = ImageCropper();

  Future<PickedFile?> showFileSourceDialog(BuildContext context) async {
    return await showDialog<PickedFile?>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Center(
            child: const Text("Selecione"),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Câmera"),
                onTap: () async {
                  final result =
                      await _selectImage(ImageSource.camera, dialogContext);
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext, result);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Galeria"),
                onTap: () async {
                  final result =
                      await _selectImage(ImageSource.gallery, dialogContext);
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext, result);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text("Documentos"),
                onTap: () async {
                  final result = await _selectDocument(dialogContext);
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext, result);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<PickedFile?> _selectImage(
      ImageSource source, BuildContext context) async {
    try {
      final XFile? file = await _picker.pickImage(source: source);
      if (file != null) {
        final CroppedFile? croppedFile = await _cropImage(file);
        if (croppedFile != null) {
          final fileName = file.name;
          final bytes = await croppedFile.readAsBytes();
          return PickedFile(
            path: croppedFile.path,
            bytes: bytes,
            fileName: fileName,
          );
        }
      }
      return null;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao selecionar imagem: $e'),
          ),
        );
      }
      return null;
    }
  }

  Future<PickedFile?> _selectDocument(BuildContext context) async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final platformFile = result.files.first;
        final path = platformFile.path;
        final bytes = platformFile.bytes;
        final fileName = platformFile.name;

        if (path == null) {
          throw Exception('Caminho do arquivo não encontrado.');
        }

        final fileBytes = bytes ?? await File(path).readAsBytes();

        return PickedFile(
          path: path,
          bytes: fileBytes,
          fileName: fileName,
        );
      }
      return null;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao selecionar documento: $e'),
          ),
        );
      }
      return null;
    }
  }

  Future<CroppedFile?> _cropImage(XFile file) async {
    return await _cropper.cropImage(
      sourcePath: file.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Imagem',
          toolbarColor: AppColors.purplePrimary,
          activeControlsWidgetColor: AppColors.purplePrimary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
      ],
    );
  }
}
