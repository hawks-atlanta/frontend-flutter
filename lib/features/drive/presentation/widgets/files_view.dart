import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:login_mobile/features/drive/presentation/providers/files_get_provider.dart';
import 'package:login_mobile/features/drive/presentation/widgets/file_folder_widget.dart';

class FilesView extends ConsumerStatefulWidget {
  final String? locationId;

  const FilesView({super.key, required this.locationId});

  @override
  FilesViewState createState() => FilesViewState();
}

class FilesViewState extends ConsumerState<FilesView> {
  int stateCrossAxis = 1;

  final ScrollController _scrollController =
      ScrollController(); //infinite scroll

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref
        .read(filesGetProvider.notifier)
        .getFiles(location: widget.locationId));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void toggleCrossAxisCount() {
    setState(() {
      stateCrossAxis = stateCrossAxis == 1 ? 2 : 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filesState = ref.watch(filesGetProvider);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: toggleCrossAxisCount,
                  child: Icon(
                    stateCrossAxis == 1 ? Icons.view_stream : Icons.view_module,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 1),
          Expanded(
            child: filesState.files.isEmpty
                ? const Center(
                    child: Center(child: Text('Folder Empty')),
                  )
                : MasonryGridView.count(
                    physics: const BouncingScrollPhysics(),
                    crossAxisCount: stateCrossAxis,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 4,
                    itemCount: filesState.files.length,
                    itemBuilder: (context, index) {
                      final fileData = filesState.files[index];
                      return GestureDetector(
                          onTap: fileData.isFile
                              ? null
                              : () => context.push('/folder/${fileData.uuid}'),
                          child: FileOrFolderWidget(file: fileData));
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
