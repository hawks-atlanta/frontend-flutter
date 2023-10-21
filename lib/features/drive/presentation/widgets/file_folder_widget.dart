import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_mobile/features/drive/domain/entities/file.dart';
import 'package:login_mobile/features/drive/presentation/providers/download_provider.dart';

class FileOrFolderWidget extends ConsumerStatefulWidget {
  final File file;

  const FileOrFolderWidget({
    super.key,
    required this.file,
  });

  @override
  FileOrFolderWidgetState createState() => FileOrFolderWidgetState();
}

class FileOrFolderWidgetState extends ConsumerState<FileOrFolderWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading:
            Icon(widget.file.isFile ? Icons.insert_drive_file : Icons.folder),
        title: Text(widget.file.name),
        //onTap: () => context.go('/folder/${file.uuid}'),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                print(widget.file.uuid);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.download),
                      title: const Text('Download'),
                      onTap: () {
                        ref.read(filesDownloadProvider.notifier).downloadFile(widget.file.uuid);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.drive_file_move),
                      title: const Text('Move File'),
                      onTap: () {
                        // Lógica para mover
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.drive_file_rename_outline),
                      title: const Text('Rename'),
                      onTap: () {
                        // Lógica para renombrar
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text('Delete'),
                      onTap: () {
                        // Lógica para borrar
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.share),
                      title: const Text('Share'),
                      onTap: () {
                        // Lógica para compartir
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.stop_screen_share_outlined),
                      title: const Text('UnShare'),
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
