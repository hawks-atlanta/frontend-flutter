class File {
  final String uuid;
  final String name;
  final String? extension;
  final bool isFile;
  final String size;

  File({
    required this.uuid,
    required this.name,
    this.extension,
    required this.isFile,
    required this.size,
  });

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
        uuid: json['uuid'],
        name: json['name'],
        extension: json['extension'].toString(),
        isFile: json['isFile'],
        size: json['size'].toString() // Convertimos el número a double
        );
  }
}
