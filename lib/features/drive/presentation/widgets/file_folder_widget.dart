import 'package:flutter/material.dart';
import 'package:login_mobile/features/drive/domain/entities/file.dart';

class FileOrFolderWidget extends StatelessWidget {
  final File file;

  const FileOrFolderWidget({
    super.key, required this.file,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(file.isFile ? Icons.insert_drive_file : Icons.folder),
        title: Text(file.name),
        onTap: () {
          print(file.uuid);
        },
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                print(file.uuid);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.download),
                      title: const Text('Descargar'),
                      onTap: () {
                        // Lógica de descarga
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.drive_file_move),
                      title: const Text('Mover'),
                      onTap: () {
                        // Lógica para mover
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.drive_file_rename_outline),
                      title: const Text('Renombrar'),
                      onTap: () {
                        // Lógica para renombrar
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text('Borrar'),
                      onTap: () {
                        // Lógica para borrar
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.share),
                      title: const Text('Compartir'),
                      onTap: () {
                        // Lógica para compartir
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.stop_screen_share_outlined),
                      title: const Text('Descompartir'),
                      onTap: () {
                        // Lógica para descompartir
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
