import 'package:auto_route/auto_route.dart';
import 'package:cotor/features/sign-in/app/email_link_error_presenter.dart';
import 'package:cotor/features/sign-in/services/auth_service.dart';
import 'package:cotor/features/sign-in/services/auth_service_adapter.dart';
import 'package:cotor/features/sign-in/services/email_secure_store.dart';
import 'package:cotor/features/sign-in/services/firebase_email_link_handler.dart';
import 'package:cotor/initial_page_decider.dart';
import 'package:cotor/user_data_injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:cotor/injection_container.dart' as di;
import 'package:cotor/routing/router.gr.dart';

Future<void> main() async {
  // Fix for: Unhandled Exception: ServicesBinding.defaultBinaryMessenger was accessed before the binding was initialized.
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
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
          debugShowCheckedModeBanner: false,
          home: EmailLinkErrorPresenter(
            context: context,
            child: InitialPageDecider(userSnapshot: userSnapshot),
          ),
          onGenerateRoute: Router().onGenerateRoute,
        );
      }),
    );

    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: OnboardPage(),
    // );
  }
}
