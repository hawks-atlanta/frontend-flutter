import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:login_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:login_mobile/features/shared/shared.dart';

//! 1 - State del provider
class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Username username;
  final Password password;

  LoginFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.username = const Username.pure(),
      this.password = const Password.pure()});

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Username? username,
    Password? password,
  }) =>
      LoginFormState(
        //si no lo tenemos va a ser igual al valor del estado
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        username: username ?? this.username,
        password: password ?? this.password,
      );

  @override
  String toString() {
    return '''
      isPosting: $isPosting,
      isFormPosted: $isFormPosted,
      isValid: $isValid,
      username: $username,
      password: $password
    ''';
  }
}

//state: manda a notificar a todos los listen cuando hay un camibo de estado
// LoginFormNotifier es el que controla cuando cambia el email y el password
//! 2 - Cómo implemenrtamos un notifier provider
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Function(String, String, {bool biometric}) loginUserCallback;
  LoginFormNotifier({required this.loginUserCallback})
      : super(LoginFormState());
  onUsernameChange(String value) {
    final newUsername = Username.dirty(value);
    state = state.copyWith(
        username: newUsername,
        isValid: Formz.validate(
            [newUsername, state.password]) //me verifica todos los campos
        );
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate(
            [newPassword, state.username]) //me verifica todos los campos
        );
  }

  onFormSubmitted() async {
    _touchEveryField();
    if (!state.isValid) {
      return;
    }
    state = state.copyWith(isPosting: true); //actualiza el estado

    await loginUserCallback(state.username.value, state.password.value);

    state = state.copyWith(isPosting: false);
  }

  onFormSubmittedBiometric(String username) async {
    //Validate only the password since the username comes from authState.
    final newPassword = Password.dirty(state.password.value);

    state = state.copyWith(
      isFormPosted: true,
      password: newPassword,
      isValid: Formz.validate([newPassword]),
    );

    if (!state.isValid) {
      return;
    }

    state = state.copyWith(isPosting: true);

    await loginUserCallback(username, state.password.value, biometric: true);

    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final username = Username.dirty(state.username.value);
    final password = Password.dirty(state.password.value);
    state = state.copyWith(
        isFormPosted: true,
        username: username,
        password: password,
        isValid: Formz.validate([username, password]));
  }
}

/*
autoDispose: cuando salga del login y salga a la app principal, se va a destruir el provider (texto user y pass)
*/
//! 3 - Cómo lo usamos este StateNotifierProvider - consume afuera
final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  final loginUserCallback = ref.watch(authProvider.notifier).loginUser;
  return LoginFormNotifier(loginUserCallback: loginUserCallback);
});
