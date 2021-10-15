import 'package:dsc_shop/providers/item_provider.dart';
import 'package:dsc_shop/providers/user_item_provider.dart';
import 'package:dsc_shop/providers/user_provider.dart';
import 'package:dsc_shop/screens/home_screen.dart';
import 'package:dsc_shop/screens/signup_screen.dart';
import 'package:dsc_shop/services/authentication_service.dart';
import 'package:dsc_shop/widgets/text_field_widget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset(0.0, -1.5),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticInOut,
  ));
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  bool hidePassword = true;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  void initState() {
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SlideTransition(
        position: _offsetAnimation,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            margin: EdgeInsets.only(top: height * 0.01),
            child: ListView(
              children: [
                Container(
                  height: height * 0.2,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/shopping_cart.png"))),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 35,
                          fontFamily: 'serif',
                          color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.065),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    elevation: 20,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.only(top: height * 0.02),
                      child: Form(
                        key: loginKey,
                        child: Column(
                          children: [
                            MyTextFormField(
                              hidePassword: null,
                              myController: email,
                              showPassword: null,
                              isPassword: false,
                              myIcon: Icons.alternate_email,
                              inputType: TextInputType.emailAddress,
                              label: 'Email',
                              validator: (String? val) {
                                if (val!.trim().isEmpty) {
                                  return "Please fill email address field";
                                }
                                if (!EmailValidator.validate(val.trim())) {
                                  return 'Invalid Email Address';
                                }
                              },
                            ),
                            MyTextFormField(
                              hidePassword: hidePassword,
                              myController: password,
                              showPassword: (val) {
                                setState(() {
                                  hidePassword = val;
                                });
                              },
                              isPassword: true,
                              myIcon: Icons.lock,
                              inputType: TextInputType.visiblePassword,
                              label: 'Password',
                              validator: (String? val) {
                                if (val!.trim().isEmpty) {
                                  return "Please fill password field";
                                }
                              },
                            ),
                            TextButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ForgotPasswordScreen())),
                              child: Text(
                                "Forgot Password",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    fontFamily: 'sans-serif-condensed',
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5),
                              ),
                            ),
                            RaisedButton(
                              textColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 15),
                              child: Text(
                                "LOGIN",
                                style: TextStyle(fontSize: 15),
                              ),
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              onPressed: () {
                                if (loginKey.currentState!.validate()) {
                                  AuthenticationService()
                                      .login(email.text.trim(),
                                          password.text.trim())
                                      .then((value) {
                                    showToastWidget(
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 30, vertical: 10),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 30),
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Text(value!)),
                                        context: context,
                                        position: ToastPosition.bottom);
                                    if (value.contains("Successfully")) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => MultiProvider(
                                                    providers: [
                                                      ChangeNotifierProvider(
                                                          create: (context) =>
                                                              ItemProvider()),
                                                      ChangeNotifierProvider(
                                                          create: (context) =>
                                                              UserProvider(
                                                                  FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid)),
                                                      ChangeNotifierProvider(
                                                          create: (context) =>
                                                              UserItemsProvider(
                                                                  FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid))
                                                    ],
                                                    child: HomeScreen(),
                                                  )));
                                    }
                                  });
                                }
                              },
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SignUpScreen())),
                              child: Text(
                                "SIGNUP",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.lightBlueAccent,
                                    fontFamily: 'sans-serif-condensed',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ), //FlutterLogo(size: 150.0),
        ),
      ),
    );
  }
}
