import 'package:dsc_shop/services/shared_preferences.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeMode myMode;

  ThemeProvider() {
    myMode = ThemeMode.light;
    SharedPreferencesService.getModeFromPreferences().then((value) {
      if (value != null) {
        if (value == "dark") {
          myMode = ThemeMode.dark;
          notifyListeners();
        }
      }
    });
  }

  void updateThemeMode() {
    if (myMode == ThemeMode.light) {
      myMode = ThemeMode.dark;
      SharedPreferencesService.saveModeToPreferences("dark")
          .then((value) => print(value));
    } else if (myMode == ThemeMode.dark) {
      myMode = ThemeMode.light;
      SharedPreferencesService.saveModeToPreferences("light")
          .then((value) => print(value));
    }
    notifyListeners();
  }
}
