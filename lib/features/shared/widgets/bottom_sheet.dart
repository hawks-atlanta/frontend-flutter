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
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginForm =
        ref.watch(loginFormProvider); //acceso al state no al notifier

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    final textStyles = Theme.of(context).textTheme;

    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Text('Confirm Account', style: textStyles.titleLarge),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    label: 'Insert you password',
                    obscureText: true,
                    onChanged:
                        ref.read(loginFormProvider.notifier).onPasswordChanged,
                    errorMessage: loginForm.isFormPosted
                        ? loginForm.password.errorMessage
                        : null,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: CustomFilledButton(
                          text: 'Sign in',
                          buttonColor: Colors.black,
                          onPressed: loginForm.isPosting
                              ? null
                              : ref
                                  .read(loginFormProvider.notifier)
                                  .onFormSubmitted
                          )),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ));
  }
}
