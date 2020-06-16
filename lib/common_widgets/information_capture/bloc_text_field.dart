import 'package:flutter/material.dart';

typedef StringFn = Function(String);

class BlocTextField extends StatefulWidget {
  BlocTextField({
    Key key,
    this.focusNode,
    this.onFieldSubmitted,
    this.onSaved,
    this.onChange,
    this.initialText,
    this.hintText,
    this.helpText = '',
    this.labelText = '',
    this.errorText,
    this.hintTextStyle,
    this.helperTextStyle,
    this.labelTextStyle,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.padding = const EdgeInsets.only(bottom: 20.0),
    this.isObscureText = false,
    this.isShowObscureTextToggle = false,
  })  : controller = TextEditingController(text: initialText ?? ''),
        super(key: key);
  final StringFn onFieldSubmitted;
  final StringFn onSaved;
  final StringFn onChange;

  final String initialText;
  final String hintText;
  final String helpText;
  final String labelText;
  String errorText;

  final TextStyle labelTextStyle;
  final TextStyle helperTextStyle;
  final TextStyle hintTextStyle;

  final TextInputAction textInputAction;
  final TextInputType textInputType;

  final Widget prefixIcon;
  final Widget suffixIcon;

  final int maxLines;
  final EdgeInsets padding;
  final bool isObscureText;
  final bool isShowObscureTextToggle;
  final FocusNode focusNode;
  final TextEditingController controller;

  String get value => controller.text;
  set error(String error) => errorText = error;
  @override
  _BlocTextFieldState createState() => _BlocTextFieldState();
}

class _BlocTextFieldState extends State<BlocTextField> {
  Widget _suffixIcon;
  bool _isObscureText;
  @override
  void initState() {
    super.initState();
    _suffixIcon = widget.suffixIcon;
    _isObscureText = widget.isObscureText;
    if (widget.isShowObscureTextToggle) {
      _suffixIcon = IconButton(
        icon: Icon(Icons.remove_red_eye),
        onPressed: () {
          setState(() {
            _isObscureText = !_isObscureText;
          });
        },
      );
    }
    widget.controller.addListener(() {
      widget.onChange(widget.controller.text);
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.dispose();
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
        padding: widget.padding,
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
