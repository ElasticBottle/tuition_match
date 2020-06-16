import 'package:flutter/material.dart';

typedef OnPressed = void Function(int);

class ToggleButton extends StatefulWidget {
  const ToggleButton({
    Key key,
    this.title,
    this.errorText,
    this.titleFontSize = 16.0,
    this.labelFontSize = 15.0,
    this.errorFontSize = 11.0,
    this.activeBgColor,
    this.activeTextColor,
    this.inactiveTextColor,
    @required this.allItems,
    @required this.onPressed,
    this.initialLabelIndex = const [0],
    this.icons,
    this.height = 40.0,
  }) : super(key: key);

  final String title;
  final String errorText;
  final double titleFontSize;
  final double labelFontSize;
  final double errorFontSize;
  final double height;
  final Color activeBgColor;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final List<String> allItems;
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.title != null)
          Text(
            widget.title,
            style: Theme.of(context).textTheme.headline6,
          ),
        SizedBox(height: 10),
        ToggleButtons(
          constraints: BoxConstraints.expand(
            width: MediaQuery.of(context).size.width /
                (1.3 * widget.allItems.length),
            height: widget.height,
          ),
          borderRadius: BorderRadius.circular(10),
          children: List.generate(
              widget.allItems.length,
              (index) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icons != null) Icon(widget.icons[index]),
                      Text(
                        widget.allItems[index],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
          isSelected: widget.initialLabelIndex == null
              ? List.generate(widget.allItems.length, (index) => false)
              : List.generate(widget.allItems.length,
                  (index) => widget.initialLabelIndex.contains(index)),
          onPressed: widget.onPressed,
          color: widget.inactiveTextColor ??
              Theme.of(context).textTheme.bodyText1.color,
          selectedColor: widget.activeTextColor ??
              Theme.of(context).textTheme.button.color,
          fillColor:
              widget.activeBgColor ?? Theme.of(context).colorScheme.primary,
        ),
        SizedBox(height: 10),
        if (widget.errorText != null)
          Text(widget.errorText,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .apply(color: Theme.of(context).colorScheme.error)),
      ],
    );
  }
}
