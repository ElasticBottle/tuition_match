import 'package:cotor/core/bloc/bloc_delegate.dart';
import 'package:cotor/core/theme/app_theme.dart';
import 'package:cotor/features/authentication/authentication.dart';
import 'package:cotor/initial_page_decider.dart';
import 'package:cotor/user_data_injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cotor/injection_container.dart' as di;
import 'package:cotor/routing/router.gr.dart';

import 'home_page.dart';
import 'injection_container.dart';

Future<void> main() async {
  // Fix for: Unhandled Exception: ServicesBinding.defaultBinaryMessenger was accessed before the binding was initialized.
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  await di.init();
  runApp(
    MultiBlocProvider(
      providers: [
        // BlocProvider<VerifyEmailBloc>(
        //   create: (context) => sl<VerifyEmailBloc>(),
        // ),
        BlocProvider<AuthenticationBloc>(
          create: (context) => sl<AuthenticationBloc>()..add(AppStarted()),
        )
      ],
      child: MyApp(),
    ),
    // MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // [initialAuthServiceType] is made configurable for testing
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return UserDataInjector(
      builder: (context, state) => MaterialApp(
        theme: AppTheme(isDark: false).themeData,
        debugShowCheckedModeBanner: false,
        home: InitialPageDecider(),
        onGenerateRoute: Router().onGenerateRoute,
      ),
    );

    // return MaterialApp(
    //   theme: AppTheme(isDark: false).themeData,
    //   debugShowCheckedModeBanner: false,
    //   home: HomePage(),
    // );
  }
}
