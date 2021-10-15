import 'package:dsc_shop/screens/login_screen.dart';
import 'package:dsc_shop/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:dsc_shop/widgets/text_field_widget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:oktoast/oktoast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset(0.0, 1.5),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticInOut,
  ));
  GlobalKey<FormState> signUpKey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool hideRePassword = true;
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController rePassword = TextEditingController();

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
                      "Sign Up",
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
                        key: signUpKey,
                        child: Column(
                          children: [
                            MyTextFormField(
                              hidePassword: null,
                              myController: name,
                              showPassword: null,
                              isPassword: false,
                              myIcon: Icons.person_pin,
                              inputType: TextInputType.name,
                              label: 'Username',
                              validator: (String? val) {
                                if (val!.trim().isEmpty) {
                                  return "Please fill username field";
                                }
                              },
                            ),
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
                            MyTextFormField(
                              hidePassword: hideRePassword,
                              myController: rePassword,
                              showPassword: (val) {
                                setState(() {
                                  hideRePassword = val;
                                });
                              },
                              isPassword: true,
                              myIcon: Icons.lock,
                              inputType: TextInputType.visiblePassword,
                              label: 'Repeat Password',
                              validator: (String? val) {
                                if (val!.trim().isEmpty) {
                                  return "Please fill repeat password field";
                                }
                                if (password.text.trim() !=
                                    rePassword.text.trim()) {
                                  return "Invalid Repeated Password";
                                }
                              },
                            ),
                            RaisedButton(
                              textColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 15),
                              child: Text(
                                "SIGNUP",
                                style: TextStyle(fontSize: 15),
                              ),
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              onPressed: () {
                                if (signUpKey.currentState!.validate()) {
                                  AuthenticationService()
                                      .signUp(
                                          name.text.trim(),
                                          email.text.trim(),
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
                                      AuthenticationService()
                                          .signOut()
                                          .then((value) => print(value));
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => LoginScreen()));
                                    }
                                  });
                                }
                              },
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => LoginScreen())),
                              child: Text(
                                "LOGIN",
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
