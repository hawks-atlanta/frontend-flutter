import 'package:flutter/material.dart';

class DialogWidget extends StatelessWidget {
  final String? title;
  final String? hintText;
  final String? buttonTitle;
  final Function(String)? onButtonPressed;
  final TextEditingController _controller = TextEditingController();

  DialogWidget({
    Key key = const Key('DialogWidget'),
    this.title,
    this.hintText,
    this.buttonTitle,
    this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final textStyles = Theme.of(context).textTheme;

    return AlertDialog(
      title: Text(title ?? ''),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(hintText: hintText ?? ''),
        style: const TextStyle(fontSize: 16),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text(buttonTitle ?? ''),
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              onButtonPressed?.call(_controller.text);
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
