import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:login_mobile/features/auth/presentation/providers/share_provider.dart';
import 'package:login_mobile/features/drive/presentation/providers/share_form_provider.dart';
import 'package:login_mobile/features/shared/shared.dart';

class ShareFileListScreen extends ConsumerWidget {
  final String fileUUID;

  const ShareFileListScreen({Key? key, required this.fileUUID})
      : super(key: key);

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shareForm = ref.watch(shareFormProvider);
    final shareUsersState = ref.watch(shareProvider);

    ref.listen(shareProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    return Scaffold(
        appBar: AppBar(
          title: const Text('Share 𐃶'),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                /*
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.group_add_outlined),
              labelText: 'Add people',
              
            )),*/
                const SizedBox(height: 5),
                CustomTextFormField(
                  label: 'Username',
                  keyboardType: TextInputType.name,
                  onChanged: (value) => ref
                      .read(shareFormProvider.notifier)
                      .onUsernameChange(value, fileUUID),
                  errorMessage: shareForm.isFormPosted
                      ? shareForm.username.errorMessage
                      : null,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: shareForm.isPosting
                        ? null
                        : () {
                            ref
                                .read(shareFormProvider.notifier)
                                .onFormSubmitted();
                          },
                  ),
                ),
                const Divider(),
                Expanded(
                  child: shareUsersState.shareListWithWho.isEmpty
                      ? const Center(
                          child: Text('This folder is empty'),
                        )
                      : MasonryGridView.count(
                          physics: const BouncingScrollPhysics(),
                          crossAxisCount: 1,
                          mainAxisSpacing: 1,
                          crossAxisSpacing: 4,
                          itemCount: shareUsersState.shareListWithWho.length,
                          itemBuilder: (context, index) {
                            final shareData = shareUsersState.shareListWithWho[index];
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(shareData),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () {
                                      //!TODO: Agrega la lógica para borrar o cancelar
                                    },
                                  ),
                                ),
                                const Divider(),
                              ],
                            );
                          },
                        ),
                )
              ],
            )));
  }
}
