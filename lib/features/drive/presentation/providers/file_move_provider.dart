import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_mobile/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:login_mobile/features/drive/domain/repositories/file_repository.dart';
import 'package:login_mobile/features/drive/presentation/providers/files_upload_repository_provider.dart';

final fileMoveProvider =
    StateNotifierProvider<FileMoveNotifier, FileMoveState>((ref) {
  final filesRepository = ref.watch(filesRepositoryProvider);
  return FileMoveNotifier(filesRepository: filesRepository);
});

class FileMoveNotifier extends StateNotifier<FileMoveState> {
  final FilesRepository filesRepository;

  FileMoveNotifier({required this.filesRepository}) : super(FileMoveState());

  fileMove(String fileUUID, String targetDirectoryUUID) async {
    try {
      state = state.copywith(movingStatus: MovingStatus.loading);
      await filesRepository.moveFile(fileUUID, targetDirectoryUUID);
      state = state.copywith(movingStatus: MovingStatus.initial, moving: false);
    } on CustomError catch (e) {
      state = state.copywith(
          movingStatus: MovingStatus.failed, errorMessage: e.message);
    } catch (e) {
      state = state.copywith(
          movingStatus: MovingStatus.failed, errorMessage: e.toString());
    }
  }

  fileMoveInitial({String? fileMoveUUID}) {
    state = state.copywith(moving: true, fileMoveUUID: fileMoveUUID);
  }

  fileMoveCancel() {
    state = state.copywith(
        movingStatus: MovingStatus.initial, moving: false, fileMoveUUID: '');
  }
}

enum MovingStatus { initial, loading, failed }

class FileMoveState {
  final bool moving;
  final MovingStatus movingStatus;
  final String? errorMessage;
  final String fileMoveUUID;
  final String? targetDirectoryUUID;

  FileMoveState({
    this.movingStatus = MovingStatus.initial,
    this.errorMessage = '',
    this.targetDirectoryUUID = '',
    this.fileMoveUUID = '',
    this.moving = false,
  });

  FileMoveState copywith({
    MovingStatus? movingStatus,
    String? errorMessage,
    String? fileMoveUUID,
    String? targetDirectoryUUID,
    bool? moving,
  }) {
    return FileMoveState(
      movingStatus: movingStatus ?? this.movingStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      fileMoveUUID: fileMoveUUID ?? this.fileMoveUUID,
      targetDirectoryUUID: targetDirectoryUUID ?? this.targetDirectoryUUID,
      moving: moving ?? this.moving,
    );
  }

/*
  factory FileMoveState.initial(String? fileUUID) {
    return FileMoveState(
        isLoading: false, isDone: false, isFailed: false, moving: true, fileUUID: fileUUID);
  }

  factory FileMoveState.loading() {
    return FileMoveState(
      isLoading: true,
      isDone: false,
      isFailed: false,
    );
  }

  factory FileMoveState.done() {
    return FileMoveState(
      isLoading: false,
      isDone: true,
      isFailed: false,
      moving: false,
      fileUUID: ''
    );
  }

  factory FileMoveState.failed(String error) {
    return FileMoveState(
      isLoading: false,
      isDone: false,
      isFailed: true,
      error: error,
      fileUUID: '',
      moving: false
    );
  }
  */
}
