import 'package:flutter/material.dart';

const colorList = <Color>[
  Color(0xFF1565C0), // Azul primario Unitecnar
  Colors.blueGrey,
  Colors.indigo,
  Colors.blue,
];

class AppTheme {
  final int selectedColor;

  AppTheme({this.selectedColor = 0})
      : assert(selectedColor >= 0, 'El color debe ser mayor o igual a cero'),
        assert(
          selectedColor < colorList.length,
          'El color debe ser menor a ${colorList.length}',
        );

  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: colorList[selectedColor],
        brightness: Brightness.light,
      );
}
