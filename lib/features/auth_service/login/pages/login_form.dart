import 'package:cotor/common_widgets/buttons/custom_raised_button.dart';
import 'package:cotor/common_widgets/information_capture/custom_text_field.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/spacings_and_heights.dart';
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginBloc _loginBloc;
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  final _formKey = GlobalKey<FormState>();
  static const Key googleButtonKey = Key('google');

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
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Icon(Icons.error), Text(state.failureMessage)],
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
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
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
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: _handleSubmitted,
                        errorText:
                            state.isEmailError ? Strings.errorEmailEmpty : null,
                      ),
                      CustomTextField(
                        controller: _passwordController,
                        labelText: Strings.passwordLabel,
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
                  Navigator.of(context).pushNamed(Routes.forgotPasswordPage);
                },
                child: Text(Strings.forgotPasswordButtonText),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: CustomRaisedButton(
                  onPressed: () async {
                    if (isLoginButtonEnabled(state)) {
                      _onFormSubmitted();
                    }
                  },
                  loading: state.isSubmitting,
                  color: ColorsAndFonts.primaryColor,
                  child: Text(
                    Strings.signInButtonText,
                    style: TextStyle(
                      color: ColorsAndFonts.backgroundColor,
                      fontFamily: ColorsAndFonts.primaryFont,
                      fontWeight: FontWeight.normal,
                      fontSize: ColorsAndFonts.AddAssignmntSubmitButtonFontSize,
                    ),
                  ),
                ),
              ),
              SizedBox(
                  height: SpacingsAndHeights.addAssignmentPageFieldSpacing),
              SocialSignInButton(
                key: googleButtonKey,
                assetName: 'assets/sign_in/go-logo.png',
                text: Strings.signInWithGoogleButtonText,
                onPressed: state.isSubmitting
                    ? null
                    : () {
                        BlocProvider.of<LoginBloc>(context).add(
                          LoginWithGooglePressed(),
                        );
                      },
                color: Colors.white,
              ),
              FlatButton(
                child: Text(
                  Strings.createAnAccountButtonText,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true)
                      .pushNamed(Routes.registrationPage);
                },
              ),
              // GoogleLoginButton(),
              // CreateAccountButton(userRepository: _userRepository),
            ],
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
