import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_mobile/features/shared/shared.dart';

class ShareScreen extends ConsumerWidget {
  const ShareScreen({super.key});

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
