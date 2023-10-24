import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_mobile/features/drive/presentation/providers/account_password_provider.dart';
import 'package:login_mobile/features/drive/presentation/providers/auth_account_provider.dart';
import 'package:login_mobile/features/shared/shared.dart';

class AccountPasswordScreen extends StatelessWidget {
  const AccountPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        drawer: SideMenu(scaffoldKey: scaffoldKey),
        appBar: AppBar(
          title: const Text('Change Password 𐃶'),
        ),
        body: SizedBox(
          height:
              size.height - 250, //- 260, // 80 los dos sizebox y 100 el ícono
          width: double.infinity, child: const _AccountPasswordForm(),
        ));
  }
}

class _AccountPasswordForm extends ConsumerWidget {
  const _AccountPasswordForm();

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;
    final accountPasswordForm = ref.watch(accountFormPassProvider);
    final accountPassState = ref.watch(accountPassProvider);

    ref.listen(accountPassProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        const SizedBox(height: 30),
        AutoSizeText(
          accountPassState.changeSuccess ? 'Password changed successfully' : '',
          style: textStyles.bodyMedium,
          maxLines: 1,
        ),
        const SizedBox(height: 30),
        CustomTextFormField(
          label: 'Old Password',
          obscureText: true,
          onChanged:
              ref.read(accountFormPassProvider.notifier).onOldPasswordChange,
          errorMessage: accountPasswordForm.isFormPosted
              ? accountPasswordForm.oldpassword.errorMessage
              : null,
        ),
        const SizedBox(height: 30),
        CustomTextFormField(
          label: 'New Password',
          obscureText: true,
          onChanged:
              ref.read(accountFormPassProvider.notifier).onNewPasswordChange,
          errorMessage: accountPasswordForm.isFormPosted
              ? accountPasswordForm.newpassword.errorMessage
              : null,
        ),
        const SizedBox(height: 30),
        CustomTextFormField(
          label: 'Repeat new password',
          obscureText: true,
          onChanged: ref
              .read(accountFormPassProvider.notifier)
              .onRepeatNewPasswordChange,
          errorMessage: accountPasswordForm.isFormPosted
              ? accountPasswordForm.repeatNewPassword.errorMessage
              : null,
        ),
        const SizedBox(height: 30),
        SizedBox(
            width: double.infinity,
            height: 45,
            child: CustomFilledButton(
                text: 'Change Password',
                buttonColor: Colors.black,
                onPressed: accountPasswordForm.isPosting
                    ? null
                    : ref
                        .read(accountFormPassProvider.notifier)
                        .onFormSubmitted)),
      ]),
    );
  }
}
