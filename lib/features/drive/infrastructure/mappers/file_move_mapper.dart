import 'package:login_mobile/features/drive/domain/entities/file_upload.dart';

class FileMoveMapper {
  static MoveFileResponse fileJsonToEntity(Map<String, dynamic> json) {
    return MoveFileResponse(msg: json['msg']);
  }
}
