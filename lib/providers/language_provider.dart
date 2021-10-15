import 'package:dsc_shop/services/shared_preferences.dart';
import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  late Locale myLanguage;

  LanguageProvider() {
    myLanguage = Locale("en");
    SharedPreferencesService.getLanguageFromPreferences().then((value) {
      if (value != null) {
        myLanguage = Locale(value);
        notifyListeners();
      }
    });
  }

  void updateLanguage() {
    if (myLanguage == Locale("en")) {
      myLanguage = Locale("ar");
      SharedPreferencesService.saveLanguageToPreferences("ar")
          .then((value) => print(value));
    } else if (myLanguage == Locale("ar")) {
      myLanguage = Locale("en");
      SharedPreferencesService.saveLanguageToPreferences("en")
          .then((value) => print(value));
    }
    notifyListeners();
  }
}
