import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_mobile/features/drive/domain/entities/file_upload.dart';
import 'package:login_mobile/features/drive/domain/repositories/file_repository.dart';
import 'package:login_mobile/features/drive/presentation/providers/files_upload_repository_provider.dart';
import 'package:path_provider/path_provider.dart';

final filesDownloadProvider =
    StateNotifierProvider<FilesDownloadNotifier, FileDownloadState>((ref) {
  final filesDownloadRepository = ref.watch(filesRepositoryProvider);
  return FilesDownloadNotifier(filesRepository: filesDownloadRepository);
});

class FilesDownloadNotifier extends StateNotifier<FileDownloadState> {
  final FilesRepository filesRepository;

  FilesDownloadNotifier({required this.filesRepository})
      : super(FileDownloadState.initial());

  Future<void> downloadFile(String fileUUID) async {
    try {
      state = state.copyWith(isDownloading: true);
      final fileDownload = await filesRepository.downloadFile(fileUUID);
      print(fileDownload.fileContent);
      state = state.copyWith(
        isDownloading: false,
        downloadSuccess: true,
      );
      _openFile(fileDownload);
    } catch (e) {
      state = state.copyWith(
        isDownloading: false,
        error: e.toString(),
      );
    }
  }

  _openFile(FileDownloadResponse fileDownload) async {
    try {
      //await _getStoragePermission();
      Uint8List decodedBytes = base64Decode(fileDownload.fileContent);
      final path = await getDownloadPath();
      final filePath = '$path/${fileDownload.fileName}';
      File file = File(filePath);
      await file.writeAsBytes(decodedBytes);
      print('File saved at $filePath');
      _showNotification(filePath);
    } catch (e) {
      print(e);
    }
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  _showNotification(String filePath) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'Locate File', // id
          'Locate File', // title
          //!TODO Create a function to open the file!
        ),
      ]
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Archivo Guardado',
      'Archivo guardado en $filePath',
      platformChannelSpecifics,
    );
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
      print(err);
      print(stack);
    }
    return directory?.path;
  }
}

class FileDownloadState {
  final bool isDownloading;
  final double progress;
  final String? error;
  final bool downloadSuccess;

  FileDownloadState({
    required this.isDownloading,
    required this.progress,
    this.error,
    this.downloadSuccess = false,
  });

  factory FileDownloadState.initial() {
    return FileDownloadState(
      isDownloading: false,
      progress: 0,
    );
  }

  FileDownloadState copyWith({
    bool? isDownloading,
    double? progress,
    String? error,
    bool? downloadSuccess,
  }) {
    return FileDownloadState(
      isDownloading: isDownloading ?? this.isDownloading,
      progress: progress ?? this.progress,
      error: error ?? this.error,
      downloadSuccess: downloadSuccess ?? this.downloadSuccess,
    );
  }
}
