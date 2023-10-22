// file_utils.dart

import 'dart:math';

String formatBytes(int bytes, int decimals) {
  if (bytes <= 0) return "0 KB";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB"];
  int i = (log(bytes) / log(1024)).floor();
  double size = bytes / pow(1024, i);
  return "${size.toStringAsFixed(decimals)} ${suffixes[i]}";
}
