import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:login_mobile/features/drive/presentation/providers/auth_account_provider.dart';
import 'package:login_mobile/features/shared/infrastructure/inputs/repeat_password.dart';
import 'package:login_mobile/features/shared/shared.dart';

final accountFormPassProvider = StateNotifierProvider.autoDispose<
    AccountPasswordNotifier, AccountPasswordFormState>((ref) {
  final accountPasswordCallback = ref.watch(accountPassProvider.notifier).changePassword; //ref.watch(authProvider.notifier).changePassword;
  return AccountPasswordNotifier(accountPasswordCallback: accountPasswordCallback);
});

class AccountPasswordNotifier extends StateNotifier<AccountPasswordFormState> {
  final Function(String, String) accountPasswordCallback;
  AccountPasswordNotifier({required this.accountPasswordCallback})
      : super(AccountPasswordFormState());

  onOldPasswordChange(String value) {
    final newOldPassword = Password.dirty(value);
    state = state.copyWith(
      oldpassword: newOldPassword,
      isValid: Formz.validate(
          [newOldPassword, state.newpassword, state.repeatNewPassword]),
    );
  }

  onNewPasswordChange(String value) {
    final newNewPassword = Password.dirty(value);
    state = state.copyWith(
      newpassword: newNewPassword,
      isValid: Formz.validate(
          [state.oldpassword, newNewPassword, state.repeatNewPassword]),
    );
  }

  onRepeatNewPasswordChange(String value) {
    if (value != state.repeatNewPassword.value) {
      value = "no";
    }
    final newRepeatNewPassword = RepeatPassword.dirty(value);
    state = state.copyWith(
      repeatNewPassword: newRepeatNewPassword,
      isValid: Formz.validate(
          [state.oldpassword, state.newpassword, newRepeatNewPassword]),
    );
  }

  onFormSubmitted() async {
    _touchEveryField();
    if (!state.isValid) {
      return;
    }
    state = state.copyWith(isPosting: true); //actualiza el estado

    await accountPasswordCallback(
      state.oldpassword.value,
      state.newpassword.value,
    );

    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final oldpassword = Password.dirty(state.oldpassword.value);
    final newpassword = Password.dirty(state.newpassword.value);
    final repeatNewPassword =
        RepeatPassword.dirty(state.repeatNewPassword.value);
    state = state.copyWith(
        isFormPosted: true,
        oldpassword: oldpassword,
        newpassword: newpassword,
        repeatNewPassword: repeatNewPassword,
        isValid: Formz.validate(
            [oldpassword, newpassword, repeatNewPassword]));
  }
}

class AccountPasswordFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Password oldpassword;
  final Password newpassword;
  final RepeatPassword repeatNewPassword;

  AccountPasswordFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false, //entrada sin modif
      this.oldpassword = const Password.pure(), //entrada sin modif
      this.newpassword = const Password.pure(), //entrada sin modif
      this.repeatNewPassword = const RepeatPassword.pure()});

  AccountPasswordFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Password? oldpassword,
    Password? newpassword,
    RepeatPassword? repeatNewPassword,
  }) =>
      AccountPasswordFormState(
        //por defecto tiene el valor del estado inicial
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        oldpassword: oldpassword ?? this.oldpassword,
        newpassword: newpassword ?? this.newpassword,
        repeatNewPassword: repeatNewPassword ?? this.repeatNewPassword,
      );

  @override
  String toString() {
    return '''
      isPosting: $isPosting,
      isFormPosted: $isFormPosted,
      isValid: $isValid,
      oldpassword: $oldpassword,
      newpassword: $newpassword,
      repeatNewPassword: $repeatNewPassword,
    ''';
  }
}
