import 'package:cotor/core/bloc/bloc_delegate.dart';
import 'package:cotor/features/auth_service/bloc/auth_service_bloc/auth_service_bloc.dart';
import 'package:cotor/initial_page_decider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cotor/injection_container.dart' as di;
import 'package:cotor/routing/router.gr.dart';

import 'injection_container.dart';

Future<void> main() async {
  // Fix for: Unhandled Exception: ServicesBinding.defaultBinaryMessenger was accessed before the binding was initialized.
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  await di.init();
  runApp(
    BlocProvider(
      create: (context) => sl<AuthServiceBloc>(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // [initialAuthServiceType] is made configurable for testing
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      debugShowCheckedModeBanner: false,
      home: InitialPageDecider(),
      onGenerateRoute: Router().onGenerateRoute,
    );

    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: OnboardPage(),
    // );
  }
}
