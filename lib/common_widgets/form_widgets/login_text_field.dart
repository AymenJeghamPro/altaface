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
      decoration: BoxDecoration(color: Colors.transparent),
      child: TextFormField(
        textAlign: TextAlign.center,
        obscureText: obscureText,
        keyboardType: keyboardType,
        controller: controller,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: hint,
          errorText: errorText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(100.0)),
            borderSide: BorderSide(
              color: AppColors.defaultColor,
              width: 1,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(100.0)),
            borderSide: BorderSide(
              color: errorColor,
              width: 1,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(100.0)),
            borderSide: BorderSide(
              color: AppColors.defaultColor,
              width: 1,
            ),
          ),
          errorStyle: TextStyle(fontSize: 14, color: errorColor),
        ),
      ),
    );
  }
}
