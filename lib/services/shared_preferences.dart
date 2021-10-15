import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService{
  static const String Data_Key_LANG = 'Language';
  static const String Data_Key_MODE = 'Mode';

  static Future<bool> saveLanguageToPreferences(String value) async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(Data_Key_LANG, value);
  }

  static Future<bool> saveModeToPreferences(String value) async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(Data_Key_MODE, value);
  }

  static Future<String?> getLanguageFromPreferences() async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(Data_Key_LANG);
  }

  static Future<String?> getModeFromPreferences() async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(Data_Key_MODE);
  }
}