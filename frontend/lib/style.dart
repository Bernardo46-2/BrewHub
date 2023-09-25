import 'package:flutter/material.dart';

const Color primary1 = Color(0xFFB36D4B);
const Color primary2_75 = Color.fromARGB(192, 173, 130, 110);
const Color primary2 = Color(0xFFBD7D5D);
const Color primary3 = Color(0xFFC78C70);
const Color primary4_75 = Color.fromARGB(192, 208, 156, 132);
const Color primary4 = Color(0xFFD09C84);
const Color primary5 = Color(0xFFD9AC97);
const Color primary6 = Color(0xFFE1BCAB);

const Color dark1 = Color(0xFF111314); // For body
const Color dark2_75 = Color.fromARGB(192, 39, 40, 41); // For cards
const Color dark2 = Color(0xFF272829); // For cards
const Color dark3 = Color.fromARGB(255, 49, 50, 51); // For chips buttons, dropdowns
const Color dark3_50 = Color.fromARGB(128, 49, 50, 51); // For chips buttons, dropdowns
const Color dark4 = Color(0xFF565858); // For sidebars, navbar
const Color dark5 = Color(0xFF707172); // For modal, dialogs
const Color dark6 = Color(0xFF8B8C8C); // For on texts

const Color feedbackBlue = Color(0xFF5D95C8);
const Color feedbackYellow = Color(0xFFE1B15B);
const Color feedbackRed = Color(0xFFEC5C54);

const Color white85 = Color(0xC7FFFFFF);
const Color white75 = Color(0xB0FFFFFF);
const Color white50 = Color(0x80FFFFFF);

const Color white20 = Color.fromARGB(30, 255, 255, 255);
const Color white10 = Color.fromARGB(20, 255, 255, 255);

ThemeData brewHubTheme = ThemeData(
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
    labelStyle: TextStyle(color: Colors.white),
  ),
);

Opacity backgroundWelcome(BuildContext ctx) {
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

Opacity backgroundHome(BuildContext ctx) {
  return Opacity(
    opacity: 1,
    child: Image.asset(
      'assets/homeBg.jpg',
      fit: BoxFit.cover,
      alignment: const Alignment(-.5, 0),
      width: MediaQuery.of(ctx).size.width,
      height: MediaQuery.of(ctx).size.height,
    ),
  );
}
