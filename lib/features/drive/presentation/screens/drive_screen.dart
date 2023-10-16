import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_mobile/features/drive/presentation/providers/files_get_provider.dart';
import 'package:login_mobile/features/drive/presentation/providers/upload_provider.dart';
import 'package:login_mobile/features/shared/shared.dart';
import 'package:login_mobile/features/drive/presentation/widgets/files_view.dart';
import 'package:login_mobile/features/shared/widgets/drive/new_modal.dart';

class CapyDriveScreen extends ConsumerWidget {
  final String? locationId;

  const CapyDriveScreen({this.locationId, Key? key}) : super(key: key);

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final uploadState = ref.watch(filesProvider);

    ref.listen(filesProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    print("locationID in CapyDriveScreen: $locationId");

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('CapyFiles 𐃶'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => ref.read(filesGetProvider.notifier).goBack(),
          ),
          //IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: Stack(
        children: [
          FilesView(locationId: locationId), //pasar el ID
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
      floatingActionButton: FloatingActionButton.extended(
        label:
            const Icon(Icons.add), // El FAB siempre muestra el icono de agregar
        onPressed: () {
          showNewModal(context, ref);
        },
      ),
    );
  }
}
