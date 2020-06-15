import 'package:cotor/common_widgets/common_widgets.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/features/authentication/authentication.dart';
import 'package:cotor/features/authentication/presentation/pages/registration/bloc/registration_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FirstTimeGoogleSignInForm extends StatefulWidget {
  @override
  State<FirstTimeGoogleSignInForm> createState() =>
      _FirstTimeGoogleSignInFormState();
}

class _FirstTimeGoogleSignInFormState extends State<FirstTimeGoogleSignInForm> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  final _formKey = GlobalKey<FormState>();

  BlocTextField _countryCodeField;
  BlocTextField _phoneNumField;
  BlocTextField _firstNameField;
  BlocTextField _lastNameField;
  RegistrationBloc _googleRegistrationBloc;

  void _handleSubmitted(String value) {
    _focusScopeNode.nextFocus();
  }

  bool get isPopulated =>
      _countryCodeField.value.isNotEmpty &&
      _phoneNumField.value.isNotEmpty &&
      _firstNameField.value.isNotEmpty &&
      _lastNameField.value.isNotEmpty;

  bool isRegisterButtonEnabled(RegistrationState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _googleRegistrationBloc = BlocProvider.of<RegistrationBloc>(context);
    _countryCodeField = BlocTextField(
      padding: EdgeInsets.zero,
      onChange: (String value) =>
          _googleRegistrationBloc.add(CountryCodeChanged(countryCode: value)),
      hintText: Strings.countryCodeHint,
      textInputType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: _handleSubmitted,
    );
    _phoneNumField = BlocTextField(
      padding: EdgeInsets.zero,
      onChange: (String value) {
        _googleRegistrationBloc.add(PhoneNumChanged(phoneNum: value));
      },
      hintText: Strings.phoneNumHint,
      textInputType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: _handleSubmitted,
    );
    _firstNameField = BlocTextField(
      onChange: (String value) =>
          _googleRegistrationBloc.add(FirstNameChanged(firstName: value)),
      labelText: Strings.firstNameLabel,
      hintText: Strings.firstNameHint,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: _handleSubmitted,
    );
    _lastNameField = BlocTextField(
      onChange: (String value) =>
          _googleRegistrationBloc.add(LastNameChanged(lastName: value)),
      labelText: Strings.lastNameLabel,
      hintText: Strings.lastNameHint,
      textInputAction: TextInputAction.send,
      onFieldSubmitted: (_) =>
          isRegisterButtonEnabled(_googleRegistrationBloc.state)
              ? _onFormSubmitted()
              : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              CustomSnackBar(
                delay: 3,
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
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        builder: (context, state) {
          _phoneNumField.error =
              state.isPhoneNumError ? Strings.errorPhoneNumInvalid : null;
          _countryCodeField.error =
              state.isCountryCodeError ? Strings.errorCountryCodeInvalid : null;
          _firstNameField.error =
              state.isFirstNameError ? Strings.errorFieldEmpty : null;
          _lastNameField.error =
              state.isLastNameError ? Strings.errorFieldEmpty : null;
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Strings.firstTimeSignInTitle,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(height: 5),
                    Text(
                      Strings.firstTimeSignInSubtitle,
                      style: Theme.of(context).textTheme.bodyText2,
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
                            _phoneNumTextField(state),
                            SizedBox(height: 15.0),
                            _firstNameField,
                            _lastNameField,
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
                        child: Text(
                          Strings.saveDetailsButtonText,
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .apply(fontSizeFactor: 1.3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
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
              child: _countryCodeField,
            ),
            SizedBox(width: 10.0),
            Expanded(
              flex: 7,
              child: _phoneNumField,
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
    super.dispose();
  }

  void _onFormSubmitted() {
    _googleRegistrationBloc.add(
      ExternalSignUpSubmission(
        countryCode: _countryCodeField.value,
        phoneNum: _phoneNumField.value,
        firstName: _firstNameField.value,
        lastName: _lastNameField.value,
      ),
    );
  }
}
