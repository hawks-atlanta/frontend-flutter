import 'package:dio/dio.dart';
import 'package:login_mobile/config/config.dart';
import 'package:login_mobile/features/auth/infrastructure/infrastructure.dart';
import 'package:login_mobile/features/drive/domain/datasources/file_datasources.dart';
import 'package:login_mobile/features/drive/domain/entities/entities.dart';
import 'package:login_mobile/features/drive/infrastructure/mappers/mappers.dart';

class FilesDatasourceImpl extends FileDataSource {
  late final Dio dio;
  final String accessToken;

  FilesDatasourceImpl({required this.accessToken})
      : dio = Dio(BaseOptions(baseUrl: Enviroment.apiURL));

  @override
  Future<FileUploadResponse> uploadFiles(
      String fileName, List<String> fileContent, String? location) async {
    try {
      final response = await dio.post('/file/upload', data: {
        'fileName': fileName,
        'fileContent': fileContent,
        'location': location,
        'token': accessToken
      });
      final file = FileUploadMapper.fileJsonToEntity(response.data);
      return file;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token Wrong');
      }
      if (e.response?.statusCode == 409) {
        throw CustomError('File $fileName already exists in this location');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Review your internet connection');
      }
      throw Exception(e);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<FileCheckResponse> checkFile(String fileUUID) async {
    try {
      final response = await dio.post('/file/check',
          data: {'fileUUID': fileUUID, 'token': accessToken});
      return FileCheckMapper.fileJsonToEntity(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token Wrong');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Review your internet connection');
      }
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  //El list sería dio.post Lista de maps en dynamic

  @override
  Future<List<File>> getFiles({String? location}) async {
    try {
      Map<String, dynamic> data = {'token': accessToken};
      // Si location no es nulo, añadirlo al mapa de datos
      if (location != null) {
        data['location'] = location;
      }
      // Realizar la solicitud POST con los datos
      final response = await dio.post('/file/list', data: data);
      if (response.statusCode == 200) {
        List<File> files = FileMapper.fromJson(response.data);
        return files;
      } else {
        throw Exception('Error');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token Wrong');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Review your internet connection');
      }
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<FileNewDirectoryResponse> newDirectory(String directoryName,
      {String? location}) async {
    try {
      Map<String, dynamic> data = {'token': accessToken};
      // Si location no es nulo, añadirlo al mapa de datos
      if (location != null) {
        data['location'] = location;
      }
      data['directoryName'] = directoryName;
      final response = await dio.post('/file/new/directory', data: data);
      if (response.statusCode == 200) {
        FileNewDirectoryResponse fileNewDirectoryResponse =
            FileNewDirMapper.fileJsonToEntity(response.data);
        return fileNewDirectoryResponse;
      } else {
        throw Exception('Error');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token Wrong');
      }
      if (e.response?.statusCode == 409) {
        throw CustomError('Directory $directoryName already exists');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Review your internet connection');
      }
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<FileDownloadResponse> downloadFile(String fileUUID) async {
    try {
      Map<String, dynamic> data = {'token': accessToken};
      data['fileUUID'] = fileUUID;
      final response = await dio.post('/file/download', data: data);
      if (response.statusCode == 200) {
        return FileDownloadMapper.fileJsonToEntity(response.data);
      } else {
        throw Exception('Error');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token Wrong');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Review your internet connection');
      }
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<RenameFileResponse> renameFile(String fileUUID, String newName) async {
    try {
      Map<String, dynamic> data = {'token': accessToken};
      data['fileUUID'] = fileUUID;
      data['newName'] = newName;
      final response = await dio.post('/file/rename', data: data);
      if (response.statusCode == 200) {
        RenameFileResponse renameFileResponse =
            FileRenameMapper.fileJsonToEntity(response.data);
        return renameFileResponse;
      } else {
        throw Exception('Error');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token Wrong');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Review your internet connection');
      }
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<MoveFileResponse> moveFile(
      String fileUUID, String targetDirectoryUUID) async {
    try {
      Map<String, dynamic> data = {'token': accessToken};
      data['fileUUID'] = fileUUID;
      data['targetDirectoryUUID'] = targetDirectoryUUID;
      final response = await dio.put('/file/move', data: data);
      if (response.statusCode == 200) {
        MoveFileResponse moveFileResponse =
            FileMoveMapper.fileJsonToEntity(response.data);
        return moveFileResponse;
      } else {
        throw Exception('Error');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token Wrong');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Review your internet connection');
      }
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future shareFile(String fileUUID, String otherUsername) async {
    try {
      Map<String, dynamic> data = {'token': accessToken};
      data['fileUUID'] = fileUUID;
      data['otherUsername'] = otherUsername;
      final response = await dio.post('/share/file', data: data);
      if (response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Error');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token Wrong');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Review your internet connection');
      }
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<ShareListWhoResponse> shareListWithWho(String fileUUID) async {
    try {
      Map<String, dynamic> data = {'token': accessToken};
      data['fileUUID'] = fileUUID;
      final response = await dio.post('/share/list/with/who', data: data);
      if (response.statusCode == 200) {
        return ShareListWhoMapper.fileJsonToEntity(response.data);
      } else {
        throw Exception('Error');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token Wrong');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Review your internet connection');
      }
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<File>> getShareList() async {
    try {
      Map<String, dynamic> data = {'token': accessToken};
      final response = await dio.post('/share/list', data: data);
      if (response.statusCode == 200) {
        List<File> files = ShareListMapper.fromJson(response.data);
        return files;
      } else {
        throw Exception('Error');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token Wrong');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Review your internet connection');
      }
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> accountPasswordChange(
      String oldPassword, String newPassword) async {
    try {
      Map<String, dynamic> data = {'token': accessToken};
      data['oldPassword'] = oldPassword;
      data['newPassword'] = newPassword;
      final response = await dio.post('/account/password', data: data);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Error');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('OldPassword Wrong');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Review your internet connection');
      }
      
      
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> unShareFile(String fileUUID, String otherUsername) async {
    try {
      Map<String, dynamic> data = {'token': accessToken};
      data['fileUUID'] = fileUUID;
      data['otherUsername'] = otherUsername;
      final response = await dio.post('/unshare/file', data: data);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Error');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token Wrong');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Review your internet connection');
      }
      if (e.response?.statusCode == 500) {
        throw CustomError('Internal Server Error');
      }
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> deleteFile(List<String> fileUUID) async {
    try {
      Map<String, dynamic> data = {'token': accessToken};
      data['fileUUID'] = fileUUID;
      final response = await dio.post('/file/delete', data: data);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Error');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw CustomError('File $fileUUID is shared');
      }
      if (e.response?.statusCode == 401) {
        throw CustomError('Token Wrong');
      }
      if (e.response?.statusCode == 404) {
        throw CustomError('File $fileUUID not found (Server)');
      }
      if (e.response?.statusCode == 500) {
        throw CustomError('Internal Server Error');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Review your internet connection');
      }
      throw Exception(e);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
