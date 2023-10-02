/*
Tiene la implementación del repositorio, el cual se conecta al dataSource
Nos permite a nosotros llegar a nuestro backend directamente
(Repositorio -> DataSource -> Backend)
****************************************************************
DataSource tiene las conexiones e implementaciones necesarias
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:login_mobile/features/auth/infrastructure/infrastructure.dart';
import 'package:login_mobile/features/shared/infrastructure/inputs/services/key_value_storage_impl.dart';
import 'package:login_mobile/features/shared/infrastructure/inputs/services/key_value_storage_services.dart';
import 'package:login_mobile/features/shared/widgets/bottom_sheet.dart';
import '../../domain/domain.dart';

/*
Nos permite cambiar si tengo otro de dataSource,
yo cambio el dataSource y no tengo que cambiar nada en el code
*/
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return AuthNotifier(
      authRepository: authRepository,
      keyValueStorageService: keyValueStorageService);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;
  final LocalAuthentication auth = LocalAuthentication();

  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
  }) : super(AuthState()) {
    checkAuthStatus();
  } //no hace falta mandar nada porque todo son valores opcinonales
  //estas funciones terminan delegando en el repositorio

  Future<void> loginUser(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(username, password);
      _setLoggedUser(user);
      _setUsername(username);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Something went wrong');
    }
    //final user = await authRepository.login(email, password);
    //state = state.copyWith(user: user, authStatus: AuthStatus.authenticated); //copia del usuario donde ya tengo el estado
  }

  //TODO: implementar el registro
  void registerUser(String email, String password) async {}

//ver si es valido el token que contiene el usuario
  void checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');
    if (token == null) return logout();
    try {
      //el repositorio hace la auth
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }
  }

  void _setLoggedUser(User user) async {
    await keyValueStorageService.setKeyValue('token', user.token);
    state = state.copyWith(
        user: user, errorMessage: '', authStatus: AuthStatus.authenticated);
  }

  void _setUsername(String username) async {
    await keyValueStorageService.setKeyValue('username', username);
  }

  Future<void> logout([String? errorMessage]) async {
    await keyValueStorageService.removeKey('token');
    await keyValueStorageService.removeKey('username');
    state = state.copyWith(
        user: null,
        errorMessage: errorMessage,
        authStatus: AuthStatus.notAuthenticated);
  }

  Future<void> authenticateWithBiometrics(ref) async {
    bool authenticated = false;
    try {
      // Actualiza el estado para indicar que se está autenticando
      state = state.copyWith(authStatus: AuthStatus.checking);

      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if (authenticated) {
        // Si la autenticación fue exitosa, actualiza el estado para indicar que está autenticado
        state = state.copyWith(authStatus: AuthStatus.authenticated);
        showModalBottomSheet(
            isScrollControlled: true,
            context: ref,
            builder: (context) => const CustomLogin());
      } else {
        // Si la autenticación falló, actualiza el estado para indicar que no está autenticado
        state = state.copyWith(authStatus: AuthStatus.notAuthenticated);
      }
    } on PlatformException catch (e) {
      print(e);
      // En caso de excepción, actualiza el estado con un mensaje de error
      state = state.copyWith(errorMessage: 'Error - ${e.message}');
    }
  }
}

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState(
      {this.authStatus = AuthStatus.checking,
      this.user,
      this.errorMessage = ''});

  AuthState copyWith(
          {AuthStatus? authStatus, User? user, String? errorMessage}) =>
      AuthState(
        authStatus: authStatus ?? this.authStatus,
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
