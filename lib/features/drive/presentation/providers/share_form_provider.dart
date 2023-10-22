import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:login_mobile/features/auth/presentation/providers/share_provider.dart';
import 'package:login_mobile/features/shared/shared.dart';

final shareFormProvider =
    StateNotifierProvider.autoDispose<ShareFormNotifier, ShareFormState>((ref) {
  final shareFileCallback = ref.watch(shareProvider.notifier).shareFile;
  return ShareFormNotifier(shareFileCallback: shareFileCallback);
});

class ShareFormNotifier extends StateNotifier<ShareFormState> {
  final Function(String, String) shareFileCallback;
  ShareFormNotifier({required this.shareFileCallback})
      : super(ShareFormState());

  onUsernameChange(String value, String fileUUID) {
    final newUsername = Username.dirty(value);
    state = state.copyWith(
      username: newUsername,
      fileUUID: fileUUID,
      isValid: Formz.validate([newUsername]),
    );
  }

  onFormSubmitted() async {
    _touchEveryField();
    if (!state.isValid) {
      return;
    }
    state = state.copyWith(isPosting: true); //actualiza el estado

    await shareFileCallback(
      state.fileUUID,
      state.username.value,
    );

    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final username = Username.dirty(state.username.value);
    state = state.copyWith(
        isFormPosted: true,
        username: username,
        isValid: Formz.validate([username]));
  }
}

class ShareFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Username username;
  final String fileUUID;
  final String errorMessage;

  ShareFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.username = const Username.pure(),
    this.fileUUID = '',
    this.errorMessage = '',
  });

  ShareFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Username? username,
    String? fileUUID,
  }) =>
      ShareFormState(
        //si no lo tenemos va a ser igual al valor del estado
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        username: username ?? this.username,
        fileUUID: fileUUID ?? this.fileUUID,
      );

  @override
  String toString() {
    return '''
      isPosting: $isPosting,
      isFormPosted: $isFormPosted,
      isValid: $isValid,
      username: $username,
      fileUUID: $fileUUID
    ''';
  }
}
