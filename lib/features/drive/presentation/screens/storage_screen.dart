import 'package:flutter/material.dart';
import 'package:login_mobile/features/shared/shared.dart';

class ShareScreen extends StatelessWidget {
  const ShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Shared 𐃶'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: const _ListShareView(),
   
    );
  }
}

class _ListShareView extends StatelessWidget {
  const _ListShareView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Share View'));
  }
}
