import 'package:cotor/features/authentication/presentation/pages/login/bloc/login_bloc.dart';
import 'package:cotor/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LoginBloc>(
        create: (context) => sl<LoginBloc>(),
        child: LoginForm(),
      ),
    );
  }
}
