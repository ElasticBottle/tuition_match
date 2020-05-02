import 'package:cotor/common_widgets/buttons/custom_raised_button.dart';
import 'package:cotor/common_widgets/information_capture/custom_text_field.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/features/auth_service/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordForm extends StatefulWidget {
  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final TextEditingController _emailController = TextEditingController();

  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  final _formKey = GlobalKey<FormState>();

  ForgotPasswordBloc _registrationBloc;

  bool get isPopulated => _emailController.text.isNotEmpty;

  bool isRegisterButtonEnabled(ForgotPasswordState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registrationBloc = BlocProvider.of<ForgotPasswordBloc>(context);
    _emailController.addListener(_onEmailChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
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
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => isRegisterButtonEnabled(state)
                            ? _onFormSubmitted
                            : _focusScopeNode.unfocus(),
                        errorText: state.isEmailError
                            ? Strings.errorEmailInvalid
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
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();

    super.dispose();
  }

  void _onEmailChanged() {
    _registrationBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onFormSubmitted() {
    _registrationBloc.add(
      Submitted(
        email: _emailController.text,
      ),
    );
  }
}
