import 'package:login_mobile/features/drive/domain/entities/file.dart';

class ShareListMapper {
  static List<File> fromJson(Map<String, dynamic> json) {
    if (json['sharedFiles'] == null) {
      return [];
    }
    return (json['sharedFiles'] as List).map((data) => File.fromJson(data)).toList();
  }
}