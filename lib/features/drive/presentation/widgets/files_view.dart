import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:login_mobile/features/drive/presentation/providers/files_get_provider.dart';
import 'package:login_mobile/features/drive/presentation/widgets/file_folder_widget.dart';
import 'package:login_mobile/features/drive/presentation/widgets/file_list_view.dart';

class UnifiedFilesView extends ConsumerStatefulWidget {
  final bool isShareList;

  const UnifiedFilesView({Key? key, this.isShareList = false})
      : super(key: key);

  @override
  UnifiedFilesViewState createState() => UnifiedFilesViewState();
}

class UnifiedFilesViewState extends ConsumerState<UnifiedFilesView> {
  int stateCrossAxis = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    if (widget.isShareList) {
      Future.microtask(
          () => ref.read(filesGetProvider.notifier).getFilesShareList());
    } else {
      Future.microtask(() => ref.read(filesGetProvider.notifier).getFiles());
    }
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
    final FilesGetState filesStateList = ref.watch(filesGetProvider);
    
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
                        const CircleBorder()),
                    elevation: MaterialStateProperty.all(0),
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
            child: filesStateList.files.isEmpty
                ? const Center(child: Text('This folder is empty'))
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: MasonryGridView.count(
                      physics: const BouncingScrollPhysics(),
                      crossAxisCount: stateCrossAxis,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 4,
                      itemCount: filesStateList.files.length,
                      itemBuilder: (context, index) {
                        final fileData = filesStateList.files[index];
                        return GestureDetector(
                          onTap: fileData.isFile
                              ? null
                              : () => ref
                                  .read(filesGetProvider.notifier)
                                  .goLocation(fileData.uuid),
                          child: stateCrossAxis == 1
                              ? FileOrFolderWidget(file: fileData)
                              : FilesTwoColumnsView(file: fileData),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
