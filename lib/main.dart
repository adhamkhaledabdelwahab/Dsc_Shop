import 'package:dsc_shop/providers/language_provider.dart';
import 'package:dsc_shop/providers/theme_provider.dart';
import 'package:dsc_shop/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => LanguageProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    return OKToast(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DSC Shop',
        theme: ThemeData(
          primaryColor: themeProvider.myMode == ThemeMode.light
              ? Colors.indigo
              : Colors.black,
          colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: themeProvider.myMode == ThemeMode.light
                  ? Colors.indigoAccent
                  : Colors.white),
        ),
        themeMode: themeProvider.myMode,
        locale: languageProvider.myLanguage,
        home: SplashScreen(),
      ),
    );
  }
}
