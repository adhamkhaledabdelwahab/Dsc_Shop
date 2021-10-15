import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:dsc_shop/providers/item_provider.dart';
import 'package:dsc_shop/providers/theme_provider.dart';
import 'package:dsc_shop/providers/user_item_provider.dart';
import 'package:dsc_shop/providers/user_provider.dart';
import 'package:dsc_shop/screens/home_screen.dart';
import 'package:dsc_shop/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDark = themeProvider.myMode == ThemeMode.dark;
    return AnimatedSplashScreen(
      splash: Image.asset("assets/logo.png"),
      nextScreen: _auth.currentUser != null
          ? MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => ItemProvider()),
                ChangeNotifierProvider(
                    create: (context) => UserProvider(_auth.currentUser!.uid)),
                ChangeNotifierProvider(
                    create: (context) => UserItemsProvider(
                        FirebaseAuth.instance.currentUser!.uid))
              ],
              child: HomeScreen(),
            )
          : LoginScreen(),
      curve: Curves.easeIn,
      splashTransition: SplashTransition.slideTransition,
      backgroundColor: isDark ? Colors.black : Colors.white,
      splashIconSize: MediaQuery.of(context).size.width,
      animationDuration: Duration(milliseconds: 500),
      duration: 3000,
    );
  }
}
