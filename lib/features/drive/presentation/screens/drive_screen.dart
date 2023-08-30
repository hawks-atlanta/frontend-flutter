import 'package:flutter/material.dart';
import 'package:login_mobile/features/shared/shared.dart';

class CapyDriveScreen extends StatelessWidget {
  const CapyDriveScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu( scaffoldKey: scaffoldKey ),
      appBar: AppBar(
        title: const Text('CapyFiles 𐃶'),
        actions: [
          IconButton(
            onPressed: (){}, 
            icon: const Icon( Icons.search_rounded)
          )
        ],
      ),
      body: const _FilesView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('New File 𐃶'),
        icon: const Icon( Icons.add ),
        onPressed: () {},
      ),
    );
  }
}

class _FilesView extends StatelessWidget {
  const _FilesView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('CapyFiles View'));
  }
}