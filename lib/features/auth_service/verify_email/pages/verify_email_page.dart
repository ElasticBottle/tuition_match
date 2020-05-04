import 'package:cotor/common_widgets/buttons/custom_raised_button.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/features/auth_service/auth_service_bloc/auth_service_bloc.dart';
import 'package:cotor/features/auth_service/verify_email/bloc/verify_email_bloc.dart';
import 'package:cotor/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify your email'),
      ),
      body: BlocProvider(
        create: (context) => sl<VerifyEmailBloc>(),
        child: RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<AuthServiceBloc>(context).add(LoggedIn());
            },
            child: SingleChildScrollView(
              child: VerifyEmailPageBody(),
              physics: const AlwaysScrollableScrollPhysics(),
            )),
      ),
    );
  }
}

class VerifyEmailPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocConsumer<VerifyEmailBloc, VerifyEmailState>(
        listener: (context, state) {
          if (state.error != null) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text(state.error), Icon(Icons.error)],
                  ),
                  action: SnackBarAction(
                    label: Strings.dismiss,
                    onPressed: () {
                      Scaffold.of(context).hideCurrentSnackBar();
                    },
                  ),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        builder: (BuildContext context, VerifyEmailState state) {
          return Column(
            children: <Widget>[
              Icon(
                Icons.perm_identity,
                size: 50,
              ),
              Text(
                '''Please check the email that you used to register for a confirmation email!
                  Once verified, give it five seconds for everything to sync and pull to refresh!''',
              ),
              CustomRaisedButton(
                child: Text(
                  'Resend Email Verification',
                ),
                loading: state.isSending,
                onPressed: () => BlocProvider.of<VerifyEmailBloc>(context)
                    .add(SendVerificationEmail()),
              ),
              FlatButton(
                onPressed: () =>
                    BlocProvider.of<VerifyEmailBloc>(context).add(LogOut()),
                child: state.isSigningOut
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Text('Log out'),
              ),
            ],
          );
        },
      ),
    );
  }
}
