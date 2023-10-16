import 'package:login_mobile/features/drive/domain/datasources/file_datasources.dart';
import 'package:login_mobile/features/drive/domain/entities/file.dart';
import 'package:login_mobile/features/drive/domain/entities/file_upload.dart';
import 'package:login_mobile/features/drive/domain/repositories/file_repository.dart';
// El único objetivo de FileRepositoryImpl es usar el dataSource
// El dataSource lo satisface
class FilesRepositoryImpl extends FilesRepository {
  final FileDataSource dataSource;

  FilesRepositoryImpl(this.dataSource);

  @override
  Future<FileUploadResponse> uploadFiles(String fileName,
      List<String> fileContent, String? location ) {
    return dataSource.uploadFiles(fileName, fileContent, location);
  }

  @override
  Future<FileCheckResponse> checkFile(String fileUUID) {
    return dataSource.checkFile(fileUUID);
  }

  @override
  Future<List<File>> getFiles(String? location) {
    return dataSource.getFiles(location);
  }
}
