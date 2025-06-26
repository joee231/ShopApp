import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData lighttheme = ThemeData(
  primarySwatch: Colors.green,
  useMaterial3: false,
  appBarTheme: AppBarTheme(
    titleSpacing: 20.0,
    iconTheme: IconThemeData(
        color: Colors.white
    ),
    systemOverlayStyle:  SystemUiOverlayStyle(
      statusBarColor:HexColor('333739'),
      statusBarIconBrightness:Brightness.light,

    ),
    backgroundColor: HexColor('333739'),
    elevation: 0.0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),

  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.green,
    unselectedItemColor: Colors.grey,
    elevation: 20.0,
    backgroundColor: HexColor('333739'),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.green,
  ),
  scaffoldBackgroundColor: HexColor('333739'),
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
  ),
  fontFamily: 'vstyle',
);
ThemeData darktheme = ThemeData(
  primarySwatch: Colors.green,
  useMaterial3: false,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    titleSpacing: 20.0,
    iconTheme: IconThemeData(
        color: Colors.black
    ),
    systemOverlayStyle:  SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness:Brightness.dark,

    ),
    backgroundColor: Colors.white,
    elevation: 0.0,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.green,
    unselectedItemColor: Colors.grey,
    elevation: 20.0,
    backgroundColor: Colors.white,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.green,
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
  ),
  fontFamily: "vstyle",
);