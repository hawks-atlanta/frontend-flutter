import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_mobile/config/config.dart';
import 'package:login_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:login_mobile/features/shared/shared.dart';
import 'package:login_mobile/features/shared/widgets/bottom_sheet.dart';

class SideMenu extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenu({
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  SideMenuState createState() => SideMenuState();
}

class SideMenuState extends ConsumerState<SideMenu> {
  int navDrawerIndex = 0;

  Future<void> handleBiometricAuthentication(context) async {
    bool authenticated =
        await ref.read(authProvider.notifier).authWithBiometrics();
    if (authenticated) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => const CustomLogin(),
      );
      //final goRouter = ref.read(goRouterProvider);
      //goRouter.go(
      //    '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    final textStyles = Theme.of(context).textTheme;
    final authState = ref.watch(authProvider);

    return NavigationDrawer(
      elevation: 1,
      selectedIndex: navDrawerIndex,
      onDestinationSelected: (value) {
        setState(() {
          navDrawerIndex = value;
        });
        final goRouter = ref.read(goRouterProvider);
        if (value == 0) {
          goRouter.go('/files');
        } else if (value == 1) {
          goRouter.go('/share');
        }
        widget.scaffoldKey.currentState?.closeDrawer();
      },
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, hasNotch ? 0 : 20, 16, 0),
          child: Text('Your CapyFile', style: textStyles.titleMedium),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 16, 10),
          child: Text(authState.user?.username ?? 'Fallback Value',
              style: textStyles.titleSmall),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.folder),
          label: Text('Files'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.folder_shared),
          label: Text('Share'),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Divider(),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 10, 16, 10),
          child: Text('Other options'),
        ),
        authState.hasBiometric == true
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomFilledButton(
                  onPressed: () {
                    ref.read(authProvider.notifier).disableBiometric(ref);
                  },
                  text: 'Disable Biometrics',
                  icon: Icons.cancel,
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomFilledButton(
                  onPressed: () {
                    handleBiometricAuthentication(context);
                  },
                  text: 'Biometrics',
                  icon: Icons.fingerprint,
                ),
              ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomFilledButton(
              onPressed: () {
                ref.read(authProvider.notifier).logout();
              },
              text: 'Change Password',
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomFilledButton(
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
            text: 'Log out',
          ),
        ),
      ],
    );
  }
}
