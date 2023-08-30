import 'package:flutter/material.dart';

class CheckAuthStatusScreen extends StatelessWidget {
  const CheckAuthStatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/capy.png',
              width: 50,
              height: 50,
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(strokeWidth: 5),
          ],
        ),
      ),
    );
  }
}
