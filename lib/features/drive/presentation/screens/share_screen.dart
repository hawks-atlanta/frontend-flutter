import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_mobile/features/drive/presentation/providers/files_get_provider.dart';
import 'package:login_mobile/features/drive/presentation/widgets/files_view.dart';
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
          ref.watch(filesGetProvider).locationHistory.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => ref.read(filesGetProvider.notifier).goBack(true),
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: const UnifiedFilesView(isShareList: true),
   
    );
  }
}
