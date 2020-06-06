import 'dart:math' as math;
import 'package:cotor/common_widgets/buttons/custom_raised_button.dart';
import 'package:cotor/common_widgets/information_display/custom_snack_bar.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/features/auth_service/auth_service_bloc/auth_service_bloc.dart';
import 'package:cotor/features/auth_service/verify_email/bloc/verify_email_bloc.dart';
import 'package:cotor/injection_container.dart';
import 'package:flutter/gestures.dart';
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
              BlocProvider.of<VerifyEmailBloc>(context).add(LogOut()),
        ),
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            BlocProvider.of<AuthServiceBloc>(context).add(LoggedIn());
          },
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: VerifyEmailPageBody(),
                physics: const AlwaysScrollableScrollPhysics(),
              ),
            ),
          )),
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
                CustomSnackBar(
                  toDisplay: Text(
                    state.error,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .apply(color: Theme.of(context).colorScheme.onError),
                  ),
                ).show(context),
              );
          }
          if (state.isSent) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                CustomSnackBar(
                  toDisplay: Text(
                    Strings.verifyEmailSent,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  bgColor: Theme.of(context).colorScheme.primaryVariant,
                  onBgColor: Theme.of(context).colorScheme.primary,
                ).show(context),
              );
          }
        },
        builder: (BuildContext context, VerifyEmailState state) {
          return Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Strings.verifyEmailTitle,
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(height: 10.0),
                Text(Strings.verifyEmailSubtitle),
                SizedBox(height: 50.0),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: CustomRaisedButton(
                    child: Text(
                      Strings.verifiedEmailButtonText,
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .apply(fontSizeFactor: 1.3),
                    ),
                    onPressed: () => BlocProvider.of<AuthServiceBloc>(context)
                        .add(LoggedIn()),
                  ),
                ),
                SizedBox(height: 50.0),
                RichText(
                    text: TextSpan(
                  children: [
                    TextSpan(
                      text: Strings.cannotFindEmailPara,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    TextSpan(
                      style: Theme.of(context).textTheme.button.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      text: ' ' + Strings.resendEmailVerificationButtonText,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          BlocProvider.of<VerifyEmailBloc>(context)
                              .add(SendVerificationEmail());
                        },
                    ),
                  ],
                )),
                // Text(Strings.cannotFindEmailPara),
                // FlatButton(
                //   padding: EdgeInsets.zero,
                //   child: state.isSending
                //       ? Padding(
                //           padding: const EdgeInsets.only(top: 15.0),
                //           child: Center(
                //             child: CircularProgressIndicator(),
                //           ),
                //         )
                //       : Text(
                //           Strings.resendEmailVerificationButtonText,
                //           style: Theme.of(context).textTheme.button,
                //         ),
                //   onPressed: () => BlocProvider.of<VerifyEmailBloc>(context)
                //       .add(SendVerificationEmail()),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
