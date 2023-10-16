//Establece en toda la app la instancia del product repository implemantation

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_mobile/features/auth/infrastructure/infrastructure.dart';
import 'package:login_mobile/features/drive/domain/entities/file.dart';
import 'package:login_mobile/features/drive/domain/repositories/file_repository.dart';
import 'package:login_mobile/features/drive/presentation/providers/files_upload_repository_provider.dart';

/*
Si se utiliza el filesGetProvider y se crea la instancia de FilesGetNotifier
Automaticamente va a cargar los archivos de la raiz siento la raiz el valor por defecto (null)
*/
final filesGetProvider =
    StateNotifierProvider<FilesGetNotifier, FilesGetState>((ref) {
  final filesGetRepository = ref.watch(filesRepositoryProvider);
  return FilesGetNotifier(filesRepository: filesGetRepository);
});

class FilesGetNotifier extends StateNotifier<FilesGetState> {
  final FilesRepository filesRepository;

  FilesGetNotifier({required this.filesRepository}) : super(FilesGetState()) {
    getFiles();
  }

  Future getFiles({String? location}) async {
    if (state.isLoading) return;
    try {
      state = state.copyWith(isLoading: true);
      final files = await filesRepository.getFiles(location);
      state =
          state.copyWith(files: [...state.files, ...files], isLoading: false);
    } on CustomError catch (e) {
      print(e.message);
    } catch (e) {
      print(e.toString());
    }
  }
}

class FilesGetState {
  final bool isLoading;
  final List<File> files;

  FilesGetState({
    this.isLoading = false,
    this.files = const [],
  });

  FilesGetState copyWith({
    bool? isLoading,
    List<File>? files,
  }) {
    return FilesGetState(
      isLoading: isLoading ?? this.isLoading,
      files: files ?? this.files,
    );
  }
}
