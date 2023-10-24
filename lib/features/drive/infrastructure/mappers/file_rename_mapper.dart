import 'package:login_mobile/features/drive/domain/entities/file_upload.dart';

class FileRenameMapper {
  static RenameFileResponse fileJsonToEntity(Map<String, dynamic> json) {
    return RenameFileResponse(msg: json['msg']);
  }
}
