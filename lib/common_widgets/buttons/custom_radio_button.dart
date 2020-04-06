//library custom_radio_grouped_button;
import 'package:flutter/material.dart';

class CustomRadioButton extends StatefulWidget {
  const CustomRadioButton({
    this.buttonLables,
    this.buttonValues,
    this.radioButtonValue,
    @required this.buttonColor,
    @required this.selectedColor,
    this.height = 35,
    this.width = 100,
    this.vertical = false,
    this.enableShape = false,
    this.elevation = 10,
    this.customShape,
    this.defaultSelected = 0,
    this.fontSize = 12.0,
    this.textColor = Colors.black87,
    this.textSelectedColor = Colors.white70,
    this.checkBoxSpacing = 0.0,
  })  : assert(buttonLables.length == buttonValues.length),
        assert(buttonColor != null),
        assert(selectedColor != null);

  final bool vertical;

  final List buttonValues;

  final double height;
  final double width;

  final List<String> buttonLables;

  final Function(dynamic, int) radioButtonValue;

  final Color selectedColor;
  final Color buttonColor;
  final Color textSelectedColor;
  final Color textColor;
  final int defaultSelected;
  final ShapeBorder customShape;
  final bool enableShape;
  final double elevation;
  final double fontSize;
  final double checkBoxSpacing;

  @override
  _CustomRadioButtonState createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  int currentSelected;
  String currentSelectedLabel;

  @override
  void initState() {
    super.initState();
    currentSelected = widget.defaultSelected;
    currentSelectedLabel = widget.buttonLables[currentSelected];
  }

  List<Widget> buildButtonsColumn() {
    final List<Widget> buttons = [];
    for (int index = 0; index < widget.buttonLables.length; index++) {
      final Widget button = Card(
        color: currentSelectedLabel == widget.buttonLables[index]
            ? widget.selectedColor
            : widget.buttonColor,
        elevation: widget.elevation,
        shape: widget.enableShape
            ? widget.customShape == null
                ? BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  )
                : widget.customShape
            : null,
        child: Container(
          height: widget.height,
          child: MaterialButton(
            onPressed: () {
              widget.radioButtonValue(widget.buttonValues[index], index);
              setState(() {
                currentSelected = index;
                currentSelectedLabel = widget.buttonLables[index];
              });
            },
            child: Text(
              widget.buttonLables[index],
              style: TextStyle(
                color: currentSelectedLabel == widget.buttonLables[index]
                    ? widget.textSelectedColor
                    : widget.textColor,
                fontSize: widget.fontSize,
              ),
            ),
          ),
        ),
      );
      buttons.add(button);
    }
    return buttons;
  }

  List<Widget> buildButtonsRow() {
    final List<Widget> buttons = [];
    for (int index = 0; index < widget.buttonLables.length; index++) {
      final Widget button = Card(
        color: currentSelectedLabel == widget.buttonLables[index]
            ? widget.selectedColor
            : widget.buttonColor,
        elevation: widget.elevation,
        shape: widget.enableShape
            ? widget.customShape == null
                ? BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  )
                : widget.customShape
            : null,
        child: Container(
          height: widget.height,
          width: widget.width,
          constraints: BoxConstraints(maxWidth: 250),
          child: MaterialButton(
            shape: widget.enableShape
                ? widget.customShape == null
                    ? OutlineInputBorder(
                        borderSide:
                            BorderSide(color: widget.selectedColor, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      )
                    : widget.customShape
                : OutlineInputBorder(
                    borderSide:
                        BorderSide(color: widget.selectedColor, width: 1),
                    borderRadius: BorderRadius.zero,
                  ),
            onPressed: () {
              widget.radioButtonValue(widget.buttonValues[index], index);
              setState(() {
                currentSelected = index;
                currentSelectedLabel = widget.buttonLables[index];
              });
            },
            child: Text(
              widget.buttonLables[index],
              style: TextStyle(
                color: currentSelectedLabel == widget.buttonLables[index]
                    ? widget.textSelectedColor
                    : widget.textColor,
                fontSize: widget.fontSize,
              ),
            ),
          ),
        ),
      );
      buttons.add(button);
      // if (index != widget.buttonLables.length) {
      //   buttons.add(
      //     SizedBox(
      //       width: widget.checkBoxSpacing,
      //     ),
      //   );
      // }
    }
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> rowButtons = buildButtonsRow();
    return Container(
      height: widget.vertical
          ? widget.height * (widget.buttonLables.length + 0.5)
          : widget.height,
      child: Center(
        child: widget.vertical
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: buildButtonsColumn(),
              )
            : ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: rowButtons.length,
                itemBuilder: (context, index) {
                  return rowButtons[index];
                },
                separatorBuilder: (context, index) => SizedBox(
                  width: widget.checkBoxSpacing,
                ),
              ),
      ),
    );
  }
}
