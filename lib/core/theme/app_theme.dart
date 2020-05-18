import 'package:flutter/material.dart';

class AppTheme {
  /// Default constructor
  AppTheme({@required this.isDark});
  Color textColor = Color.fromARGB(255, 47, 64, 71);
  Color bg1 = Color.fromARGB(255, 226, 226, 226);
  Color surface = Color.fromARGB(255, 238, 238, 238);
  Color primaryVariant = Color.fromARGB(255, 147, 220, 223);
  Color secondary = Color.fromARGB(255, 240, 84, 91);
  Color accent1 = Colors.grey[900];
  bool isDark;

  ThemeData get themeData {
    /// Create a TextTheme and ColorScheme, that we can use to generate ThemeData
    final TextTheme txtTheme = (isDark
            ? Typography.material2018().white
            : Typography.material2018().black)
        .apply(
          fontFamily: 'OpenSans',
          bodyColor: textColor,
          displayColor: textColor,
        )
        .copyWith(
          button: TextStyle(
            color: surface,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        );

    final ColorScheme colorScheme = ColorScheme(
      // Decide how you want to apply your own custom them, to the MaterialApp
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: textColor,
      primaryVariant: primaryVariant,
      secondary: secondary,
      secondaryVariant: accent1,
      background: bg1,
      surface: surface,
      error: secondary,
      onBackground: textColor,
      onSurface: textColor,
      onError: surface,
      onPrimary: textColor,
      onSecondary: surface,
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
