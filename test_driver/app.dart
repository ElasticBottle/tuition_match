//import 'package:cotor/main.dart' as app;
import 'package:cotor/features/sign-in/services/auth_service_adapter.dart';
import 'package:cotor/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

void main() {
  // This line enables the extension.
  enableFlutterDriverExtension();

  // Call the `main()` function of the app, or call `runApp` with
  // any widget you are interested in testing.
  runApp(MyApp(
    initialAuthServiceType: AuthServiceType.mock,
  ));
}
