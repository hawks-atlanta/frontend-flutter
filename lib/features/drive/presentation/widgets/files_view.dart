import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:login_mobile/features/drive/presentation/providers/files_get_provider.dart';
import 'package:login_mobile/features/drive/presentation/widgets/file_folder_widget.dart';

class FilesView extends ConsumerStatefulWidget {
  const FilesView({Key? key}) : super(key: key);

  @override
  FilesViewState createState() => FilesViewState();
}

class FilesViewState extends ConsumerState {
  int stateCrossAxis = 1;

  final ScrollController _scrollController =
      ScrollController(); //infinite scroll

  @override
  void initState() {
    super.initState();
    //TODO: infinite scroll pending necesario?
    ref.read(filesGetProvider.notifier).getFiles();
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
                  onPressed:
                      toggleCrossAxisCount,
                  child: Icon(
                    stateCrossAxis == 1 ? Icons.view_stream : Icons.view_module,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 1),
          Expanded(
              child: MasonryGridView.count(
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: stateCrossAxis,
                  crossAxisSpacing: 20,
                  itemCount: filesState.files.length,
                  itemBuilder: (context, index) {
                    final fileData = filesState.files[index];
                    return FileOrFolderWidget(file: fileData);
                  })),
        ],
      ),
    );
  }
}
