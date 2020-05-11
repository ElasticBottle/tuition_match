import 'package:flutter/material.dart';

typedef StringFn = Function(String);

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key key,
    this.focusNode,
    this.onFieldSubmitted,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.initialText,
    this.hintText,
    this.helpText = '',
    this.labelText = '',
    this.errorText,
    this.hintTextStyle,
    this.helperTextStyle,
    this.labeltextStyle,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.paddding = const EdgeInsets.only(bottom: 20.0),
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
  final FocusNode focusNode;

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
          setState(() {
            _isObscureText = !_isObscureText;
          });
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.labelText.isNotEmpty)
              Text(
                widget.labelText,
                style: Theme.of(context).textTheme.headline6,
              ),
            if (widget.labelText.isNotEmpty) SizedBox(height: 10.0),
            SizedBox(
              child: TextFormField(
                focusNode: widget.focusNode,
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
                  border: UnderlineInputBorder(),
                  hintText: widget.hintText,
                  hintStyle: widget.hintTextStyle ??
                      Theme.of(context).textTheme.bodyText2,
                  errorText: widget.errorText,
                  errorMaxLines: 5,
                  prefixIcon: widget.prefixIcon,
                  suffixIcon: _suffixIcon,
                  filled: true,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onBackground,
                        width: 2.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.error, width: 2.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.error, width: 3.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                maxLines: widget.maxLines,
              ),
            ),
            if (widget.helpText.isNotEmpty) SizedBox(height: 10.0),
            if (widget.helpText.isNotEmpty)
              Text(
                widget.helpText ?? '',
                style: Theme.of(context).textTheme.bodyText1,
              )
          ],
        ),
      ),
    );
  }
}
