import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_mobile/features/drive/domain/entities/file.dart';
import 'package:login_mobile/features/drive/presentation/widgets/file_modal_botton_sheet.dart';
import 'package:login_mobile/features/shared/infrastructure/inputs/format_bytes.dart';

class FileOrFolderWidget extends ConsumerStatefulWidget {
  final File file;

  const FileOrFolderWidget({
    super.key,
    required this.file,
  });

  @override
  FileOrFolderWidgetState createState() => FileOrFolderWidgetState();
}

class FileOrFolderWidgetState extends ConsumerState<FileOrFolderWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        leading:
            Icon(widget.file.isFile ? Icons.insert_drive_file : Icons.folder),
        title: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Alinea el texto a la izquierda
          children: [
            Text(widget.file.name),
            const SizedBox(height: 4.0),
            widget.file.isFile
                ? Text(
                    'Size: ${formatBytes(widget.file.size, 2)}',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[600],
                    ),
                  )
                : Container(),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                print(widget.file.uuid);
                return FileModalBottomSheet(file: widget.file);
              },
            );
          },
        ),
      ),
      const Divider(),
    ]);
  }
}
