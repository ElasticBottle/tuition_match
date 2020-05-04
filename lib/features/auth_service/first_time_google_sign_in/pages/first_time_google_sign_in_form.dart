import 'package:cotor/common_widgets/buttons/custom_raised_button.dart';
import 'package:cotor/common_widgets/information_capture/custom_text_field.dart';
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
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  final _formKey = GlobalKey<FormState>();

  RegistrationBloc _googleRegistrationBloc;

  void _handleSubmitted(String value) {
    _focusScopeNode.nextFocus();
  }

  bool get isPopulated =>
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
                          controller: _phoneNumController,
                          labelText: Strings.phoneNumLabel,
                          hintText: Strings.phoneNumHint,
                          helpText: Strings.phoneNumDesc,
                          textInputType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: _handleSubmitted,
                          errorText: state.isPhoneNumError
                              ? Strings.errorPhoneNumInvalid
                              : null,
                        ),
                        CustomTextField(
                          controller: _firstNameController,
                          labelText: Strings.firstNameLabel,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: _handleSubmitted,
                          errorText: state.isFirstNameError
                              ? Strings.errorFieldEmpty
                              : null,
                        ),
                        CustomTextField(
                          controller: _lastNameController,
                          labelText: Strings.lastNameLabel,
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
                    child: Text(
                      Strings.saveDetailsButtonText,
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
    _phoneNumController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
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
        phoneNum: _phoneNumController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
      ),
    );
  }
}
