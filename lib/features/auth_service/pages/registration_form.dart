import 'package:cotor/common_widgets/buttons/custom_raised_button.dart';
import 'package:cotor/common_widgets/information_capture/custom_text_field.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/features/auth_service/bloc/auth_service_bloc/auth_service_bloc.dart';
import 'package:cotor/features/auth_service/bloc/registraiton_bloc/registration_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationForm extends StatefulWidget {
  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  final _formKey = GlobalKey<FormState>();

  RegistrationBloc _registrationBloc;

  void _handleSubmitted(String value) {
    _focusScopeNode.nextFocus();
  }

  bool get isPopulated =>
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _firstNameController.text.isNotEmpty &&
      _lastNameController.text.isNotEmpty &&
      _usernameController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegistrationState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registrationBloc = BlocProvider.of<RegistrationBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _usernameController.addListener(_onUsernameChanged);
    _firstNameController.addListener(_onFirstNameChanged);
    _lastNameController.addListener(_onLastNameChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state.isSuccess) {
          BlocProvider.of<AuthServiceBloc>(context).add(LoggedIn());
          Navigator.of(context).pop();
        }
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(state.loginError),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(20),
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
                          labelText: Strings.emailLabel,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: _handleSubmitted,
                          errorText: state.emailError,
                        ),
                        CustomTextField(
                          labelText: Strings.passwordLabel,
                          hintText: Strings.password8CharactersLabel,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: _handleSubmitted,
                          errorText: state.passwordError,
                        ),
                        CustomTextField(
                          labelText: Strings.usernameLabel,
                          hintText: Strings.chooseYourUsername,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: _handleSubmitted,
                          errorText: state.usernameError,
                        ),
                        CustomTextField(
                          labelText: Strings.firstnameLabel,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: _handleSubmitted,
                          errorText: state.firstNameError,
                        ),
                        CustomTextField(
                          labelText: Strings.lastnameLabel,
                          textInputAction: TextInputAction.send,
                          onFieldSubmitted: isRegisterButtonEnabled(state)
                              ? (value) => _onFormSubmitted
                              : null,
                          errorText: state.lastNameError,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: CustomRaisedButton(
                    onPressed: isRegisterButtonEnabled(state)
                        ? _onFormSubmitted
                        : null,
                    loading: state.isSubmitting,
                    color: ColorsAndFonts.primaryColor,
                    child: Text(
                      Strings.register,
                      style: TextStyle(
                        color: ColorsAndFonts.backgroundColor,
                        fontFamily: ColorsAndFonts.primaryFont,
                        fontWeight: FontWeight.normal,
                        fontSize:
                            ColorsAndFonts.AddAssignmntSubmitButtonFontSize,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _registrationBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _registrationBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onUsernameChanged() {
    _registrationBloc.add(
      UsernameChanged(username: _usernameController.text),
    );
  }

  void _onFirstNameChanged() {
    _registrationBloc.add(
      FirstNameChanged(firstName: _firstNameController.text),
    );
  }

  void _onLastNameChanged() {
    _registrationBloc.add(
      LastNameChanged(lastName: _lastNameController.text),
    );
  }

  void _onFormSubmitted() {
    _registrationBloc.add(
      Submitted(
        email: _emailController.text,
        password: _passwordController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        username: _usernameController.text,
      ),
    );
  }
}
