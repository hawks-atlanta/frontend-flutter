import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:login_mobile/features/auth/presentation/providers/data_test.dart';
import 'package:login_mobile/features/auth/presentation/providers/providers.dart';
import 'package:login_mobile/features/auth/presentation/providers/register_form_provider.dart';
import 'package:login_mobile/features/shared/shared.dart';
import 'package:auto_size_text/auto_size_text.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textStyles = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          body: GeometricalBackground(
              child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            // Icon Banner
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      if (!context.canPop()) return;
                      context.pop();
                    },
                    icon: const Icon(Icons.arrow_back_rounded,
                        size: 40, color: Colors.white)),
                const Spacer(flex: 1), //revisar
                AutoSizeText(
                  'Create Account',
                  style: textStyles.titleLarge?.copyWith(color: Colors.white),
                  maxLines: 1,
                  maxFontSize: 26,
                ),
                const Spacer(flex: 2),
              ],
            ),

            const SizedBox(height: 50),
            SingleChildScrollView(
                child: Container(
              //quite el -260 para que se acople a los dispositivos
              height: size.height -
                  10, //- 260, // 80 los dos sizebox y 100 el ícono
              width: double.infinity,
              decoration: BoxDecoration(
                color: scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(100)),
              ),

              child: const _RegisterForm(),
            )),
          ],
        ),
      ))),
    );
  }
}

class _RegisterForm extends ConsumerWidget {
  const _RegisterForm();

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerForm = ref.watch(registerFormProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 20),
          //const SizedBox( height: 50 ), //revisar
          AutoSizeText(
            'New Account',
            style: textStyles.titleMedium,
            maxLines: 1,
          ),
          //const SizedBox( height: 50 ),
          const SizedBox(height: 20),
          CustomTextFormField(
            label: 'Username',
            keyboardType: TextInputType.emailAddress,
            onChanged: ref.read(registerFormProvider.notifier).onUsernameChange,
            errorMessage: registerForm.isFormPosted
                ? registerForm.username.errorMessage
                : null,
          ),
          const SizedBox(height: 30),

          CustomTextFormField(
            label: 'Password',
            obscureText: true,
            onChanged:
                ref.read(registerFormProvider.notifier).onPasswordChanged,
            errorMessage: registerForm.isFormPosted
                ? registerForm.password.errorMessage
                : null,
          ),

          const SizedBox(height: 30),

          CustomTextFormField(
            label: 'Repeat password',
            obscureText: true,
            onChanged:
                ref.read(registerFormProvider.notifier).onRepeatPasswordChanged,
            errorMessage: registerForm.isFormPosted
                ? registerForm.repeatPassword.errorMessage
                : null,
          ),

          const SizedBox(height: 30),

          SizedBox(
              width: double.infinity,
              height: 60,
              child: CustomFilledButton(
                text: 'Create',
                buttonColor: Colors.black,
                onPressed: registerForm.isPosting ? (null) : ref.read(registerFormProvider.notifier).onFormSubmitted/*() {
                  if (registerForm.isPosting) {
                    null;
                  } else {
                    ref.read(loginFormProvider.notifier).onFormSubmitted;
                    /*
                    //inicio modal
                    showModalBottomSheet<void>(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0)),
                        ),
                        context: context,
                        builder: (context) {
                          return Scaffold(
                            backgroundColor: Color.fromARGB(26, 255, 255, 255),
                            body: SingleChildScrollView(
                              child: Container(
                                constraints: BoxConstraints(
                                  maxHeight: MediaQuery.of(context).size.height,
                                  maxWidth: MediaQuery.of(context).size.width,
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SingleChildScrollView(
                                      child: Container(
                                        height: 700,
                                        margin: const EdgeInsets.only(
                                            left: 9, right: 9),
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.only(
                                              top: 1, bottom: 1),
                                          decoration: const BoxDecoration(
                                            color: Color.fromARGB(
                                                155, 255, 255, 255),
                                          ),
                                          child: SingleChildScrollView(
                                              padding: const EdgeInsets.only(
                                                  bottom: 380,
                                                  top: 12,
                                                  left: 12,
                                                  right: 12),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  AutoSizeText(
                                                      "By registering, you agree to our terms and conditions",
                                                      textAlign:
                                                          TextAlign.justify,
                                                      style: textStyles
                                                          .titleLarge
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.black),
                                                      maxFontSize: 15),
                                                  const SizedBox(
                                                    height: 11,
                                                  ),
                                                  Text(
                                                    termsandcondition,
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 151, 150, 150),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 11,
                                                  ),
                                                  Container(
                                                      width: 180,
                                                      child: CustomFilledButton(
                                                          text: 'Accept',
                                                          buttonColor:
                                                              Colors.black,
                                                          onPressed: () {
                                                            context.go('/');
                                                          })),
                                                ],
                                              )),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });

                    //fin modal*/
                  }
                },*/
              )),

          const Spacer(flex: 2),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    if (context.canPop()) {
                      return context.pop();
                    }

                    context.go('/login');
                  },
                  child: const Text('¿Already have an account?',
                      style: TextStyle(color: Color.fromRGBO(32, 159, 168, 1))))
            ],
          ),

          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
