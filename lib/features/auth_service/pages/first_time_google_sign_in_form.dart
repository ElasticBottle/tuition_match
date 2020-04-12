import 'package:cotor/common_widgets/buttons/custom_raised_button.dart';
import 'package:cotor/common_widgets/information_capture/custom_text_field.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/features/auth_service/bloc/first_time_google_sign_in/first_time_google_sign_in_bloc.dart';
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

  FirstTimeGoogleSignInBloc _firstTimeGoogleSignInBloc;

  void _handleSubmitted(String value) {
    _focusScopeNode.nextFocus();
  }

  bool get isPopulated =>
      _phoneNumController.text.isNotEmpty &&
      _firstNameController.text.isNotEmpty &&
      _lastNameController.text.isNotEmpty;

  bool isRegisterButtonEnabled(FirstTimeGoogleSignInState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _firstTimeGoogleSignInBloc =
        BlocProvider.of<FirstTimeGoogleSignInBloc>(context);
    _phoneNumController.addListener(_onPhoneNumChanged);
    _firstNameController.addListener(_onFirstNameChanged);
    _lastNameController.addListener(_onLastNameChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FirstTimeGoogleSignInBloc, FirstTimeGoogleSignInState>(
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.of(context).pop();
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
                    Text(state.loginError),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<FirstTimeGoogleSignInBloc, FirstTimeGoogleSignInState>(
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
                          initialText: null,
                          labelText: Strings.phoneLabel,
                          hintText: Strings.validPhoneNumber,
                          helpText: Strings.phoneNumberForContact,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: _handleSubmitted,
                          errorText: state.phoneNumError,
                        ),
                        CustomTextField(
                          controller: _firstNameController,
                          initialText: null,
                          labelText: Strings.firstnameLabel,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: _handleSubmitted,
                          errorText: state.firstNameError,
                        ),
                        CustomTextField(
                          controller: _lastNameController,
                          initialText: null,
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
                      Strings.saveDetails,
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
    _phoneNumController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _onPhoneNumChanged() {
    _firstTimeGoogleSignInBloc.add(
      PhoneNumChanged(phoneNum: _phoneNumController.text),
    );
  }

  void _onFirstNameChanged() {
    _firstTimeGoogleSignInBloc.add(
      FirstNameChanged(firstName: _firstNameController.text),
    );
  }

  void _onLastNameChanged() {
    _firstTimeGoogleSignInBloc.add(
      LastNameChanged(lastName: _lastNameController.text),
    );
  }

  void _onFormSubmitted() {
    _firstTimeGoogleSignInBloc.add(
      Submitted(
        phoneNum: _phoneNumController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
      ),
    );
  }
}
