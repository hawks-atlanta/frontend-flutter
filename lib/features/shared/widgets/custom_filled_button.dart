import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final Color? buttonColor;
  final IconData? icon;

  const CustomFilledButton(
      {super.key,
      this.onPressed,
      required this.text,
      this.buttonColor,
      this.icon});

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(10);

    return FilledButton(
        style: FilledButton.styleFrom(
            backgroundColor: buttonColor,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              bottomLeft: radius,
              bottomRight: radius,
              topLeft: radius,
            ))),
        onPressed: onPressed,
        child: Row(
            mainAxisAlignment: icon != null
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment
                    .center, // Alinea el texto al centro si no hay un icono
            children: <Widget>[
              Text(text),
              if (icon != null)
                Icon(icon), // Usa el icono solo si se proporciona
            ]));
  }
}
