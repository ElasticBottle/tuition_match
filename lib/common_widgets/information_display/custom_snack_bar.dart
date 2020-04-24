import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  const CustomSnackBar({
    Key key,
    @required this.message,
    @required this.isError,
    this.delay = 2,
    this.success = Colors.green,
    this.error = Colors.red,
    this.actionText = 'Dismiss',
  }) : super(key: key, content: const Text(''));

  final String message;
  final int delay;
  final bool isError;
  final Color success;
  final Color error;
  final String actionText;

  SnackBar show(BuildContext context) {
    return build(context);
  }

  Widget build(BuildContext context) {
    return SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.error),
          SizedBox(width: 20.0),
          Expanded(
              child: Text(
            message,
            style: TextStyle(color: Colors.grey[300]),
          ))
        ],
      ),
      duration: Duration(seconds: delay),
      action: SnackBarAction(
        label: actionText,
        onPressed: () {
          Scaffold.of(context).hideCurrentSnackBar();
        },
      ),
      backgroundColor: isError ? error : success,
    );
  }
}
