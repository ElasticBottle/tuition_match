import 'package:flutter/material.dart';

typedef OnPressed = void Function(int);

class ToggleButton extends StatefulWidget {
  const ToggleButton({
    Key key,
    this.title,
    this.errorText,
    this.fontFamily,
    this.textColor = Colors.black,
    this.errorColor = Colors.red,
    this.titleFontSize = 14.0,
    this.labelFontSize = 12.0,
    this.errorFontSize = 11.0,
    @required this.activeBgColor,
    @required this.activeTextColor,
    @required this.inactiveTextColor,
    @required this.labels,
    @required this.onPressed,
    this.initialLabelIndex = const [0],
    this.icons,
  }) : super(key: key);

  final String title;
  final String errorText;
  final String fontFamily;
  final Color textColor;
  final Color errorColor;
  final double titleFontSize;
  final double labelFontSize;
  final double errorFontSize;
  final Color activeBgColor;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final List<String> labels;
  final List<IconData> icons;
  final OnPressed onPressed;
  final List<int> initialLabelIndex;

  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (widget.title != null)
          Text(
            widget.title,
            style: TextStyle(
              color: widget.textColor,
              fontFamily: widget.fontFamily ??
                  Theme.of(context).textTheme.bodyText1.fontFamily,
              fontSize: widget.titleFontSize,
            ),
          ),
        ToggleButtons(
          children: List.generate(
              widget.labels.length,
              (index) => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (widget.icons != null) Icon(widget.icons[index]),
                      Text(
                        widget.labels[index],
                        style: TextStyle(
                          fontFamily: widget.fontFamily,
                          fontSize: widget.labelFontSize,
                        ),
                      )
                    ],
                  )),
          isSelected: widget.initialLabelIndex == null
              ? List.generate(widget.labels.length, (index) => false)
              : List.generate(widget.labels.length,
                  (index) => widget.initialLabelIndex.contains(index)),
          onPressed: widget.onPressed,
          color: widget.inactiveTextColor,
          selectedColor: widget.activeTextColor,
          fillColor: widget.activeBgColor,
        ),
        if (widget.errorText != null)
          Text(
            widget.errorText,
            style: TextStyle(
              color: widget.errorColor,
              fontFamily: widget.fontFamily ??
                  Theme.of(context).textTheme.bodyText1.fontFamily,
              fontSize: widget.errorFontSize,
            ),
          ),
      ],
    );
  }
}
