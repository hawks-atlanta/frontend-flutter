import 'package:login_mobile/features/drive/domain/datasources/file_datasources.dart';
import 'package:login_mobile/features/drive/domain/entities/entities.dart';
import 'package:login_mobile/features/drive/domain/repositories/file_repository.dart';

// El único objetivo de FileRepositoryImpl es usar el dataSource
// El dataSource lo satisface
class FilesRepositoryImpl extends FilesRepository {
  final FileDataSource dataSource;

  FilesRepositoryImpl(this.dataSource);

  @override
  Future<FileUploadResponse> uploadFiles(
      String fileName, List<String> fileContent, String? location) {
    return dataSource.uploadFiles(fileName, fileContent, location);
  }

  @override
  Future<FileCheckResponse> checkFile(String fileUUID) {
    return dataSource.checkFile(fileUUID);
  }

  @override
  Future<List<File>> getFiles({String? location}) {
    return dataSource.getFiles(location: location);
  }

  @override
  Future<FileNewDirectoryResponse> newDirectory(String directoryName,
      {String? location}) {
    return dataSource.newDirectory(directoryName, location: location);
  }

  @override
  Future<FileDownloadResponse> downloadFile(String fileUUID) {
    return dataSource.downloadFile(fileUUID);
  }

  @override
  Future<RenameFileResponse> renameFile(String fileUUID, String newName) {
    return dataSource.renameFile(fileUUID, newName);
  }

  @override
  Future<MoveFileResponse> moveFile(
      String fileUUID, String targetDirectoryUUID) {
    return dataSource.moveFile(fileUUID, targetDirectoryUUID);
  }

  @override
  Future shareFile(String fileUUID, String otherUsername) {
    return dataSource.shareFile(fileUUID, otherUsername);
  }

  @override
  Future<ShareListWhoResponse> shareListWithWho(String fileUUID) {
    return dataSource.shareListWithWho(fileUUID);
  }

  @override
  Future<List<File>> getShareList() {
    return dataSource.getShareList();
  }
  
  @override
  Future<bool> accountPasswordChange(String oldPassword, String newPassword) {
    return dataSource.accountPasswordChange(oldPassword, newPassword);
  }
  
  @override
  Future<bool> unShareFile(String fileUUID, String otherUsername) {
    return dataSource.unShareFile(fileUUID, otherUsername);
  }
}
