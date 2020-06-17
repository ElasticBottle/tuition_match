import 'package:cotor/features/authentication/presentation/pages/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:cotor/features/authentication/presentation/pages/forgot_password/pages/forgot_password_form.dart';
import 'package:cotor/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Center(
        child: BlocProvider<ForgotPasswordBloc>(
          create: (context) => sl<ForgotPasswordBloc>(),
          child: ForgotPasswordForm(),
        ),
      ),
    );
  }
}
