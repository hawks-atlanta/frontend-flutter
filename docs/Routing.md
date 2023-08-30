# Uso de GoRoute & Riverpod en Flutter con go_router

`GoRoute` es una herramienta de manejo de rutas en Flutter que simplifica la navegación y la gestión de estados en una aplicación. Utiliza el paquete `go_router` junto con `flutter_riverpod` para lograr esto.

## Definición de Rutas

Las rutas se definen utilizando la clase `GoRoute`. Cada ruta tiene un `path` y un `builder` que define qué widget se debe mostrar cuando se accede a esa ruta. Por ejemplo:

- Ruta de verificación de estado de autenticación:
  - `path: '/check-auth-status'`
  - `builder: (context, state) => CheckAuthStatusScreen()`

- Rutas de autenticación:
  - `path: '/login'`
  - `builder: (context, state) => LoginScreen()`
  - `path: '/register'`
  - `builder: (context, state) => RegisterScreen()`

- Ruta de Files:
  - `path: '/'`
  - `builder: (context, state) => CapyDriveScreen()`

## Gestión de Redirecciones

Se utiliza la función `redirect` para controlar la navegación y las redirecciones en función del estado de autenticación y la ubicación actual. Por ejemplo:

- Si el estado de autenticación está en proceso (`AuthStatus.checking`), la ruta `/check-auth-status` se mantiene.
- Si el usuario no está autenticado, se redirige a las rutas de inicio de sesión o registro.
- Si el usuario está autenticado, se redirige a la pantalla principal de files.

## Integración con [Riverpod ](https://docs-v2.riverpod.dev/docs/why_riverpod)

La instancia de `GoRouter` se crea dentro de un proveedor de `flutter_riverpod`. Esto permite acceder a estados y valores a través del proveedor. La notificación de cambios en el estado se realiza mediante `refreshListenable`.

Riverpod ya se encuentra instanciado en el `main.dart`:

``````dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_mobile/config/config.dart';

void main() async {
  await Enviroment.initEnviroment();
  runApp(
      //Widget que va a mantener una ref a todos los providers que estamos usando
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

``````