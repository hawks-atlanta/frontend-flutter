import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_mobile/features/auth/infrastructure/infrastructure.dart';
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
    } on CustomError catch (e) {
      state = state.copyWith(
          isSharing: false, isShared: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
          isSharing: false,
          isShared: false,
          errorMessage: 'Confirm the username');
    }
  }

  shareListWithWho(String fileUUID) async {
    state = state.copyWith(isLoading: true);
    try {
      final shareList = await fileRepository.shareListWithWho(fileUUID);
      state = state.copyWith(isLoading: false, fileUUID: fileUUID);
      return shareList;
    } on CustomError catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: e.message, fileUUID: fileUUID);
    } catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: 'Error.. TODO!', fileUUID: fileUUID);
    }
  }

  Future<List<String>> getShareList(String fileUUID) async {
    final response = await fileRepository.shareListWithWho(fileUUID);
    final shareList = response.usernames;
    state = state.copyWith(shareList: shareList);
    return shareList;
  }
}

class ShareState {
  final bool isLoading;
  final bool isSharing;
  final bool isShared;
  final String errorMessage;
  final String? fileUUID;
  final List<String> shareList;

  ShareState({
    this.isLoading = false,
    this.isSharing = false,
    this.isShared = false,
    this.errorMessage = '',
    this.fileUUID,
    this.shareList = const [],
  });

  factory ShareState.initial() {
    return ShareState(
      isLoading: false,
      isSharing: false,
      isShared: false,
      errorMessage: '',
      fileUUID: null,
      shareList: [],
    );
  }

  ShareState copyWith({
    bool? isLoading,
    bool? isSharing,
    bool? isShared,
    String? errorMessage,
    String? fileUUID,
    List<String>? shareList,
  }) {
    return ShareState(
      isLoading: isLoading ?? this.isLoading,
      isSharing: isSharing ?? this.isSharing,
      isShared: isShared ?? this.isShared,
      errorMessage: errorMessage ?? this.errorMessage,
      fileUUID: fileUUID ?? this.fileUUID,
      shareList: shareList ?? this.shareList,
    );
  }
}
