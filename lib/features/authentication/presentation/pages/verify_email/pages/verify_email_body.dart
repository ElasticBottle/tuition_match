import 'package:cotor/common_widgets/common_widgets.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/features/authentication/authentication.dart';
import 'package:cotor/features/authentication/presentation/pages/verify_email/bloc/verify_email_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                    onPressed: () =>
                        BlocProvider.of<AuthenticationBloc>(context)
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
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
