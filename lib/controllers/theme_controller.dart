import 'package:first_project/extensions/enum_extensions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ThemeController extends ChangeNotifier {

    // %%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%
    late ThemeMode _themeMode;
    ThemeMode get themeMode => _themeMode;
    late final SharedPreferences _pref;
    final String themePrefKey = "themeMode";
    // %%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% INIT THEME MODE %%%%%%%%%%%%%%%%%%%
    Future<void> init () async {
        _pref = await SharedPreferences.getInstance();
        final themeModeStr = _pref.getString(themePrefKey) ?? ThemeMode.dark.name;
        _themeMode = enumFromName(ThemeMode.values, themeModeStr) ?? ThemeMode.dark;
    }
    // %%%%%%%%%%%%%%%%%%%% END - INIT THEME MODE %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%% CHANGE THEME %%%%%%%%%%%%%%%%%%%%
    Future<void> toggleTheme () async {
        _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
        await _pref.setString(themePrefKey, _themeMode.name);
        notifyListeners();
    }
    // %%%%%%%%%%%%%%%%% END - CHANGE THEME %%%%%%%%%%%%%%%%%%%%
}