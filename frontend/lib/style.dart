import 'package:flutter/material.dart';

const Color primary1 = Color(0xFFB36D4B);
const Color primary2 = Color(0xFFBD7D5D);
const Color primary3 = Color(0xFFC78C70);
const Color primary4 = Color(0xFFD09C84);
const Color primary5 = Color(0xFFD9AC97);
const Color primary6 = Color(0xFFE1BCAB);

const Color dark1 = Color(0xFF111314); // For body background color
const Color dark2 = Color(0xFF272829); // For cards background color
const Color dark3 =
    Color(0xFF3E3F40); // For chips buttons, dropdowns background color
const Color dark4 = Color(0xFF565858); // For sidebars, navbar background color
const Color dark5 = Color(0xFF707172); // For modal, dialogs background color
const Color dark6 = Color(0xFF8B8C8C); // For on background texts color

const Color feedbackBlue = Color(0xFF5D95C8);
const Color feedbackYellow = Color(0xFFE1B15B);
const Color feedbackRed = Color(0xFFEC5C54);

final ThemeData brewHubTheme = ThemeData(
  colorScheme: const ColorScheme(
    primary: primary1,
    secondary: primary2,
    tertiary: primary3,
    background: dark1,
    surface: dark2,
    onBackground: dark6,
    onSurface: dark6,
    onError: dark6,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    brightness: Brightness.light,
    error: feedbackRed,
  ),
  scaffoldBackgroundColor: dark1,
  appBarTheme: const AppBarTheme(
    backgroundColor: dark4,
  ),
  inputDecorationTheme: const InputDecorationTheme(
      fillColor: dark5,
      filled: true,
      labelStyle: TextStyle(color: Colors.white)),
);

Opacity backgroundImage(BuildContext ctx) {
  return Opacity(
    opacity: .3,
    child: Image.asset(
      'assets/background.jpg',
      fit: BoxFit.cover,
      alignment: const Alignment(-.5, 0),
      width: MediaQuery.of(ctx).size.width,
      height: MediaQuery.of(ctx).size.height,
    ),
  );
}
