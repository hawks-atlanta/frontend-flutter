import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:login_mobile/features/auth/auth.dart';
import 'package:login_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:login_mobile/features/auth/presentation/screens/account_password.dart';
import 'package:login_mobile/features/drive/files_drive.dart';
import 'app_router_notifier.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/check-auth-status',
    refreshListenable: goRouterNotifier,
    routes: [
      ///* Primera pantalla Default
      GoRoute(
        path: '/check-auth-status',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* CapyDriveScreen Routes
      GoRoute(
        path: '/files',
        builder: (context, state) => const CapyDriveScreen(),
      ),
      GoRoute(
        path: '/share',
        builder: (context, state) => const ShareScreen(),
      ),
      GoRoute(
        path: '/account/password',
        builder: (context, state) => const AccountPasswordScreen(),
      )
    ],
    redirect: (context, state) {
      final isGoingTo = state.matchedLocation;

      final authStatus = goRouterNotifier.authStatus;

      if (isGoingTo == '/check-auth-status' &&
          authStatus == AuthStatus.checking) {
        return null;
      }

      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/register') return null;

        return '/login';
      }

      if ((authStatus == AuthStatus.authenticated)) {
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/check-auth-status') {
          return '/files';
        }
      }

      return null;
    },
  );
});
