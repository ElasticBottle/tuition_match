import 'package:cotor/features/auth_service/bloc/registraiton_bloc/registration_bloc.dart';
import 'package:cotor/features/auth_service/pages/registration_form.dart';
import 'package:cotor/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Center(
        child: BlocProvider<RegistrationBloc>(
          create: (context) => sl<RegistrationBloc>(),
          child: RegistrationForm(),
        ),
      ),
    );
  }
}
