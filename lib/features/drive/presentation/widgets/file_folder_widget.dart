import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_mobile/features/drive/domain/entities/file.dart';
import 'package:login_mobile/features/drive/presentation/providers/download_provider.dart';
import 'package:login_mobile/features/drive/presentation/providers/file_move_provider.dart';
import 'package:login_mobile/features/drive/presentation/providers/files_get_provider.dart';
import 'package:login_mobile/features/shared/widgets/drive/dialog_rename_folder.dart';

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
                        ref
                            .read(filesDownloadProvider.notifier)
                            .downloadFile(widget.file.uuid);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.drive_file_move),
                      title: const Text('Move File'),
                      //Le paso el archivo que estoy moviendo
                      //El state pasaría a true si pasa a true quiere decir que se está moviendo un archivo
                      // y la UI cambiaría la lógica en el drive_screen o files_view
                      // 1) muevo un archivo
                      // 2) el state pasa a true
                      // 3) la UI cambia y muestra el widget para mover el archivo
                      // 4) el usuario selecciona la carpeta a donde mover
                      // 5) el usuario le da al botón enviar y se saca la location del state location
                      // 6) se envia la location y el uuid del archivo a mover
                      // 7) el state pasa a false

                      // Lógica para renombrar
                      //read.read(nombreProvider.notifier).renameFile(widget.file.uuid)
                      onTap: () {
                        /*
                        final location = ref.read(filesGetProvider).location;
                        ref
                            .read(fileMoveProvider.notifier)
                            .fileMove(widget.file.uuid, location);
                        */
                        ref.read(fileMoveProvider.notifier).fileMoveInitial(fileMoveUUID: widget.file.uuid);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.drive_file_rename_outline),
                      title: const Text('Rename'),
                      onTap: () => showDialog(
                          context: context,
                          builder: (context) {
                            return DialogWidget(
                                title: 'Rename File',
                                buttonTitle: 'Rename',
                                hintText: widget.file.name,
                                onButtonPressed: (String value) => ref
                                    .read(filesGetProvider.notifier)
                                    .renameFile(widget.file.uuid, value));
                          }),
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
