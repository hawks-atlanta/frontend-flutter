import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:login_mobile/features/drive/presentation/providers/files_get_provider.dart';
import 'package:login_mobile/features/drive/presentation/widgets/file_folder_widget.dart';
import 'package:login_mobile/features/drive/presentation/widgets/file_list_view.dart';

class FilesView extends ConsumerStatefulWidget {
  const FilesView({super.key});

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
    Future.microtask(() => ref.read(filesGetProvider.notifier).getFiles());
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
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<CircleBorder>(
                        const CircleBorder()), // Sin borde
                    elevation: MaterialStateProperty.all(0), // Sin elevación
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.grey.withOpacity(0.3);
                        }
                        return Colors.transparent;
                      },
                    ),
                  ),
                  child: Icon(
                    stateCrossAxis == 1 ? Icons.view_module : Icons.view_stream,
                    color: const Color.fromARGB(255, 53, 53, 53),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 1),
          Flexible(
            child: filesState.files.isEmpty
                ? const Center(
                    child: Center(child: Text('This folder is empty')),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: stateCrossAxis == 1
                        ? MasonryGridView.count(
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
                                    : () => ref
                                        .read(filesGetProvider.notifier)
                                        .goLocation(fileData.uuid),
                                child: FileOrFolderWidget(file: fileData),
                              );
                            },
                          )
                        : MasonryGridView.count(
                            physics: const BouncingScrollPhysics(),
                            crossAxisCount: stateCrossAxis,
                            mainAxisSpacing: 1,
                            crossAxisSpacing: 1,
                            itemCount: filesState.files.length,
                            itemBuilder: (context, index) {
                              final fileData = filesState.files[index];
                              return GestureDetector(
                                onTap: fileData.isFile
                                    ? null
                                    : () => ref
                                        .read(filesGetProvider.notifier)
                                        .goLocation(fileData.uuid),
                                child: FilesTwoColumnsView(file: fileData),
                              );
                            },
                          )
                  ),
          ),
        ],
      ),
    );
  }
}
