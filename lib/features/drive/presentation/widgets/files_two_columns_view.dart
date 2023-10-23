import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_mobile/features/drive/domain/entities/file.dart';
import 'package:login_mobile/features/drive/presentation/widgets/file_modal_botton_sheet.dart';

class FilesTwoColumnsView extends ConsumerStatefulWidget {
  final File file;
  final bool isShareList;

  const FilesTwoColumnsView({
    super.key,
    required this.file,
    this.isShareList = false,
  });

  @override
  FileOrFolderWidgetState createState() => FileOrFolderWidgetState();
}

class FileOrFolderWidgetState extends ConsumerState<FilesTwoColumnsView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Card(
        elevation: 0.1,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      Icon(
                        widget.file.isFile
                            ? Icons.insert_drive_file
                            : Icons.folder,
                        size: 60,
                        color: const Color.fromARGB(255, 70, 70, 70),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          widget.file.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: widget.isShareList
                  ? const SizedBox.shrink()
                  : IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            //print(widget.file.uuid);
                            return FileModalBottomSheet(file: widget.file);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
