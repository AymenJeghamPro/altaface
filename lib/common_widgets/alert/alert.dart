import 'package:flutter/material.dart';

class Alert {
  static Future showSimpleAlert({
    required BuildContext context,
    required String title,
    required String message,
    String? buttonTitle,
    VoidCallback? onPressed,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text(buttonTitle ?? "Ok"),
            onPressed: () {
              Navigator.of(context).pop();
              if (onPressed != null) onPressed();
            },
          ),
        ],
      ),
    );
  }

  Future showSimpleAlertWithButtons({
    required BuildContext context,
    required String title,
    required String message,
    required String buttonOneTitle,
    required String buttonTwoTitle,
    VoidCallback? buttonOneOnPressed,
    VoidCallback? buttonTwoOnPressed,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text(buttonOneTitle),
            onPressed: () {
              Navigator.of(context).pop();
              if (buttonOneOnPressed != null) buttonOneOnPressed();
            },
          ),
          TextButton(
            child: Text(buttonTwoTitle),
            onPressed: () {
              Navigator.of(context).pop();
              if (buttonTwoOnPressed != null) buttonTwoOnPressed();
            },
          ),
        ],
      ),
    );
  }
}
