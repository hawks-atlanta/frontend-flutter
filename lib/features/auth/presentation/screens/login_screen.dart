import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:login_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:login_mobile/features/auth/presentation/providers/login_form_provider.dart';
import 'package:login_mobile/features/shared/shared.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

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
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 50,
              child: ClipOval(
                  child: Image.asset(
                'assets/capy.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              )),
            ),
            const SizedBox(height: 10),
            const Text("CapyFile",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontStyle: FontStyle.italic)),
            const SizedBox(height: 50),

            Container(
              height: size.height - 260, // 80 los dos sizebox y 100 el ícono
              width: double.infinity,
              decoration: BoxDecoration(
                color: scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(100)),
              ),
              child: const _LoginForm(),
            )
          ],
        ),
      ))),
    );
  }
}

//ConsumerWidget es propio de RiverPod
class _LoginForm extends ConsumerWidget {
  const _LoginForm();

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  @override
  //WidgetRef ref: todos los provider de RiverPod
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;
    final hasBiometric = ref.watch(authProvider).hasBiometric;

    final loginForm =
        ref.watch(loginFormProvider); //acceso al state no al notifier

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Text('Login', style: textStyles.titleLarge),
          const SizedBox(height: 40),
          CustomTextFormField(
            label: 'Username',
            keyboardType: TextInputType.emailAddress,
            onChanged: ref.read(loginFormProvider.notifier).onUsernameChange,
            errorMessage:
                loginForm.isFormPosted ? loginForm.username.errorMessage : null,
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Password',
            obscureText: true,
            onChanged: ref.read(loginFormProvider.notifier).onPasswordChanged,
            errorMessage:
                loginForm.isFormPosted ? loginForm.password.errorMessage : null,
          ),
          const SizedBox(height: 30),
          SizedBox(
              width: double.infinity,
              height: 60,
              child: CustomFilledButton(
                  text: 'Sign in',
                  buttonColor: Colors.black,
                  onPressed: loginForm.isPosting
                      ? null
                      : ref
                          .read(loginFormProvider.notifier)
                          .onFormSubmitted //si no posteo mando ref a la func
                  )),
          const SizedBox(height: 10),
          if (hasBiometric == true)
            SizedBox(
                width: double.infinity,
                height: 60,
                child: CustomFilledButton(
                    text: 'Sign in with biometric',
                    buttonColor: Colors.black,
                    onPressed: loginForm.isPosting
                        ? null
                        : () {
                            ref
                                .read(authProvider.notifier)
                                .loginWithBiometrics();
                          })),
          const Spacer(flex: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => context.push('/register'),
                child: const Text('Create account',
                    style: TextStyle(color: Color.fromRGBO(32, 159, 168, 1))),
              )
            ],
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
