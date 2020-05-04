import 'package:flutter/material.dart';

typedef StringFn = Function(String);

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key key,
    this.onFieldSubmitted,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.initialText,
    this.hintText,
    this.helpText,
    this.labelText,
    this.errorText,
    this.hintTextStyle,
    this.helperTextStyle,
    this.labeltextStyle,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.paddding = const EdgeInsets.only(bottom: 30.0),
    this.controller,
    this.isObscureText = false,
    this.isShowObscuretextToggle = false,
  })  : assert(controller == null || initialText == null),
        super(key: key);
  final StringFn onFieldSubmitted;
  final StringFn onSaved;
  final StringFn validator;
  final StringFn onChanged;
  final TextEditingController controller;
  final String initialText;
  final String hintText;
  final String helpText;
  final String labelText;
  final String errorText;
  final TextStyle labeltextStyle;
  final TextStyle helperTextStyle;
  final TextStyle hintTextStyle;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final int maxLines;
  final EdgeInsets paddding;
  final bool isObscureText;
  final bool isShowObscuretextToggle;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  Widget _suffixIcon;
  bool _isObscureText;
  @override
  void initState() {
    super.initState();
    _suffixIcon = widget.suffixIcon;
    _isObscureText = widget.isObscureText;
    if (widget.isShowObscuretextToggle) {
      _suffixIcon = IconButton(
        icon: Icon(Icons.remove_red_eye),
        onPressed: () {
          _isObscureText = !_isObscureText;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (_) {
        final FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Padding(
        padding: widget.paddding,
        child: TextFormField(
          controller: widget.controller,
          initialValue: widget.initialText,
          obscureText: _isObscureText,
          keyboardType: widget.textInputType,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onFieldSubmitted,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onSaved: widget.onSaved,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: widget.labelText,
            labelStyle:
                widget.labeltextStyle ?? Theme.of(context).textTheme.headline5,
            helperText: widget.helpText,
            helperStyle:
                widget.helperTextStyle ?? Theme.of(context).textTheme.bodyText1,
            hintText: widget.hintText,
            hintStyle:
                widget.hintTextStyle ?? Theme.of(context).textTheme.bodyText2,
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: _suffixIcon,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 1.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          maxLines: widget.maxLines,
        ),
      ),
    );
  }
}
