import 'package:login_mobile/features/auth/domain/domain.dart';

class UserMapper {

  static User userJsonToEntity(Map<String, dynamic> json) {
    return User(
      //uuid: json['uuid'],
      //username: json['username'],
      //statusCode: json['statusCode'],
      //message: json['message'],
      token: json['jwt']
    );
  }
}
