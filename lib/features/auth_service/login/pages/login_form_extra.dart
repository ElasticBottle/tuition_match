import 'package:cotor/common_widgets/buttons/custom_raised_button.dart';
import 'package:cotor/common_widgets/information_capture/custom_text_field.dart';
import 'package:cotor/common_widgets/information_display/custom_snack_bar.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/features/auth_service/login/bloc/login_bloc.dart';
import 'package:cotor/features/auth_service/widgets/social_sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cotor/routing/router.gr.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  static const Key googleButtonKey = Key('google');

  LoginBloc _loginBloc;

  void _handleSubmitted(String value) {
    _focusScopeNode.nextFocus();
  }

  bool isLoginButtonEnabled(LoginState state) {
    return !state.isEmailError && !state.isPasswordError && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isLoginFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              CustomSnackBar(
                toDisplay: Text(
                  state.failureMessage,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .apply(color: Theme.of(context).colorScheme.onError),
                ),
              ).show(context),
            );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Welcome\nBack!',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  SizedBox(height: 50),
                  FocusScope(
                    node: _focusScopeNode,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomTextField(
                            controller: _emailController,
                            labelText: Strings.emailLabel,
                            hintText: Strings.emailHint,
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.emailAddress,
                            onFieldSubmitted: _handleSubmitted,
                            errorText: state.isEmailError
                                ? Strings.errorEmailEmpty
                                : null,
                          ),
                          CustomTextField(
                            paddding: EdgeInsets.zero,
                            controller: _passwordController,
                            labelText: Strings.passwordLabel,
                            hintText: Strings.passwordHint,
                            textInputAction: TextInputAction.send,
                            onFieldSubmitted: (_) {
                              if (isLoginButtonEnabled(state)) {
                                _onFormSubmitted();
                              }
                            },
                            errorText: state.isPasswordError
                                ? Strings.errorPasswordEmpty
                                : null,
                            isObscureText: true,
                            isShowObscuretextToggle: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(Routes.forgotPasswordPage);
                    },
                    child: Text(Strings.forgotPasswordButtonText),
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: CustomRaisedButton(
                      onPressed: () async {
                        if (isLoginButtonEnabled(state)) {
                          _onFormSubmitted();
                        }
                      },
                      loading: state.isSubmitting,
                      color: Theme.of(context).colorScheme.primary,
                      child: Text(
                        Strings.signInButtonText,
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .apply(fontSizeFactor: 1.3),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: SocialSignInButton(
                      key: googleButtonKey,
                      assetName: 'assets/sign_in/go-logo.png',
                      text: Text(
                        Strings.signInWithGoogleButtonText,
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .apply(fontSizeFactor: 1.3),
                      ),
                      onPressed: state.isSubmitting
                          ? null
                          : () {
                              BlocProvider.of<LoginBloc>(context).add(
                                LoginWithGooglePressed(),
                              );
                            },
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 5),
                  FlatButton(
                    child: Text(
                      Strings.createAnAccountButtonText,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(Routes.registrationPage);
                    },
                  ),
                  // GoogleLoginButton(),
                  // CreateAccountButton(userRepository: _userRepository),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
