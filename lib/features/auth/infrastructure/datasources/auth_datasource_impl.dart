import 'package:dio/dio.dart';
import 'package:login_mobile/config/config.dart';
import 'package:login_mobile/features/auth/domain/datasource/auth_datasource.dart';
import 'package:login_mobile/features/auth/domain/entities/user.dart';
import 'package:login_mobile/features/auth/infrastructure/infrastructure.dart';

class AuthDataSourceImpl extends AuthDataSource {
  final dio = Dio(BaseOptions(
    baseUrl: Enviroment.apiURL,
  ));

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.post('/refreshtoken',
          data: {'token': token},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token wrong');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> login(String username, String password) async {
    try {
      final responde = await dio
          .post('/login', data: {'username': username, 'password': password});
      final user = UserMapper.userJsonToEntity(responde.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(e.response?.data['message'] ?? 'Credentials wrong');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Review your internet connection');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> register(String username, String password) async {
    // TODO: implement register
    try {
      final responde = await dio.post('/register',
          data: {'username': username, 'password': password});
      final user = UserMapper.userJsonToEntity(responde.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
            e.response?.data['message'] ?? 'Username already registered');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Review your internet connection');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }
}
