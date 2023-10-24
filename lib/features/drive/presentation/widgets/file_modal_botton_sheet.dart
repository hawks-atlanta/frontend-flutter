import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_mobile/features/auth/presentation/providers/share_provider.dart';
import 'package:login_mobile/features/drive/domain/entities/entities.dart';
import 'package:login_mobile/features/drive/presentation/providers/providers.dart';
import 'package:login_mobile/features/drive/presentation/screens/share_file_list_screen.dart';
import 'package:login_mobile/features/shared/widgets/drive/dialog_rename_folder.dart';

class FileModalBottomSheet extends ConsumerWidget {
  final File file;

  const FileModalBottomSheet({super.key, required this.file});

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(filesDownloadProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    ref.listen(filesGetProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });
print(file.uuid); 
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.download),
          title: const Text('Download'),
          onTap: () {
            ref.read(filesDownloadProvider.notifier).downloadFile(file.uuid);
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
            ref
                .read(fileMoveProvider.notifier)
                .fileMoveInitial(fileMoveUUID: file.uuid);
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
                    hintText: file.name,
                    onButtonPressed: (String value) => ref
                        .read(filesGetProvider.notifier)
                        .renameFile(file.uuid, value));
              }),
        ),
        ListTile(
          leading: const Icon(Icons.delete),
          title: const Text('Delete'),
          onTap: () {
            ref.read(filesGetProvider.notifier).deleteFile([file.uuid]);
          },
        ),
        ListTile(
          leading: const Icon(Icons.share),
          title: const Text('Share'),
          onTap: () {
            ref.watch(shareProvider.notifier).getShareListWithWho(file.uuid);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ShareFileListScreen(fileUUID: file.uuid)));
          },
        ),
      ],
    );
  }
}
