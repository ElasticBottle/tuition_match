import 'package:cotor/common_widgets/buttons/custom_raised_button.dart';
import 'package:cotor/common_widgets/information_capture/custom_text_field.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/features/auth_service/registration/bloc/registration_bloc.dart';
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
  final TextEditingController _phoneNumController = TextEditingController();

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
      _phoneNumController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegistrationState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registrationBloc = BlocProvider.of<RegistrationBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _phoneNumController.addListener(_onPhoneNumChanged);
    _firstNameController.addListener(_onFirstNameChanged);
    _lastNameController.addListener(_onLastNameChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state.isSuccess) {
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
                    Text(state.failureMessage),
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
                          controller: _emailController,
                          labelText: Strings.emailLabel,
                          hintText: Strings.emailHint,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: _handleSubmitted,
                          errorText: state.isEmailError
                              ? Strings.errorEmailInvalid
                              : null,
                        ),
                        CustomTextField(
                          controller: _passwordController,
                          labelText: Strings.passwordLabel,
                          hintText: Strings.passwordHint,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: _handleSubmitted,
                          errorText: state.isPasswordError
                              ? Strings.errorPasswordTooShort
                              : null,
                          isObscureText: true,
                          isShowObscuretextToggle: true,
                        ),
                        CustomTextField(
                          controller: _phoneNumController,
                          labelText: Strings.phoneNumLabel,
                          textInputType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: _handleSubmitted,
                          errorText: state.isPhoneNumError
                              ? Strings.errorPhoneNumInvalid
                              : null,
                        ),
                        CustomTextField(
                          controller: _firstNameController,
                          labelText: Strings.firstnameLabel,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: _handleSubmitted,
                          errorText: state.isFirstNameError
                              ? Strings.errorFieldEmpty
                              : null,
                        ),
                        CustomTextField(
                          controller: _lastNameController,
                          labelText: Strings.lastnameLabel,
                          textInputAction: TextInputAction.send,
                          onFieldSubmitted: isRegisterButtonEnabled(state)
                              ? (value) => _onFormSubmitted
                              : null,
                          errorText: state.isLastNameError
                              ? Strings.errorFieldEmpty
                              : null,
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
                    color: Theme.of(context).colorScheme.primary,
                    child: Text(
                      Strings.registerButtonText,
                      style: Theme.of(context).textTheme.button,
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

  void _onPhoneNumChanged() {
    _registrationBloc.add(
      PhoneNumChanged(phoneNum: _phoneNumController.text),
    );
  }

  void _onFormSubmitted() {
    _registrationBloc.add(
      Submitted(
        email: _emailController.text,
        password: _passwordController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phoneNum: _phoneNumController.text,
      ),
    );
  }
}
