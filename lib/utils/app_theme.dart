import 'package:flutter/material.dart';

import 'constant.dart';

ThemeData getAppTheme(BuildContext context, bool isDarkTheme) {
  return ThemeData(
    fontFamily: 'Calibri',
    scaffoldBackgroundColor: isDarkTheme ? black : white,
    textTheme: Theme.of(context)
        .textTheme
        .copyWith(
          headlineMedium: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 17,
                letterSpacing: 0.15,
                height: 1.5,
              ),
          titleSmall: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontSize: 12, height: 1.5, letterSpacing: 0.15),
          titleLarge: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              letterSpacing: 0.15,
              height: 1.5),
          titleMedium: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontSize: 18, letterSpacing: 0.15, height: 1.5),
        )
        .apply(
          bodyColor: isDarkTheme ? white : const Color.fromRGBO(0, 0, 0, 0.87),
          displayColor: Colors.grey,
        ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(orange),
    ),
    listTileTheme: ListTileThemeData(iconColor: orange),
    appBarTheme: AppBarTheme(
        backgroundColor: isDarkTheme ? black : white,
        iconTheme: IconThemeData(color: isDarkTheme ? white : black)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: isDarkTheme ? black : white,
      selectedItemColor: orange,
      unselectedItemColor: Colors.grey,
    ),
    tabBarTheme: TabBarTheme(
      labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      labelColor: isDarkTheme ? white : black,
    ),
    popupMenuTheme: PopupMenuThemeData(
      shadowColor:
          isDarkTheme ? const Color.fromARGB(255, 123, 123, 123) : black,
      color: isDarkTheme ? black : white,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: white, backgroundColor: orange),
    cardColor: isDarkTheme ? black : white,
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(orange))),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(orange),
      foregroundColor: isDarkTheme
          ? MaterialStateProperty.all<Color>(white)
          : MaterialStateProperty.all<Color>(black),
      elevation: MaterialStateProperty.all<double>(5.0),
      shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
    )),
    checkboxTheme: CheckboxThemeData(
        checkColor: isDarkTheme
            ? MaterialStateProperty.all<Color>(white)
            : MaterialStateProperty.all<Color>(black),
        fillColor: MaterialStateProperty.all<Color>(orange)),
  );
}
