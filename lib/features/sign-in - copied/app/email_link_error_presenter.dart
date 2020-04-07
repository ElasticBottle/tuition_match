import 'dart:async';

import 'package:cotor/common_widgets/platform_alert_dialog.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/features/sign-in/services/firebase_email_link_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Listens to [errorStream] and shows an alert dialog each time an error is received.
/// This widget should live for the entire lifecycle of the app, so that all errors are reported.
class EmailLinkErrorPresenter extends StatefulWidget {
  const EmailLinkErrorPresenter({Key key, this.context, this.child})
      : super(key: key);
  final Widget child;
  final BuildContext context;

  @override
  _EmailLinkErrorPresenterState createState() =>
      _EmailLinkErrorPresenterState();
}

class _EmailLinkErrorPresenterState extends State<EmailLinkErrorPresenter> {
  StreamSubscription<EmailLinkError> _onEmailLinkErrorSubscription;

  @override
  void initState() {
    super.initState();
    final FirebaseEmailLinkHandler linkHandler =
        Provider.of<FirebaseEmailLinkHandler>(widget.context, listen: false);
    _onEmailLinkErrorSubscription = linkHandler.errorStream.listen((error) {
      PlatformAlertDialog(
        title: Strings.activationLinkError,
        content: error.message,
        defaultActionText: Strings.ok,
      ).show(context);
    });
  }

  @override
  void dispose() {
    _onEmailLinkErrorSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
