import 'package:flutter/material.dart';

class ThemeViewModel extends ChangeNotifier {

    // %%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%
    ThemeMode _themeMode = ThemeMode.dark;
    ThemeMode get themeMode => _themeMode;
    // %%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%% CHANGE THEME %%%%%%%%%%%%%%%%%%%%
    void toggleTheme () {
        _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
        notifyListeners();
    }
    // %%%%%%%%%%%%%%%%% END - CHANGE THEME %%%%%%%%%%%%%%%%%%%%
}