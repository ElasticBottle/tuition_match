import 'package:cotor/constants/strings.dart';
import 'package:flutter/material.dart';

class BottomActionBarSpacings {
  const BottomActionBarSpacings({
    this.spacingLeadingAndButton,
    this.spacingButtonAndTrailing,
    this.buttonSpacing,
  });

  /// Adds spacing between the end of the leading widgets and the start of the buttons
  final double spacingLeadingAndButton;

  /// Adds spacing between the end of the buttons and the start of the trailing widgets
  final double spacingButtonAndTrailing;

  /// Adds spacing between each of the individual buttons
  final double buttonSpacing;
}

class ButtonProperties {
  ButtonProperties({
    @required this.text,
    @required this.onPressed,
    this.style,
    this.color,
  })  : assert(text != null),
        assert(onPressed != null);
  final String text;
  final VoidCallback onPressed;

  /// specifies the TextStyle of a particular button in the bottomActionBar
  /// See [buttonColor] in [BottomActionBar] to apply one TextStyle to all the buttons
  final TextStyle style;

  /// specifies the color of a particular button in the bottomActionBar
  /// See [buttonColor] in [BottomActionBar] to apply one color to all the buttons
  final Color color;
}

class BottomActionBarNew extends StatelessWidget {
  const BottomActionBarNew({
    Key key,
    @required this.buttonProperties,
    this.buttonTextStyle,
    this.heroTag,
    this.leading = const [],
    this.trailing = const [],
    this.details,
    this.buttonColor,
    this.barColor,
    this.spacings = const BottomActionBarSpacings(
      buttonSpacing: 10.0,
      spacingButtonAndTrailing: 10.0,
      spacingLeadingAndButton: 10.0,
    ),
    this.padding = const EdgeInsets.all(10.0),
    this.buttonHeight = 60,
  })  : assert(buttonProperties != null),
        super(key: key);

  factory BottomActionBarNew.userBar({
    VoidCallback viewAppsCallback,
    VoidCallback viewRequestCallback,
    bool isProfile,
  }) {
    return BottomActionBarNew(
      buttonProperties: [
        ButtonProperties(
          onPressed: viewAppsCallback,
          text: isProfile
              ? Strings.outgoingApplications
              : Strings.incomingApplications,
        ),
        // ButtonProperties(
        //   onPressed: viewRequestCallback,
        //   text: Strings.incomingRequests,
        // )
      ],
    );
  }

  factory BottomActionBarNew.requestWithLike({
    VoidCallback applyOnPress,
    VoidCallback likedOnPress,
    bool isLiked,
    int requestCount,
    bool isProfile,
  }) {
    return BottomActionBarNew(
      buttonProperties: [
        ButtonProperties(
          onPressed: applyOnPress,
          text: isProfile ? Strings.request : Strings.apply,
        ),
      ],
      spacings: BottomActionBarSpacings(spacingButtonAndTrailing: 10.0),
      trailing: [
        IconButton(
          icon: isLiked ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
          onPressed: likedOnPress,
        )
      ],
      details: Text(requestCount.toString() +
          ' ' +
          (isProfile ? Strings.requested : Strings.applied)),
    );
  }

  factory BottomActionBarNew.statusBar({
    VoidCallback onPressed,
    String status,
    VoidCallback likedOnPress,
    bool isLiked,
    int requestCount,
    bool isProfile,
  }) {
    return BottomActionBarNew(
      buttonProperties: [
        ButtonProperties(
          onPressed: onPressed,
          text: status,
        ),
      ],
      spacings: BottomActionBarSpacings(spacingButtonAndTrailing: 10.0),
      trailing: [
        IconButton(
          icon: isLiked ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
          onPressed: likedOnPress,
        )
      ],
      details: Text(requestCount.toString() +
          ' ' +
          (isProfile ? Strings.request : Strings.applied)),
    );
  }

  factory BottomActionBarNew.acceptDeny({
    VoidCallback reviewedCallback,
    VoidCallback denyCallback,
    VoidCallback likedOnPress,
    bool isLiked,
  }) {
    return BottomActionBarNew(
      buttonProperties: [
        ButtonProperties(
          onPressed: reviewedCallback,
          text: Strings.accept,
        ),
        ButtonProperties(
          onPressed: denyCallback,
          text: Strings.deny,
        )
      ],
      spacings: BottomActionBarSpacings(spacingButtonAndTrailing: 10.0),
      trailing: [
        IconButton(
          icon: isLiked ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
          onPressed: likedOnPress,
        )
      ],
    );
  }

  final String heroTag;
  final Color barColor;
  final List<Widget> leading;
  final List<ButtonProperties> buttonProperties;
  final List<Widget> trailing;

  /// For use to display any additional information below the buttons
  final Widget details;

  /// Used if all the button are to be of the same color
  final Color buttonColor;

  /// Used if all the text are to be of the same style
  final TextStyle buttonTextStyle;
  final BottomActionBarSpacings spacings;
  final EdgeInsets padding;
  final double buttonHeight;

  @override
  Widget build(BuildContext context) {
    if (heroTag == null) {
      return _mainBody(context);
    } else {
      return Hero(
        tag: heroTag + 'bottomActionBar',
        child: _mainBody(context),
      );
    }
  }

  Widget _mainBody(BuildContext context) {
    final List<Widget> buttons = [];
    final int length = buttonProperties.length;
    for (int i = 0; i < length; i++) {
      buttons.add(_generateButton(context, i));
      if (i != length - 1) {
        buttons.add(SizedBox(width: spacings.buttonSpacing));
      }
    }
    return Material(
      color: barColor ?? Theme.of(context).colorScheme.surface,
      child: Container(
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ...leading,
            if (leading.isNotEmpty)
              SizedBox(
                width: spacings.spacingLeadingAndButton,
              ),
            Flexible(
              fit: FlexFit.loose,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      ...buttons,
                    ],
                  ),
                  if (details != null) details,
                ],
              ),
            ),
            if (trailing.isNotEmpty)
              SizedBox(
                width: spacings.spacingButtonAndTrailing,
              ),
            ...trailing,
          ],
        ),
      ),
    );
  }

  Widget _generateButton(BuildContext context, int i) {
    return Expanded(
      child: SizedBox(
        height: buttonHeight,
        child: FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: buttonColor != null
              ? buttonColor
              : buttonProperties[i].color == null
                  ? Theme.of(context).colorScheme.primary
                  : buttonProperties[i].color,
          child: Text(
            buttonProperties[i].text,
            style: buttonTextStyle != null
                ? buttonTextStyle
                : buttonProperties[i].style == null
                    ? Theme.of(context).textTheme.button
                    : buttonProperties[i].style,
          ),
          onPressed: buttonProperties[i].onPressed,
        ),
      ),
    );
  }
}
