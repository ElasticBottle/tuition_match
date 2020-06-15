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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        title: Text(
          'Forgot Password',
          style: Theme.of(context).textTheme.headline6,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: BlocProvider<ForgotPasswordBloc>(
          create: (context) => sl<ForgotPasswordBloc>(),
          child: ForgotPasswordForm(),
        ),
      ),
    );
  }
}
