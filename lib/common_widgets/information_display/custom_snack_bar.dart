import 'package:flutter/material.dart';

/// Used to display changes in app stat to user
///
/// Often use to display what went wrong
class CustomSnackBar extends SnackBar {
  const CustomSnackBar({
    Key key,
    @required this.toDisplay,
    this.prefix,
    this.delay = 2,
    this.color,
    this.actionText = 'Dismiss',
    this.actionTextColor,
  }) : super(key: key, content: const Text(''));

  /// The widget use to display in the center of the snackbar
  ///
  /// Often a [Text] widget
  final Widget toDisplay;

  /// TIme before the snackbar dismisses itself
  ///
  /// Defaults to 2 seconds
  final int delay;

  /// Widget before [toDisplay] if any
  ///
  /// Defaults to [Icons.error] with [ColorScheme.onError]
  final Widget prefix;

  /// Background color of the snackbar
  ///
  /// Defaults to [ColorScheme.error]
  final Color color;

  /// Action text of the snackBar
  final String actionText;

  /// Color of [actionText]
  ///
  /// Defaults to [ColorScheme.onError]
  final Color actionTextColor;

  SnackBar show(BuildContext context) {
    return build(context);
  }

  Widget build(BuildContext context) {
    return SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          prefix ??
              Icon(
                Icons.error,
                color: Theme.of(context).colorScheme.onError,
              ),
          SizedBox(width: 20.0),
          Expanded(
            child: toDisplay,
          )
        ],
      ),
      duration: Duration(seconds: delay),
      action: SnackBarAction(
        textColor: actionTextColor ?? Theme.of(context).colorScheme.onError,
        label: actionText,
        onPressed: () {
          Scaffold.of(context).hideCurrentSnackBar();
        },
      ),
      backgroundColor: color ?? Theme.of(context).colorScheme.error,
    );
  }
}
