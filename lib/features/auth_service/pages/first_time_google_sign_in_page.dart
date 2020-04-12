import 'package:cotor/features/auth_service/bloc/first_time_google_sign_in/first_time_google_sign_in_bloc.dart';
import 'package:cotor/features/auth_service/pages/first_time_google_sign_in_form.dart';
import 'package:cotor/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FirstTimeGoogleSignInPage extends StatelessWidget {
  const FirstTimeGoogleSignInPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: BlocProvider<FirstTimeGoogleSignInBloc>(
        create: (context) => sl<FirstTimeGoogleSignInBloc>(),
        child: FirstTimeGoogleSignInForm(),
      ),
    );
  }
}
