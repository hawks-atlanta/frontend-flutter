import 'package:login_mobile/features/drive/domain/entities/file_upload.dart';

class FileDownloadMapper {
  static FileDownloadResponse fileJsonToEntity(Map<String, dynamic> json) {
    return FileDownloadResponse(
      fileContent: json['fileContent'],
      fileName: json['fileName']
    );
  }
}