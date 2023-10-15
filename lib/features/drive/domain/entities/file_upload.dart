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
