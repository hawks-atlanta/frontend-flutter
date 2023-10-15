import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_mobile/features/drive/domain/repositories/file_repository.dart';
import 'files_upload_repository_provider.dart';

final filesProvider =
    StateNotifierProvider<FilesUploadNotifier, FilesUploadState>((ref) {
  final filesRepository = ref.watch(filesRepositoryProvider);
  return FilesUploadNotifier(filesRepository: filesRepository);
});

// STATE Notifier Provider
class FilesUploadNotifier extends StateNotifier<FilesUploadState> {
  final FilesRepository filesRepository;

  FilesUploadNotifier({required this.filesRepository})
      : super(FilesUploadState());

  final Map<String, Timer> _timers = {};

  Future<void> uploadFiles(
      String fileName, List<String> fileContent, String? location) async {
    try {
      final filesUpload =
          await filesRepository.uploadFiles(fileName, fileContent, location);
      final newUpload =
          FileUploadInfo(fileUUID: filesUpload.fileUUID, isLoading: true);

      state = FilesUploadState(uploads: [...state.uploads, newUpload]);

      _periodicFileCheck(filesUpload.fileUUID);
    } catch (e) {
      print(e);
    }
  }

  void _periodicFileCheck(String fileUUID) {
    const duration = Duration(seconds: 3);

    _timers[fileUUID] = Timer.periodic(duration, (Timer t) async {
      await _checkFile(fileUUID);
    });
  }

  Future<void> _checkFile(String fileUUID) async {
    try {
      final fileCheck = await filesRepository.checkFile(fileUUID);
      if (fileCheck.ready) {
        final uploadIndex =
            state.uploads.indexWhere((upload) => upload.fileUUID == fileUUID);
        final updatedUpload = state.uploads[uploadIndex].copyWith(
          isLoading: false,
          uploadSuccess: true,
        );

        state = FilesUploadState(
          uploads: [
            ...state.uploads.sublist(0, uploadIndex),
            updatedUpload,
            ...state.uploads.sublist(uploadIndex + 1),
          ],
        );

        _timers[fileUUID]?.cancel();
      }
    } catch (e) {
      print(e);
    }
  }
}

/*Limpiar Timers:
@override
void dispose() {
  _timers.values.forEach((timer) => timer.cancel());
  _timers.clear();
  super.dispose();
}
*/

// STATE
class FileUploadInfo {
  final String fileUUID;
  final bool isLoading;
  final bool uploadSuccess;

  FileUploadInfo({
    required this.fileUUID,
    this.isLoading = false,
    this.uploadSuccess = false,
  });

  FileUploadInfo copyWith({
    String? fileUUID,
    bool? isLoading,
    bool? uploadSuccess,
  }) {
    return FileUploadInfo(
      fileUUID: fileUUID ?? this.fileUUID,
      isLoading: isLoading ?? this.isLoading,
      uploadSuccess: uploadSuccess ?? this.uploadSuccess,
    );
  }
}

class FilesUploadState {
  final List<FileUploadInfo> uploads;

  FilesUploadState({
    this.uploads = const [],
  });
}
