import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_mobile/features/shared/shared.dart';
import 'package:login_mobile/features/shared/widgets/drive/files_view.dart';
import 'package:login_mobile/features/shared/widgets/drive/new_modal.dart';

class CapyDriveScreen extends ConsumerWidget {
  const CapyDriveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('CapyFiles 𐃶'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: const FilesView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('New 𐃶'),
        icon: const Icon(Icons.add),
        onPressed: () {
          showNewModal(context, ref);
        },
      ),
    );
  }
}
