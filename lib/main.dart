import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_mobile/config/config.dart';

void main() async {
  await Enviroment.initEnviroment();
  runApp(
      //widget que va a mantener una ref a todos los providers que estamos usando
      const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
        routerConfig: appRouter,
        theme: AppTheme().getTheme(),
        debugShowCheckedModeBanner: false);
  }
}
