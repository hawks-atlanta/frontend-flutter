import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_mobile/features/drive/presentation/providers/providers.dart';
import 'package:login_mobile/features/shared/shared.dart';
import 'package:login_mobile/features/drive/presentation/widgets/files_view.dart';
import 'package:login_mobile/features/shared/widgets/drive/new_modal.dart';

class CapyDriveScreen extends ConsumerWidget {
  const CapyDriveScreen({Key? key}) : super(key: key);

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  void listenForErrors(
      BuildContext context, WidgetRef ref, ProviderBase provider) {
    ref.listen(provider, (previous, next) {
      final errorMessage = (next as dynamic).errorMessage as String?;
      if (errorMessage == null || errorMessage.isEmpty) return;
      showSnackbar(context, errorMessage);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final uploadState = ref.watch(filesProvider);
    final movingFileState = ref.read(fileMoveProvider).moving;

    listenForErrors(context, ref, filesProvider);
    listenForErrors(context, ref, filesGetProvider);
    listenForErrors(context, ref, fileMoveProvider);
    listenForErrors(context, ref, fileMoveProvider);

    //final location = ref.read(filesGetProvider).location;
    //print("Location in CapyDriveScreen: $location");

    return Scaffold(
      // Operador logico, si está en moviendo archivo muestra el widget para cancelar el mover archivo si no se está moviendo muestra el drawer
      drawer: movingFileState
          ? const SizedBox.shrink()
          : SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('CapyFiles 𐃶'),
        actions: [
          ref.watch(filesGetProvider).locationHistory.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => ref
                      .read(filesGetProvider.notifier)
                      .goBack(isShared: false),
                )
              : const SizedBox.shrink(),
          ref.watch(fileMoveProvider).moving
              ? IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () =>
                      ref.read(fileMoveProvider.notifier).fileMoveCancel(),
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: Stack(
        children: [
          const UnifiedFilesView(),
          // Si hay archivos que se están cargando, mostramos el CircularProgressIndicator
          if (uploadState.uploads
              .any((upload) => upload.fileStatus == FileUploadStatus.isLoading))
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 80.0),
                child: CircularProgressIndicator(strokeWidth: 5),
              ),
            )
        ],
      ),
      // operador lógico si el state de move file es en true muestra el widget para mover file en la location actual
      //le paso el location actual para que sepa en que carpeta se encuentra y el state de true lo que haría es enviar el uuid del archivo a mover
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 29, 29, 29),
        label:
            movingFileState ? const Text("Move Here") : const Icon(Icons.add),
        onPressed: movingFileState
            ? () async {
                final location = ref.read(filesGetProvider).location;
                final fileMoveUUID = ref.read(fileMoveProvider).fileMoveUUID;
                await ref
                    .read(fileMoveProvider.notifier)
                    .fileMove(fileMoveUUID, location ?? '');
                await ref.read(filesGetProvider.notifier).getFiles();
              }
            : () {
                showNewModal(context, ref);
              },
      ),
    );
  }
}
