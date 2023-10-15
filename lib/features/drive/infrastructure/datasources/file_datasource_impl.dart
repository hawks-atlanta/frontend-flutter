import 'package:dio/dio.dart';
import 'package:login_mobile/config/config.dart';
import 'package:login_mobile/features/auth/infrastructure/infrastructure.dart';
import 'package:login_mobile/features/drive/domain/datasources/file_datasources.dart';
import 'package:login_mobile/features/drive/domain/entities/file_upload.dart';
import 'package:login_mobile/features/drive/infrastructure/mappers/file_check_mapper.dart';
import 'package:login_mobile/features/drive/infrastructure/mappers/file_upload_mapper.dart';

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
      print(response.data);
      final file = FileUploadMapper.fileJsonToEntity(response.data);
      return file;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token Wrong');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Review your internet connection');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<FileCheckResponse> checkFile(String fileUUID) async {
    try {
      final response = await dio.post('/file/check', data: {
        'fileUUID': fileUUID,
        'token': accessToken
      });
      return FileCheckMapper.fileJsonToEntity(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token Wrong');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Review your internet connection');
      }
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }
  //El list sería dio.post Lista de maps en dynamic
}
