import 'package:flutter/material.dart';

class AppTheme {
  /// Default constructor
  AppTheme({@required this.isDark});

  Color bg1 = Colors.white;
  Color accent1 = Colors.grey[900];
  bool isDark;

  ThemeData get themeData {
    /// Create a TextTheme and ColorScheme, that we can use to generate ThemeData
    final TextTheme txtTheme = (isDark
            ? Typography.material2018().white
            : Typography.material2018().black)
        .apply(fontFamily: 'Quicksand');

    final Color txtColor = txtTheme.bodyText1.color;
    final ColorScheme colorScheme = ColorScheme(
      // Decide how you want to apply your own custom them, to the MaterialApp
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: accent1,
      primaryVariant: accent1,
      secondary: accent1,
      secondaryVariant: accent1,
      background: bg1,
      surface: bg1,
      error: Colors.red.shade400,
      onBackground: txtColor,
      onSurface: txtColor,
      onError: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    );

    /// Now that we have ColorScheme and TextTheme, we can create the ThemeData
    final t = ThemeData.from(
      textTheme: txtTheme,
      colorScheme: colorScheme,
    )
        // We can also add on some extra properties that ColorScheme seems to miss
        .copyWith(
            buttonColor: accent1,
            cursorColor: accent1,
            highlightColor: accent1,
            toggleableActiveColor: accent1);

    /// Return the themeData which MaterialApp can now use
    return t;
  }
}
