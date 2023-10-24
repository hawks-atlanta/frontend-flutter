import 'package:login_mobile/features/drive/domain/entities/share.dart';

class ShareListWhoMapper {
  static ShareListWhoResponse fileJsonToEntity(Map<String, dynamic> json) {
    List<String> usernamesList = [];
    if (json.containsKey('usernames') && json['usernames'] != null) {
      usernamesList = List<String>.from(json['usernames']);
    }
    return ShareListWhoResponse(usernames: usernamesList);
  }
}
