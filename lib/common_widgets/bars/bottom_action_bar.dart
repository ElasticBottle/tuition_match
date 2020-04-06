import 'package:flutter/material.dart';

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({
    @required this.numClickAction,
    @required this.mainOnPressed,
    @required this.actionOnPressed,
    @required this.callToActionText,
    @required this.numClickCallToAction,
    this.heroTag,
    this.actionIcon = Icons.favorite,
    this.actionIconSize = 30.0,
    this.mainColor = Colors.black,
    this.callToActionTextColor = Colors.white,
    this.callToActionTextFontSize = 15.0,
    this.numClickActionFontSize = 15.0,
    this.fontFamily = 'Quicksand',
  });
  final String heroTag;
  final int numClickAction;
  final String numClickCallToAction;
  final Function mainOnPressed;
  final Function actionOnPressed;
  final String callToActionText;
  final IconData actionIcon;
  final double actionIconSize;
  final Color mainColor;
  final Color callToActionTextColor;
  final double callToActionTextFontSize;
  final double numClickActionFontSize;
  final String fontFamily;
  @override
  Widget build(BuildContext context) {
    if (heroTag == null) {
      return _mainBody();
    } else {
      return Hero(
        tag: heroTag,
        child: _mainBody(),
      );
    }
  }

  Widget _mainBody() {
    return Material(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              color: mainColor,
              child: Text(callToActionText,
                  style: TextStyle(
                    color: callToActionTextColor,
                    fontFamily: fontFamily,
                    fontSize: callToActionTextFontSize,
                  )),
              onPressed: mainOnPressed,
            ),
          ),
          IconButton(
            icon: Icon(
              actionIcon,
              color: mainColor,
              size: actionIconSize,
            ),
            onPressed: actionOnPressed,
          ),
          Text(
            numClickAction.toString(),
            style: TextStyle(
                color: mainColor,
                fontFamily: fontFamily,
                fontSize: numClickActionFontSize),
          ),
        ],
      ),
    );
  }
}
