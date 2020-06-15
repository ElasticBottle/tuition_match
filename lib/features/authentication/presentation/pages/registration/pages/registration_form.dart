import 'package:cotor/common_widgets/common_widgets.dart';
import 'package:cotor/common_widgets/information_capture/custom_text_field.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/features/authentication/authentication.dart';
import 'package:cotor/features/authentication/presentation/pages/registration/bloc/registration_bloc.dart';
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
  final TextEditingController _countryCodeController =
      TextEditingController(text: Strings.initialCountryCode);

  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  final _formKey = GlobalKey<FormState>();

  RegistrationBloc _registrationBloc;

  void _handleSubmitted(String value) {
    _focusScopeNode.nextFocus();
  }

  void _handlePasswordNext(String value) {
    _focusScopeNode..nextFocus()..nextFocus()..nextFocus();
  }

  bool get isPopulated =>
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _firstNameController.text.isNotEmpty &&
      _lastNameController.text.isNotEmpty &&
      _countryCodeController.text.isNotEmpty &&
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
    _firstNameController.addListener(_onFirstNameChanged);
    _lastNameController.addListener(_onLastNameChanged);
    _phoneNumController.addListener(_onPhoneNumChanged);
    _countryCodeController..addListener(_onCountryCodeChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          Navigator.of(context).pop();
        }
        if (state.isFailure) {
          print(state.failureMessage);
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
          padding: EdgeInsets.all(20),
          child: ListView(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height / 8),
              Text(Strings.registrationTitle,
                  style: Theme.of(context).textTheme.headline3),
              Text(Strings.registrationSubtitle,
                  style: Theme.of(context).textTheme.bodyText2),
              SizedBox(height: 50.0),
              FocusScope(
                node: _focusScopeNode,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // TODO(EB): port over to bloc text field
                      CustomTextField(
                        controller: _emailController,
                        labelText: Strings.emailLabel,
                        hintText: Strings.emailHint,
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.emailAddress,
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
                        onFieldSubmitted: _handlePasswordNext,
                        errorText: state.isPasswordError
                            ? Strings.errorPasswordTooShort
                            : null,
                        isObscureText: true,
                        isShowObscuretextToggle: true,
                      ),
                      SizedBox(height: 15.0),
                      _phoneNumTextField(state),
                      SizedBox(height: 30.0),
                      CustomTextField(
                        controller: _firstNameController,
                        labelText: Strings.firstNameLabel,
                        hintText: Strings.firstNameHint,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: _handleSubmitted,
                        errorText: state.isFirstNameError
                            ? Strings.errorFieldEmpty
                            : null,
                      ),
                      CustomTextField(
                        controller: _lastNameController,
                        labelText: Strings.lastNameLabel,
                        hintText: Strings.lastNameHint,
                        textInputAction: TextInputAction.send,
                        onFieldSubmitted: (_) => isRegisterButtonEnabled(state)
                            ? _onFormSubmitted()
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
                  onPressed:
                      isRegisterButtonEnabled(state) ? _onFormSubmitted : null,
                  loading: state.isSubmitting,
                  color: Theme.of(context).colorScheme.primary,
                  child: Text(
                    Strings.registerButtonText,
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .apply(fontSizeFactor: 1.3),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _phoneNumTextField(RegistrationState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.phoneNumLabel,
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: CustomTextField(
                paddding: EdgeInsets.zero,
                controller: _countryCodeController,
                hintText: Strings.countryCodeHint,
                textInputType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: _handleSubmitted,
                errorText: state.isCountryCodeError
                    ? Strings.errorCountryCodeInvalid
                    : null,
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              flex: 7,
              child: CustomTextField(
                paddding: EdgeInsets.zero,
                controller: _phoneNumController,
                hintText: Strings.phoneNumHint,
                textInputType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: _handleSubmitted,
                errorText:
                    state.isPhoneNumError ? Strings.errorPhoneNumInvalid : null,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Text(Strings.phoneNumDesc),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _countryCodeController.dispose();
    _phoneNumController.dispose();
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

  void _onCountryCodeChanged() {
    _registrationBloc.add(
      CountryCodeChanged(countryCode: _countryCodeController.text),
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
        countryCode: _countryCodeController.text,
      ),
    );
  }
}
