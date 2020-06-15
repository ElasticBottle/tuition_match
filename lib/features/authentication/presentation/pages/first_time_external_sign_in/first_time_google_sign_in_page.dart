import 'package:cotor/features/authentication/authentication.dart';
import 'package:cotor/features/authentication/presentation/pages/first_time_external_sign_in/first_time_google_sign_in_form.dart';
import 'package:cotor/features/authentication/presentation/pages/registration/bloc/registration_bloc.dart';
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
      appBar: AppBar(
        // title: Text('First Time Google Sign In'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () =>
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut()),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: BlocProvider<RegistrationBloc>(
        create: (context) => sl<RegistrationBloc>(),
        child: FirstTimeGoogleSignInForm(),
      ),
    );
  }
}
