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

  FilesGetNotifier({required this.filesRepository})
      : super(FilesGetState(locationHistory: [
          '',
        ])) {
    //también podemos probar con [null]
    getFiles();
  }

  Future getFiles() async {
    if (state.isLoading) return;
    try {
      print('Getting files for location: ${state.location}');
      state = state.copyWith(isLoading: true);
      final files = await filesRepository.getFiles(location: state.location);
      final newLocationHistory = List<String>.from(state.locationHistory);
      if (state.location != null &&
          (newLocationHistory.isEmpty ||
              newLocationHistory.last != state.location)) {
        newLocationHistory.add(state.location ?? '');
        print('Added $state.location to locationHistory: $newLocationHistory');
      }
      state = state.copyWith(
        files: files,
        isLoading: false,
        locationHistory: newLocationHistory,
      );
    } on CustomError catch (e) {
      state = state.copyWith(errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  void goLocation(String location) {
    state = state.copyWith(location: location);
    getFiles();
  }

  void goBack({bool? isShared}) {
    print('Going back. Current history: ${state.locationHistory}');
    if ((state.locationHistory).isEmpty) {
      print('No more locations in history, navigating to root');
      state = state.copyWith(locationHistory: [], location: null);
    } else {
      final newLocationHistory = List<String>.from(state.locationHistory);
      newLocationHistory.removeLast();
      final previousLocation =
          newLocationHistory.isNotEmpty ? newLocationHistory.last : null;
      print(
          'New history: $newLocationHistory, navigating to: $previousLocation');
      state = state.copyWith(
          locationHistory: newLocationHistory, location: previousLocation);
    }
    state = state.copyWith(location: state.location);
    // Llama a getFiles solo después de actualizar la ubicación
    if (isShared != null && isShared) {
      getFilesShareList();
    } else {
      getFiles();
    }
  }

  createDirectory(String directoryName) async {
    try {
      await filesRepository.newDirectory(directoryName,
          location: state.location);
      getFiles();
    } on CustomError catch (e) {
      state = state.copyWith(errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  renameFile(String fileUUID, String newName) async {
    try {
      await filesRepository.renameFile(fileUUID, newName);
      getFiles();
    } on CustomError catch (e) {
      state = state.copyWith(errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<List<File>> getFilesShareList() async {
    final response = await filesRepository.getShareList();
    final filesShareList = response;
    state = state.copyWith(files: filesShareList);
    return filesShareList;
  }

  Future<bool> deleteFile(List<String> fileUUID) async {
    try {
      final response = await filesRepository.deleteFile(fileUUID);
      if (response) {
        removeFileFromfilesList(fileUUID);
        return true;
      } else {
        state = state.copyWith(errorMessage: 'Failed to delete file');
        return false;
      }
    } on CustomError catch (e) {
      state = state.copyWith(errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  void removeFileFromfilesList(List<String> fileUUID) {
    final files = state.files;
    final newFiles = files.where((file) => !fileUUID.contains(file.uuid));
    state = state.copyWith(files: newFiles.toList());
  }
}

class FilesGetState {
  final bool isLoading;
  final List<File> files;
  final String? location;
  final List<String> locationHistory;
  final String errorMessage;

  FilesGetState({
    this.isLoading = false,
    this.files = const [],
    this.location, //por default null es la raiz "/"
    this.locationHistory = const [],
    this.errorMessage = '',
  });

  FilesGetState copyWith({
    bool? isLoading,
    List<File>? files,
    String? location,
    List<String>? locationHistory,
    String errorMessage = '',
  }) {
    return FilesGetState(
      isLoading: isLoading ?? this.isLoading,
      files: files ?? this.files,
      location: location ?? this.location,
      locationHistory: locationHistory ?? this.locationHistory,
      errorMessage: errorMessage,
    );
  }
}
