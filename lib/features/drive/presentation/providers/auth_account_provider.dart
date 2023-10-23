import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_mobile/features/auth/infrastructure/infrastructure.dart';
import 'package:login_mobile/features/drive/domain/repositories/file_repository.dart';
import 'package:login_mobile/features/drive/presentation/providers/files_upload_repository_provider.dart';

final accountPassProvider =
    StateNotifierProvider<AccountPassNotifier, AccountPassState>((ref) {
  final fileRepository = ref.watch(filesRepositoryProvider);
  return AccountPassNotifier(fileRepository: fileRepository);
});

class AccountPassNotifier extends StateNotifier<AccountPassState> {
  final FilesRepository fileRepository;

  AccountPassNotifier({required this.fileRepository})
      : super(AccountPassState());

  void _handleError(Object e) {
    String errorMessage;
    if (e is CustomError) {
      errorMessage = e.message;
    } else if (e is Exception) {
      errorMessage = 'An exception occurred: ${e.toString()}';
    } else if (e is Error) {
      errorMessage = 'An error occurred: ${e.toString()}';
    } else {
      errorMessage = 'Unknown error';
    }
    state = state.copyWith(
        isLoading: false,
        changeSuccess: false,
        changeError: true,
        errorMessage: errorMessage);
  }

  changePassword(String oldPassword, String newPassword) async {
    state = state.copyWith(isLoading: true);
    try {
      final response =
          await fileRepository.accountPasswordChange(oldPassword, newPassword);
      state = state.copyWith(
          isLoading: false,
          changeSuccess: response,
          changeError: !response,
          errorMessage: '');
    } catch (e) {
      _handleError(e);
    }
  }
}

class AccountPassState {
  final bool isLoading;
  final bool changeSuccess;
  final bool changeError;
  final String errorMessage;

  AccountPassState({
    this.isLoading = false,
    this.changeSuccess = false,
    this.changeError = false,
    this.errorMessage = '',
  });

  AccountPassState copyWith({
    bool? isLoading,
    bool? changeSuccess,
    bool? changeError,
    String? errorMessage,
  }) =>
      AccountPassState(
        isLoading: isLoading ?? this.isLoading,
        changeSuccess: changeSuccess ?? this.changeSuccess,
        changeError: changeError ?? this.changeError,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
