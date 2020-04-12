import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    this.onFieldSubmitted,
    this.onSaved,
    this.validator,
    this.initialText = '',
    this.hintText,
    this.helpText,
    this.labelText,
    this.errorText,
    this.hintFontSize = 12.0,
    this.helperFontSize = 12.0,
    this.labelFontSize = 18.0,
    this.textInputAction = TextInputAction.next,
    this.prefixIcon,
    this.maxLines = 1,
    this.bottomPadding = 30.0,
    this.controller,
  }) : assert(controller == null || initialText == null);
  final Function(String) onFieldSubmitted;
  final Function(String) onSaved;
  final Function(String) validator;
  final String initialText;
  final String hintText;
  final String helpText;
  final String labelText;
  final String errorText;
  final double labelFontSize;
  final double helperFontSize;
  final double hintFontSize;
  final TextInputAction textInputAction;
  final Icon prefixIcon;
  final int maxLines;
  final double bottomPadding;
  final TextEditingController controller;

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
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: TextFormField(
          controller: controller,
          initialValue: initialText,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          validator: validator,
          onSaved: onSaved,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: labelText,
            labelStyle: TextStyle(
              color: ColorsAndFonts.primaryColor,
              fontFamily: ColorsAndFonts.primaryFont,
              fontSize: labelFontSize,
            ),
            helperText: helpText,
            helperStyle: TextStyle(
              color: ColorsAndFonts.primaryColor,
              fontFamily: ColorsAndFonts.primaryFont,
              fontWeight: FontWeight.normal,
              fontSize: helperFontSize,
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              color: ColorsAndFonts.primaryColor,
              fontFamily: ColorsAndFonts.primaryFont,
              fontWeight: FontWeight.normal,
              fontSize: hintFontSize,
            ),
            errorText: errorText,
            prefixIcon: prefixIcon,
            fillColor: Colors.grey[200],
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: ColorsAndFonts.primaryColor, width: 1.0),
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
          maxLines: maxLines,
        ),
      ),
    );
  }
}
