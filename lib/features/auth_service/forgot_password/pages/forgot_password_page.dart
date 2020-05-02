import 'package:cotor/features/auth_service/forgot_password/pages/forgot_password_form.dart';
import 'package:cotor/features/auth_service/registration/bloc/registration_bloc.dart';
import 'package:cotor/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Center(
        child: BlocProvider<RegistrationBloc>(
          create: (context) => sl<RegistrationBloc>(),
          child: ForgotPasswordForm(),
        ),
      ),
    );
  }
}
