import 'package:login_mobile/features/auth/domain/domain.dart';
import '../infrastructure.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource dataSources;

  AuthRepositoryImpl({AuthDataSource? dataSources})
      : dataSources = dataSources ?? AuthDataSourceImpl();

  @override
  Future<User> checkAuthStatus(String token) {
    return dataSources.checkAuthStatus(token);
  }

  @override
  Future<User> login(String username, String password) {
    return dataSources.login(username, password);
  }

  @override
  Future<User> register(String username, String password) {
    return dataSources.register(username, password);
  }

}