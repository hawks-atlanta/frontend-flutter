import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_mobile/features/drive/presentation/providers/files_get_provider.dart';

final syncProvider = Provider<SyncInterface>((ref) {
  final filesGetProviderNotifier = ref.watch(filesGetProvider.notifier);
  return SyncInterface(filesGetProviderNotifier);
});

class SyncInterface {
  final FilesGetNotifier filesGetProviderNotifier;

  SyncInterface(this.filesGetProviderNotifier);

  void onFileUploadSuccess(String? location) {
    filesGetProviderNotifier.getFiles(location: location);
  }
}
