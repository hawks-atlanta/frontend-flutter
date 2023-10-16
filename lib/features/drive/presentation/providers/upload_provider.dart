import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_mobile/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:login_mobile/features/drive/domain/repositories/file_repository.dart';
import 'files_upload_repository_provider.dart';

final filesProvider =
    StateNotifierProvider<FilesUploadNotifier, FileUploadState>((ref) {
  final filesRepository = ref.watch(filesRepositoryProvider);
  return FilesUploadNotifier(filesRepository: filesRepository);
});

// STATE Notifier Provider
class FilesUploadNotifier extends StateNotifier<FileUploadState> {
  final FilesRepository filesRepository;

  FilesUploadNotifier({required this.filesRepository})
      : super(FileUploadState());

  final Map<String, Timer> _timers = {};

  @override
  void dispose() {
    for (var timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
    super.dispose();
  }

  Future<void> uploadFiles(
      String fileName, List<String> fileContent, String? location) async {
    try {
      final filesUpload =
          await filesRepository.uploadFiles(fileName, fileContent, location);
      final newUpload = FileUploadInfo(fileUUID: filesUpload.fileUUID);
      state = FileUploadState(uploads: [...state.uploads, newUpload]);
      _periodicFileCheck(filesUpload.fileUUID);
    } on CustomError catch (e) {
      errorMsg(e.message);
    } catch (e) {
      errorMsg(e.toString());
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
          fileStatus: FileUploadStatus.success,
        );

        state = FileUploadState(
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
      _timers[fileUUID]?.cancel();
      errorMsg(e.toString(), fileUUID, FileUploadStatus.error);
    }
  }

  Future<void> errorMsg(
      [String? errorMessage,
      String? fileUUID,
      FileUploadStatus? fileStatus]) async {
    state = state.copyWith(
      errorMessage: errorMessage ?? '',
    );
    state = FileUploadState(
      uploads: [
        ...state.uploads,
        FileUploadInfo(
          fileUUID: fileUUID ?? '',
          fileStatus: fileStatus ?? FileUploadStatus.error,
          errorMessage: errorMessage ?? '',
        ),
      ],
    );
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

enum FileUploadStatus { isLoading, success, error }

// STATE
class FileUploadInfo {
  final String fileUUID;
  final FileUploadStatus fileStatus;
  final String errorMessage;

  FileUploadInfo({
    required this.fileUUID,
    this.fileStatus = FileUploadStatus.isLoading,
    this.errorMessage = '',
  });

  FileUploadInfo copyWith({
    String? fileUUID,
    FileUploadStatus? fileStatus,
    String? errorMessage,
  }) =>
      FileUploadInfo(
        fileUUID: fileUUID ?? this.fileUUID,
        fileStatus: fileStatus ?? this.fileStatus,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}

class FileUploadState {
  final List<FileUploadInfo> uploads;
  final String errorMessage;

  FileUploadState({
    this.uploads = const [],
    this.errorMessage = '',
  });

  FileUploadState copyWith({
    List<FileUploadInfo>? uploads,
    String? errorMessage,
  }) =>
      FileUploadState(
        uploads: uploads ?? this.uploads,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
