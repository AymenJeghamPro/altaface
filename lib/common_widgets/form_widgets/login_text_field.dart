import 'package:flutter/material.dart';
import 'package:flutter_projects/_shared/constants/app_colors.dart';

class LoginTextField extends StatelessWidget {
  final String? hint;
  final bool obscureText;
  final String? errorText;
  final Color errorColor;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  LoginTextField({
    this.hint,
    this.obscureText = false,
    this.errorText,
    this.errorColor = AppColors.failureColor,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        textAlign: TextAlign.start,
        obscureText: obscureText,
        keyboardType: keyboardType,
        controller: controller,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
          fillColor: Colors.transparent,
          filled: true,
          hintText: hint,
          errorText: errorText,
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: errorColor,
              width: 1,
            ),
          ),
          errorStyle: TextStyle(fontSize: 14, color: errorColor),
        ),
      ),
    );
  }
}
