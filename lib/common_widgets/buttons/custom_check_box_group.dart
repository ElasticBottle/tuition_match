//library custom_radio_grouped_button;
import 'package:flutter/material.dart';

class CustomCheckBoxGroup extends StatefulWidget {
  CustomCheckBoxGroup({
    this.buttonLables,
    this.buttonValuesList,
    this.checkBoxButtonValues,
    this.buttonColor,
    this.selectedColor,
    this.height = 35,
    this.width = 100,
    this.defaultSelected,
    this.padding = 3,
    this.vertical = false,
    this.enableShape = false,
    this.elevation = 10,
    this.customShape,
    this.fontSize = 12.0,
    this.textColor = Colors.black87,
    this.textSelectedColor = Colors.white70,
    this.checkBoxSpacing = 0.0,
  })  : assert(buttonLables.length == buttonValuesList.length),
        assert(buttonColor != null),
        // assert(defaultSelected != null
        // ? buttonValuesList.contains(defaultSelected) != false
        // : true),
        assert(selectedColor != null);

  final bool vertical;

  final List buttonValuesList;

  final double height;
  final double padding;
  final double width;

  final List<String> buttonLables;

  final Function(List<dynamic>) checkBoxButtonValues;

  final Color selectedColor;
  final Color buttonColor;
  final Color textSelectedColor;
  final Color textColor;
  final dynamic defaultSelected;
  final bool enableShape;
  final ShapeBorder customShape;

  final double elevation;
  final double fontSize;
  final double checkBoxSpacing;

  _CustomCheckBoxGroupState createState() => _CustomCheckBoxGroupState();
}

class _CustomCheckBoxGroupState extends State<CustomCheckBoxGroup> {
  List<dynamic> selectedLables = <dynamic>[];

  @override
  void initState() {
    super.initState();
    // currentSelectedLabel = widget.buttonLables[0];
  }

  List<Widget> buildButtonsColumn() {
    List<Widget> buttons = [];
    for (int index = 0; index < widget.buttonLables.length; index++) {
      var button = Padding(
        padding: EdgeInsets.all(widget.padding),
        child: Card(
          color: selectedLables.contains(widget.buttonValuesList[index])
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
                if (selectedLables.contains(widget.buttonValuesList[index])) {
                  selectedLables.remove(widget.buttonValuesList[index]);
                } else {
                  selectedLables.add(widget.buttonValuesList[index]);
                }
                setState(() {});
                widget.checkBoxButtonValues(selectedLables);
              },
              child: Text(
                widget.buttonLables[index],
                style: TextStyle(
                  color: selectedLables.contains(widget.buttonValuesList[index])
                      ? widget.textSelectedColor
                      : widget.textColor,
                  fontSize: widget.fontSize,
                ),
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
    List<Widget> buttons = [];
    for (int index = 0; index < widget.buttonLables.length; index++) {
      var button = Card(
        color: selectedLables.contains(widget.buttonValuesList[index])
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
          decoration: BoxDecoration(),
          child: MaterialButton(
            shape: widget.enableShape
                ? widget.customShape == null
                    ? OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      )
                    : widget.customShape
                : OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 1),
                    borderRadius: BorderRadius.zero,
                  ),
            onPressed: () {
              if (selectedLables.contains(widget.buttonValuesList[index])) {
                selectedLables.remove(widget.buttonValuesList[index]);
              } else {
                selectedLables.add(widget.buttonValuesList[index]);
              }
              setState(() {});
              widget.checkBoxButtonValues(selectedLables);
            },
            child: Text(
              widget.buttonLables[index],
              style: TextStyle(
                color: selectedLables.contains(widget.buttonValuesList[index])
                    ? widget.textSelectedColor
                    : widget.textColor,
                fontSize: widget.fontSize,
              ),
            ),
          ),
        ),
        // ),
      );
      buttons.add(button);
    }
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.vertical
          ? widget.height * (widget.buttonLables.length * 1.5) +
              widget.padding * 2 * widget.buttonLables.length
          : widget.height,
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Center(
          child: widget.vertical
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: buildButtonsColumn(),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: buildButtonsRow().length,
                  itemBuilder: (context, index) {
                    return buildButtonsRow()[index];
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    width: widget.checkBoxSpacing,
                  ),
                ),
        ),
      ),
    );
  }
}
