class FileUploadResponse {
  final String fileUUID;

  FileUploadResponse({
    required this.fileUUID,
  });
}

class FileCheckResponse {
  final bool ready;

  FileCheckResponse({
    required this.ready,
  });
}

class FileNewDirectoryResponse{
  final String fileUUID;

  FileNewDirectoryResponse({
    required this.fileUUID,
  });
}

class FileDownloadResponse {
  final String? fileName;
  final String fileContent;

  FileDownloadResponse({
    required this.fileName,
    required this.fileContent,
  });
}

class RenameFileResponse {
  final String msg;

  RenameFileResponse({
    required this.msg,
  });
}

class MoveFileResponse {
  final String msg;

  MoveFileResponse({
    required this.msg,
  });
}