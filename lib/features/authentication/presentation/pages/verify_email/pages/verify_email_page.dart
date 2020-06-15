import 'dart:math' as math;
import 'package:cotor/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:cotor/features/authentication/presentation/pages/verify_email/bloc/verify_email_bloc.dart';
import 'package:cotor/features/authentication/presentation/pages/verify_email/pages/verify_email_body.dart';
import 'package:cotor/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          onPressed: () =>
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut()),
        ),
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          },
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: BlocProvider<VerifyEmailBloc>(
                    create: (_) => sl<VerifyEmailBloc>(),
                    child: VerifyEmailPageBody()),
                physics: const AlwaysScrollableScrollPhysics(),
              ),
            ),
          )),
    );
  }
}
