import 'package:cotor/common_widgets/buttons/custom_check_box_group.dart';
import 'package:cotor/common_widgets/buttons/custom_radio_button.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:flutter/material.dart';

class CustomSelector extends StatelessWidget {
  const CustomSelector({
    this.title,
    this.defaultSelected,
    this.labels,
    this.values,
    this.onPressed,
    this.fontSize = 12.0,
    this.isRadio = true,
    this.checkBoxOnPressed,
    this.paddingAfter = 10.0,
    this.errorText,
  });
  final String title;
  final int defaultSelected;
  final List<String> labels;
  final List<dynamic> values;
  final Function(dynamic, int) onPressed;
  final Function(List<dynamic>) checkBoxOnPressed;
  final double fontSize;
  final bool isRadio;
  final double paddingAfter;
  final String errorText;

  // final List<Level> levelValues;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            color: errorText == null
                ? ColorsAndFonts.primaryColor
                : ColorsAndFonts.errorColor,
            fontFamily: ColorsAndFonts.primaryFont,
            fontSize: fontSize,
          ),
        ),
        isRadio
            ? CustomRadioButton(
                elevation: 0.0,
                vertical: false,
                buttonColor: Theme.of(context).canvasColor,
                width: 95,
                height: 50,
                fontSize: ColorsAndFonts.addAssignmentSelectionFontSize,
                defaultSelected: defaultSelected,
                buttonLables: labels,
                buttonValues: values,
                radioButtonValue: onPressed,
                selectedColor: Theme.of(context).accentColor,
              )
            : CustomCheckBoxGroup(
                elevation: 0.0,
                vertical: false,
                buttonColor: Theme.of(context).canvasColor,
                width: 95,
                height: 50,
                fontSize: ColorsAndFonts.addAssignmentSelectionFontSize,
                defaultSelected: defaultSelected,
                buttonLables: labels,
                buttonValuesList: values,
                checkBoxButtonValues: checkBoxOnPressed,
                selectedColor: Theme.of(context).accentColor,
              ),
        if (errorText != null)
          Text(
            errorText,
            style: TextStyle(
              color: ColorsAndFonts.errorColor,
              fontFamily: ColorsAndFonts.primaryFont,
              fontSize: fontSize,
            ),
          ),
        SizedBox(height: paddingAfter),
      ],
    );
  }
}
