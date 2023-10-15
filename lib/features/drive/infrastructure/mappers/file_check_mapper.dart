import 'package:login_mobile/features/drive/domain/entities/file_upload.dart';

class FileCheckMapper {
  static FileCheckResponse fileJsonToEntity(Map<String, dynamic> json) {
    return FileCheckResponse(ready: json['ready']);
  }
}
