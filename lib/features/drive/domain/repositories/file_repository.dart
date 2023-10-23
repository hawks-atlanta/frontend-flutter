import 'package:login_mobile/features/drive/domain/entities/file.dart';
import 'package:login_mobile/features/drive/domain/entities/file_upload.dart';
import 'package:login_mobile/features/drive/domain/entities/share.dart';

abstract class FilesRepository {
  Future<FileUploadResponse> uploadFiles(
      String fileName, List<String> fileContent, String? location);
  Future<FileCheckResponse> checkFile(String fileUUID);
  Future<List<File>> getFiles({String? location});
  Future<FileNewDirectoryResponse> newDirectory(String directoryName,
      {String? location});
  Future<FileDownloadResponse> downloadFile(String fileUUID);
  Future<RenameFileResponse> renameFile(String fileUUID, String newName);
  Future<MoveFileResponse> moveFile(
      String fileUUID, String targetDirectoryUUID);
  Future shareFile(String fileUUID, String otherUsername);
  Future<ShareListWhoResponse> shareListWithWho(String fileUUID);
  Future<List<File>> getShareList();
  Future accountPasswordChange(String oldPassword, String newPassword);
}
