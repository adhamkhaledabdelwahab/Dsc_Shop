import 'package:dsc_shop/providers/theme_provider.dart';
import 'package:dsc_shop/services/authentication_service.dart';
import 'package:dsc_shop/widgets/text_field_widget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDark = themeProvider.myMode == ThemeMode.dark;
    final myController = TextEditingController();
    GlobalKey<FormState> myKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.indigo,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(30)),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: myKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Reset Password",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                MyTextFormField(
                  hidePassword: null,
                  showPassword: null,
                  myIcon: Icons.email,
                  isPassword: false,
                  validator: (String? val) {
                    if (val!.isEmpty) return "Please fill email address field";
                    if (!EmailValidator.validate(val.trim()))
                      return "Invalid email format";
                  },
                  inputType: TextInputType.emailAddress,
                  myController: myController,
                  label: 'Email',
                ),
                RaisedButton(
                  onPressed: () {
                    if (myKey.currentState!.validate()) {
                      AuthenticationService()
                          .resetPassword(myController.text.trim())
                          .then((value) {
                        showToastWidget(
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                margin: EdgeInsets.symmetric(horizontal: 30),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(value)),
                            context: context,
                            position: ToastPosition.bottom);
                        if (value.contains("Successfully")) {
                          Navigator.pop(context);
                        }
                      });
                    }
                  },
                  color: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    "Reset Password",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
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
    );
  }
}
