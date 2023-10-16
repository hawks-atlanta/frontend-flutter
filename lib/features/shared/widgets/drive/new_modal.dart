import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_mobile/features/drive/presentation/providers/upload_provider.dart';
import 'icon_text_button.dart';

void showNewModal(BuildContext context, WidgetRef ref) {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  showModalBottomSheet<void>(
      backgroundColor: const Color.fromARGB(119, 0, 0, 0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60.0),
          topRight: Radius.circular(60.0),
        ),
      ),
      context: context,
      builder: (context) {
        return SizedBox(
            height: 150,
            child: Row(children: [
              IconTextButton(
                name: "Folder",
                color: Colors.white,
                icon: const Icon(Icons.file_upload),
                onPress: () {},
              ),
              IconTextButton(
                  name: "Upload",
                  color: Colors.white,
                  icon: const Icon(Icons.file_upload),
                  onPress: () async {
                    await handleFileUpload(scaffoldKey, ref);
                  })
            ]));
      });
}

Future<void> handleFileUpload(
    GlobalKey<ScaffoldState> scaffoldKey, WidgetRef ref) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.any,
    allowMultiple: true,
  );
  print("Resulted files: $result");

  if (result != null) {
    for (PlatformFile file in result.files) {
      // Verificar si file.bytes es null
      if (file.bytes != null) {
        String base64String = base64Encode(file.bytes!);
        ref.read(filesProvider.notifier).uploadFiles(
              file.name,
              [base64String],
              null, //RutaActual
            );
      } else if (file.path != null) {
        // Si file.bytes es null, pero tenemos un path, intentamos leer el archivo desde el path.
        final File selectedFile = File(file.path ?? '');
        final List<int> bytes = selectedFile.readAsBytesSync();
        String base64String = base64Encode(bytes);

        ref.read(filesProvider.notifier).uploadFiles(
              file.name,
              [base64String],
              null,
            );
      } else {
        // Manejar el caso en el que file.bytes y file.path son null, quizás mostrando un mensaje al usuario.
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text('Error: ${file.name} is empty or not available'),
          ),
        );
      }
    }
  }
}
