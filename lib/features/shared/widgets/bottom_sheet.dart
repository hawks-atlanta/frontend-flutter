import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:login_mobile/features/auth/presentation/providers/login_form_provider.dart';
import 'package:login_mobile/features/shared/shared.dart';

class CustomLogin extends ConsumerWidget {
  const CustomLogin({Key? key}) : super(key: key);

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginForm =
        ref.watch(loginFormProvider); //acceso al state no al notifier

    final authState = ref.watch(authProvider);
    if (authState.hasBiometric == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      });
    }

    //va escuchando los cambios del state
    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    final textStyles = Theme.of(context).textTheme;
    String username = authState.user?.username ?? '';
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 500, maxWidth: 400),
            child: SizedBox(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text('Confirm Account', style: textStyles.titleLarge),
                    const SizedBox(height: 5),
                    Text(username, style: textStyles.titleSmall),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      label: 'Insert you password',
                      obscureText: true,
                      onChanged: ref
                          .read(loginFormProvider.notifier)
                          .onPasswordChanged,
                      errorMessage: loginForm.isFormPosted
                          ? loginForm.password.errorMessage
                          : null,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: CustomFilledButton(
                          text: 'Confirm',
                          buttonColor: Colors.black,
                          onPressed: loginForm.isPosting
                              ? null
                              : () async {
                                  final authState = ref.read(authProvider);
                                  if (authState.hasBiometric == true) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (Navigator.canPop(context)) {
                                        Navigator.pop(context);
                                      }
                                    });
                                  }
                                  await ref
                                      .read(loginFormProvider.notifier)
                                      .onFormSubmittedBiometric(username);
                                },
                        )),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          ),
        )));
  }
}
