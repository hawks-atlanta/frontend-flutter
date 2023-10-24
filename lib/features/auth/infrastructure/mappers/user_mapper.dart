import 'package:login_mobile/features/auth/domain/domain.dart';

class UserMapper {

  static User userJsonToEntity(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      token: json['token']
    );
  }
}
