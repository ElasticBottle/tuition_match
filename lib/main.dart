import 'package:firebase_auth_demo_flutter/feature/sign-in/app/email_link_error_presenter.dart';
import 'package:firebase_auth_demo_flutter/feature/sign-in/services/auth_service.dart';
import 'package:firebase_auth_demo_flutter/feature/sign-in/services/auth_service_adapter.dart';
import 'package:firebase_auth_demo_flutter/feature/sign-in/services/email_secure_store.dart';
import 'package:firebase_auth_demo_flutter/feature/sign-in/services/firebase_email_link_handler.dart';
import 'package:firebase_auth_demo_flutter/initial_page_decider.dart';
import 'package:firebase_auth_demo_flutter/user_data_injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // Fix for: Unhandled Exception: ServicesBinding.defaultBinaryMessenger was accessed before the binding was initialized.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // [initialAuthServiceType] is made configurable for testing
  const MyApp({
    this.initialAuthServiceType = AuthServiceType.firebase,
  });
  final AuthServiceType initialAuthServiceType;

  @override
  Widget build(BuildContext context) {
    // MultiProvider for top-level services that can be created right away
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthServiceAdapter(
            initialAuthServiceType: initialAuthServiceType,
          ),
          dispose: (_, AuthService authService) => authService.dispose(),
        ),
        Provider<EmailSecureStore>(
          create: (_) => EmailSecureStore(
            flutterSecureStorage: FlutterSecureStorage(),
          ),
        ),
        ProxyProvider2<AuthService, EmailSecureStore, FirebaseEmailLinkHandler>(
          update: (_, AuthService authService, EmailSecureStore storage, __) =>
              FirebaseEmailLinkHandler.createAndConfigure(
            auth: authService,
            userCredentialsStorage: storage,
          ),
          dispose: (_, linkHandler) => linkHandler.dispose(),
        ),
      ],
      child: UserDataInjector(
          builder: (BuildContext context, AsyncSnapshot<User> userSnapshot) {
        return MaterialApp(
          theme: ThemeData(primarySwatch: Colors.indigo),
          home: EmailLinkErrorPresenter.create(
            context,
            child: InitialPageDecider(userSnapshot: userSnapshot),
          ),
        );
      }),
    );
  }
}
