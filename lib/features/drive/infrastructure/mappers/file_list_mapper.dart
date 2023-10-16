import 'package:login_mobile/features/drive/domain/entities/file.dart';

class FileMapper {
  static List<File> fromJson(Map<String, dynamic> json) {
    return (json['files'] as List).map((data) => File.fromJson(data)).toList();
  }
}
