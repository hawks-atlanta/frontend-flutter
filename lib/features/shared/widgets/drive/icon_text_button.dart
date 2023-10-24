import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final String name;
  final Color color;
  final Icon icon;
  final VoidCallback onPress;

  const IconTextButton({
    Key? key,
    required this.name,
    required this.color,
    required this.icon,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              width: 80,
              height: 50,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              child: icon,
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
