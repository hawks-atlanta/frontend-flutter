import 'package:login_mobile/features/auth/domain/domain.dart';

class UserMapper {

  static User userJsonToEntity(Map<String, dynamic> json) {
    return User(
      //TODO: setup new user model with new fields returned from Proxy...
      //uuid: json['uuid'],
      username: json['username'],
      //statusCode: json['statusCode'],
      //message: json['message'],
      token: json['token']
    );
  }
}
