import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField(
      {Key? key,
      required this.myController,
      required this.isPassword,
      required this.hidePassword,
      required this.showPassword,
      required this.label,
      required this.inputType,
      required this.myIcon, required this.validator})
      : super(key: key);

  final TextEditingController myController;
  final bool isPassword;
  final bool? hidePassword;
  final Function(bool newVal)? showPassword;
  final String? Function(String? val) validator;
  final String label;
  final TextInputType inputType;
  final IconData myIcon;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(left: width * 0.04, right: width * 0.04, top: 0, bottom: height * 0.015),
      child: TextFormField(
        validator: validator,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            prefixIcon: Icon(myIcon),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                        !hidePassword! ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => showPassword!(!hidePassword!),
                  )
                : null,
            labelText: label),
        style: TextStyle(
          fontSize: 15,
          fontFamily: 'sans-serif-condensed',
        ),
        obscureText: hidePassword != null ? hidePassword! : false,
        keyboardType: inputType,
        controller: myController,
      ),
    );
  }
}
