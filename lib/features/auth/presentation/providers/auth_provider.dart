/*
Tiene la implementación del repositorio, el cual se conecta al dataSource
Nos permite a nosotros llegar a nuestro backend directamente
(Repositorio -> DataSource -> Backend)
****************************************************************
DataSource tiene las conexiones e implementaciones necesarias
token -> biometric activate
tempToken -> login/register
*/

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:login_mobile/features/auth/infrastructure/infrastructure.dart';
import 'package:login_mobile/features/shared/infrastructure/inputs/services/key_value_storage_impl.dart';
import 'package:login_mobile/features/shared/infrastructure/inputs/services/key_value_storage_services.dart';
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

  Future<void> loginUser(String username, String password,
      {bool biometric = false, bool authBiometric = false}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final user = await authRepository.login(username, password);
      //De momento el repositorio no devuelve el username solo token
      /// se asigna el username al User
      user.username = username;
      if (biometric == false) {
        _setTempLoggedUser(user);
      }
      if (biometric == true && state.user != null) {
        _setBiometricLoggedUser(user);
      }
    } on CustomError catch (e) {
      if (biometric == false) {
        logout(e.message);
      } else {
        biometricError(e.message);
      }
    } catch (e) {
      if (biometric == false) {
        logout('Something went wrong');
      } else {
        biometricError('Your username or password is incorrect');
      }
    }
  }

  Future<void> registerUser(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final user = await authRepository.register(username, password);
      user.username = username;
      _setTempLoggedUser(user);
    } on CustomError catch (e) {
      noRegister(e.message);
    } catch (e) {
      noRegister('Something went wrong');
    }
  }

  void noRegister([String? errorMessage]) async {
    state = state.copyWith(
        user: null,
        errorMessage: errorMessage,
        authStatus: AuthStatus.notAuthenticated);
  }

//ver si es valido el token que contiene el usuario
  void checkAuthStatus() async {
    //Manejamos los estados de auth dependiendo del token si existe o no
    //Si existe el token, lo verificamos
    //Primero intentamos con el token de biometría
    final biometricToken =
        await keyValueStorageService.getValue<String>('token');
    if (biometricToken != null) {
      _verifyToken(biometricToken);
      return;
    }
    //Después intentamos con el token temporal
    final tempToken =
        await keyValueStorageService.getValue<String>('tempToken');
    // Independientemente de si tempToken es nulo o no, ejecutamos el logout
    // y ajustamos el estado.
    // Ya que tempToken indica usuario temporal!
    state = state.copyWith(hasBiometric: false);
    logout();
    // Luego, si tempToken no es nulo, puedes verificarlo o hacer
    // cualquier lógica adicional si es necesario.
    if (tempToken != null) {
      return;
      //_verifyToken(tempToken);
      // [Lógica adicional aquí si tempToken existe, de momento no]
    }
    //Si llegamos hasta aquí, no hay token.
    // [Posiblemente lógica adicional aquí si no hay token]
  }

  void _verifyToken(String token) async {
    try {
      final user = await authRepository.checkAuthStatus(token);
      // Set new token
      await keyValueStorageService.setKeyValue('token', user.token);
      _setBiometricLoggedUser(user);
    } catch (e) {
      logout();
    }
  }

  void _setTempLoggedUser(User user) async {
    // Si es temp no se guarda el username pero se guarda el token y el state
    await keyValueStorageService.setKeyValue('tempToken', user.token);
    state = state.copyWith(
        user: user, errorMessage: '', authStatus: AuthStatus.authenticated);
  }

  Future<void> _setBiometricLoggedUser(User user) async {
    String usernameAsString = user.username.toString();
    await keyValueStorageService.setKeyValue('token', user.token);
    await keyValueStorageService.setKeyValue('username', usernameAsString);
    await keyValueStorageService.setKeyValue('hasBiometric', true);
    state = state.copyWith(
      user: user,
      errorMessage: '',
      authStatus: AuthStatus.authenticated,
      hasBiometric: true,
    );
  }

  void disableBiometric(ref) async {
    await keyValueStorageService.removeKey('token');
    await keyValueStorageService.removeKey('hasBiometric');
    await keyValueStorageService.removeKey('username');
    await keyValueStorageService.removeKey('tempToken');
    state = state.copyWith(
        user: null,
        errorMessage: '',
        authStatus: AuthStatus.notAuthenticated,
        hasBiometric: false);
    //Aqui puedo abrir otro modal
    // showModalBottomSheet(
    //     isScrollControlled: true,
    //     context: ref,
    //     builder: (context) => const CustomLogin());
  }

//Elimina el token solamente cuando la biometría no está activa
  Future<void> logout([String? errorMessage]) async {
    final hasBiometric = state.hasBiometric;
    // Always delete the 'tempToken'
    await keyValueStorageService.removeKey('tempToken');
    // If the user has biometric, delete the token and username
    if (hasBiometric != true) {
      await keyValueStorageService.removeKey('token');
      await keyValueStorageService.removeKey('username');
      await keyValueStorageService.removeKey('tempToken');
    }
    state = state.copyWith(
      user: null,
      errorMessage: errorMessage,
      authStatus: AuthStatus.notAuthenticated,
    );
  }

  Future<void> biometricError([String? errorMessage]) async {
    state = state.copyWith(
        user: null,
        errorMessage: errorMessage,
        authStatus: AuthStatus.notAuthenticated);
  }

// se usa en handleBiometricAuthentication() de side_menu.dart
  Future<bool> authWithBiometrics() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if (authenticated) {
        state = state.copyWith(authStatus: AuthStatus.authenticated);
      } else {
        state = state.copyWith(
            authStatus: AuthStatus.notAuthenticated,
            user: null,
            errorMessage: 'Biometric authentication failed');
      }
    } on PlatformException catch (e) {
      state = state.copyWith(
          user: null,
          errorMessage: 'Error - ${e.message}',
          authStatus: AuthStatus.notAuthenticated);
    }
    return authenticated;
  }

  Future<bool> loginWithBiometrics() async {
    try {
      final token = await keyValueStorageService.getValue<String>('token');
      if (token == null) {
        state = state.copyWith(
          errorMessage: 'Token not found',
          authStatus: AuthStatus.notAuthenticated,
        );
        return false;
      }
      //!TODO: Validar si es necesario guardar el token acá
      final user = await authRepository.checkAuthStatus(token);
      await keyValueStorageService.setKeyValue('token', user.token);
      final username =
          await keyValueStorageService.getValue<String>('username');
      user.username = username;
      state = state.copyWith(
        user: user,
        errorMessage: '',
        authStatus: AuthStatus.checking,
      );
      authWithBiometrics();
      return true;
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Error: $e',
        authStatus: AuthStatus.notAuthenticated,
      );
      return false;
    }
  }
}

enum AuthStatus { checking, authenticated, notAuthenticated, hasBiometric }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;
  final bool? hasBiometric;

  AuthState(
      {this.authStatus = AuthStatus.checking,
      this.user,
      this.errorMessage = '',
      this.hasBiometric});

  AuthState copyWith(
          {AuthStatus? authStatus,
          User? user,
          String? errorMessage,
          bool? hasBiometric}) =>
      AuthState(
        authStatus: authStatus ?? this.authStatus,
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
        hasBiometric: hasBiometric ?? this.hasBiometric,
      );
}
