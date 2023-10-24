import 'package:login_mobile/features/drive/domain/entities/file_upload.dart';

class FileNewDirMapper {
  static FileNewDirectoryResponse fileJsonToEntity(Map<String, dynamic> json) {
    return FileNewDirectoryResponse(fileUUID: json['fileUUID']);
  }
}
