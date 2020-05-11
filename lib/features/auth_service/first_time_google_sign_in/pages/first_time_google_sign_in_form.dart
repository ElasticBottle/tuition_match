import 'package:cotor/common_widgets/buttons/custom_raised_button.dart';
import 'package:cotor/common_widgets/information_capture/custom_text_field.dart';
import 'package:cotor/common_widgets/information_display/custom_snack_bar.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/features/auth_service/registration/bloc/registration_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FirstTimeGoogleSignInForm extends StatefulWidget {
  @override
  State<FirstTimeGoogleSignInForm> createState() =>
      _FirstTimeGoogleSignInFormState();
}

class _FirstTimeGoogleSignInFormState extends State<FirstTimeGoogleSignInForm> {
  final TextEditingController _phoneNumController = TextEditingController();
  final TextEditingController _countryCodeController =
      TextEditingController(text: Strings.initialCountryCode);
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  final _formKey = GlobalKey<FormState>();

  RegistrationBloc _googleRegistrationBloc;

  void _handleSubmitted(String value) {
    _focusScopeNode.nextFocus();
  }

  bool get isPopulated =>
      _countryCodeController.text.isNotEmpty &&
      _phoneNumController.text.isNotEmpty &&
      _firstNameController.text.isNotEmpty &&
      _lastNameController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegistrationState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _googleRegistrationBloc = BlocProvider.of<RegistrationBloc>(context);
    _countryCodeController..addListener(_onCountryCodeChanged);
    _phoneNumController.addListener(_onPhoneNumChanged);
    _firstNameController.addListener(_onFirstNameChanged);
    _lastNameController.addListener(_onLastNameChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state.isSuccess) {
          // BlocProvider.of<AuthServiceBloc>(context).add(LoggedIn());
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
                              onFieldSubmitted: (_) =>
                                  isRegisterButtonEnabled(state)
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
    _countryCodeController.dispose();
    _phoneNumController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _onCountryCodeChanged() {
    _googleRegistrationBloc.add(
      CountryCodeChanged(countryCode: _countryCodeController.text),
    );
  }

  void _onPhoneNumChanged() {
    _googleRegistrationBloc.add(
      PhoneNumChanged(phoneNum: _phoneNumController.text),
    );
  }

  void _onFirstNameChanged() {
    _googleRegistrationBloc.add(
      FirstNameChanged(firstName: _firstNameController.text),
    );
  }

  void _onLastNameChanged() {
    _googleRegistrationBloc.add(
      LastNameChanged(lastName: _lastNameController.text),
    );
  }

  void _onFormSubmitted() {
    _googleRegistrationBloc.add(
      ExternalSignUpSubmission(
        countryCode: _countryCodeController.text,
        phoneNum: _phoneNumController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
      ),
    );
  }
}
