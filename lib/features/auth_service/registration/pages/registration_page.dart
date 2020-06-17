import 'package:cotor/features/authentication/presentation/pages/registration/bloc/registration_bloc.dart';
import 'package:cotor/features/authentication/presentation/pages/registration/pages/registration_form.dart';
import 'package:cotor/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
      ),
      body: Center(
        child: BlocProvider<RegistrationBloc>(
          create: (context) => sl<RegistrationBloc>(),
          child: RegistrationForm(),
        ),
      ),
    );
  }
}
