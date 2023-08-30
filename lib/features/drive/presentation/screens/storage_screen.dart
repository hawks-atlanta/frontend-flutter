import 'package:flutter/material.dart';
import 'package:login_mobile/features/shared/shared.dart';

class StorageScreen extends StatelessWidget {
  const StorageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Storage View CapyFile 𐃶'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: const _StorageView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('New File 𐃶'),
        icon: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

class _StorageView extends StatelessWidget {
  const _StorageView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Storage View'));
  }
}
