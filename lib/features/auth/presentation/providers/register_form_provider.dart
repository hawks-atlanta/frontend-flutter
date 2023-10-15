import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:login_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:login_mobile/features/shared/infrastructure/inputs/repeat_password.dart';
import 'package:login_mobile/features/shared/shared.dart';

final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
        (ref) {
  final registerUserCallback = ref.watch(authProvider.notifier).registerUser;
  return RegisterFormNotifier(registerUserCallback: registerUserCallback);
});

class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Username username;
  final Password password;
  final RepeatPassword repeatPassword;

  RegisterFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.username = const Username.pure(), //entrada sin modif
      this.password = const Password.pure(), //entrada sin modif
      this.repeatPassword = const RepeatPassword.pure()});

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Username? username,
    Password? password,
    RepeatPassword? repeatPassword,
  }) =>
      RegisterFormState(
        //por defecto tiene el valor del estado inicial
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        username: username ?? this.username,
        password: password ?? this.password,
        repeatPassword: repeatPassword ?? this.repeatPassword,
      );

  @override
  String toString() {
    return '''
      isPosting: $isPosting,
      isFormPosted: $isFormPosted,
      isValid: $isValid,
      username: $username,
      password: $password,
      repeatPassword: $repeatPassword,
    ''';
  }
}

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Function(String, String) registerUserCallback;
  RegisterFormNotifier({required this.registerUserCallback})
      : super(RegisterFormState());

  onUsernameChange(String value) {
    final newUsername = Username.dirty(value);
    state = state.copyWith(
        username: newUsername,
        isValid: Formz.validate(
            [newUsername, state.password, state.repeatPassword]));
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate(
            [newPassword, state.username, state.repeatPassword]));
  }

  onRepeatPasswordChanged(String value) {
    if (value != state.password.value) {
      value = "no";
    }
    final newRepeatPassword = RepeatPassword.dirty(value);
    state = state.copyWith(
        repeatPassword: newRepeatPassword,
        isValid: Formz.validate(
            [newRepeatPassword, state.username, state.password]));
  }

  onFormSubmitted() async {
    _touchEveryField();
    if (!state.isValid) {
      return;
    }
    state = state.copyWith(isPosting: true);

    await registerUserCallback(state.username.value, state.password.value);

    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final username = Username.dirty(state.username.value);
    final password = Password.dirty(state.password.value);
    final repeatpassword = RepeatPassword.dirty(state.repeatPassword.value);
    state = state.copyWith(
        isFormPosted: true,
        username: username,
        password: password,
        repeatPassword: repeatpassword,
        isValid: Formz.validate([username, password, repeatpassword]));
  }
}
