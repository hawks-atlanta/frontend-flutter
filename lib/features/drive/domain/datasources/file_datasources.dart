import 'package:login_mobile/features/drive/domain/entities/file.dart';
import 'package:login_mobile/features/drive/domain/entities/file_upload.dart';

/// No pretende implementar nada
/// Solo definimos las reglas

abstract class FileDataSource {
  Future<FileUploadResponse> uploadFiles(
      String fileName, List<String> fileContent, String? location);
  Future<FileCheckResponse> checkFile(String fileUUID);
  Future<List<File>> getFiles({String? location});
  Future<FileNewDirectoryResponse> newDirectory(String directoryName,
      {String? location});
  Future<FileDownloadResponse> downloadFile(String fileUUID);
}
