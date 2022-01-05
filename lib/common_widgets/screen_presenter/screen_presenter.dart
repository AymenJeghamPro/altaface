import 'package:flutter/material.dart';

enum SlideDirection {
  fromLeft,
  fromRight,
  fromTop,
  fromBottom,
}

class ScreenPresenter {
  static Future<dynamic> present(
    Widget screen,
    BuildContext context, {
    SlideDirection slideDirection = SlideDirection.fromRight,
  }) {
    return Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          var begin = _getBeginOffset(slideDirection);
          var end = Offset.zero;
          var curve = Curves.easeOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 200),
      ),
    );
  }

  static Offset _getBeginOffset(SlideDirection slideDirection) {
    if (slideDirection == SlideDirection.fromLeft) {
      return Offset(-1.0, 0.0);
    } else if (slideDirection == SlideDirection.fromRight) {
      return Offset(1.0, 0.0);
    } else if (slideDirection == SlideDirection.fromTop) {
      return Offset(0.0, -1.0);
    } else if (slideDirection == SlideDirection.fromBottom) {
      return Offset(0.0, 1.0);
    } else {
      return Offset.zero;
    }
  }
}
