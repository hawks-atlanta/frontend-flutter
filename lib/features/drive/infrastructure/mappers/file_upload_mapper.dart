import 'package:login_mobile/features/drive/domain/entities/file_upload.dart';

class FileUploadMapper {
  static FileUploadResponse fileJsonToEntity(Map<String, dynamic> json) {
    return FileUploadResponse(fileUUID: json['fileUUID']);
  }
}
