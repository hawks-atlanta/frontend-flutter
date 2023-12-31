import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_mobile/features/auth/infrastructure/infrastructure.dart';
import 'package:login_mobile/features/drive/domain/entities/file.dart';
import 'package:login_mobile/features/drive/domain/repositories/file_repository.dart';
import 'package:login_mobile/features/drive/presentation/providers/files_upload_repository_provider.dart';

final shareProvider = StateNotifierProvider<ShareNotifier, ShareState>((ref) {
  final fileRepository = ref.watch(filesRepositoryProvider);
  return ShareNotifier(fileRepository: fileRepository);
});

class ShareNotifier extends StateNotifier<ShareState> {
  final FilesRepository fileRepository;

  ShareNotifier({required this.fileRepository}) : super(ShareState.initial());

  shareFile(String fileUUID, String otherUsername) async {
    state = state.copyWith(isSharing: true);
    try {
      await fileRepository.shareFile(fileUUID, otherUsername);
      state = state.copyWith(isSharing: false, isShared: true);
      getShareListWithWho(fileUUID);
    } on CustomError catch (e) {
      state = state.copyWith(
          isSharing: false, isShared: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
          isSharing: false,
          isShared: false,
          errorMessage: 'Invalid user or user not found');
    }
  }

  shareListWithWho(String fileUUID) async {
    state = state.copyWith(isLoading: true);
    try {
      final shareListWithWho = await fileRepository.shareListWithWho(fileUUID);
      state = state.copyWith(isLoading: false, fileUUID: fileUUID);
      return shareListWithWho;
    } on CustomError catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: e.message, fileUUID: fileUUID);
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          errorMessage: 'Error when using ShareListWithWho $e',
          fileUUID: fileUUID);
    }
  }

  Future<List<String>> getShareListWithWho(String fileUUID) async {
    final response = await fileRepository.shareListWithWho(fileUUID);
    final shareListWithWho = response.usernames;
    state =
        state.copyWith(shareListWithWho: shareListWithWho, errorMessage: '');
    return shareListWithWho;
  }

  Future<bool> unShareFile(String fileUUID, String otherUsername) async {
    try {
      final response =
          await fileRepository.unShareFile(fileUUID, otherUsername);
      if (response) {
        removeUserFromShareList(otherUsername);
        state = state.copyWith(errorMessage: '');
        return true;
      } else {
        state = state.copyWith(
            errorMessage: 'Error when using unShareFile, response is false');
      }
      return false;
    } on CustomError catch (e) {
      state = state.copyWith(errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(errorMessage: 'Error when using unShareFile $e');
      return false;
    }
  }

  void removeUserFromShareList(String username) {
    final updatedList = List<String>.from(state.shareListWithWho);
    updatedList.remove(username);
    state = state.copyWith(shareListWithWho: updatedList);
  }
}

class ShareState {
  final bool isLoading;
  final bool isSharing;
  final bool isShared;
  final String errorMessage;
  final String? fileUUID;
  final List<String> shareListWithWho;

  ShareState({
    this.isLoading = false,
    this.isSharing = false,
    this.isShared = false,
    this.errorMessage = '',
    this.fileUUID,
    this.shareListWithWho = const [],
  });

  factory ShareState.initial() {
    return ShareState(
      isLoading: false,
      isSharing: false,
      isShared: false,
      errorMessage: '',
      fileUUID: null,
      shareListWithWho: [],
    );
  }

  ShareState copyWith({
    bool? isLoading,
    bool? isSharing,
    bool? isShared,
    String? errorMessage,
    String? fileUUID,
    List<String>? shareListWithWho,
    List<File>? filesShareList,
  }) {
    return ShareState(
      isLoading: isLoading ?? this.isLoading,
      isSharing: isSharing ?? this.isSharing,
      isShared: isShared ?? this.isShared,
      errorMessage: errorMessage ?? this.errorMessage,
      fileUUID: fileUUID ?? this.fileUUID,
      shareListWithWho: shareListWithWho ?? this.shareListWithWho,
    );
  }
}
