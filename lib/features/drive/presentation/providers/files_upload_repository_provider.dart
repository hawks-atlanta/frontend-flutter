// Establecer a lo largo de la APP la instancia de nuestro file repository implementation
// Poder tomar a toda la APP todo el repositorio

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:login_mobile/features/drive/domain/repositories/file_repository.dart';
import 'package:login_mobile/features/drive/infrastructure/datasources/file_datasource_impl.dart';
import 'package:login_mobile/features/drive/infrastructure/repositories/file_repository_impl.dart';

//ReadOnly provider
final filesRepositoryProvider = Provider<FilesRepository>((ref) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';
  print("Token: $accessToken");

  final filesRepository =
      FilesRepositoryImpl(FilesDatasourceImpl(accessToken: accessToken));

  return filesRepository;
});
