import '../entities/user.dart';


//implementación dela definición del datasource que se va a usar para el auth
abstract class AuthRepository {
  Future<User> login(String username, String password);
  Future<User> register(String username, String password); //add more test
  Future<User> checkAuthStatus(String token);
}
