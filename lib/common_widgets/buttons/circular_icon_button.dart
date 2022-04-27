import 'package:flutter/material.dart';
import 'package:altaface/_shared/constants/app_colors.dart';
import 'package:flutter_svg/svg.dart';

class CircularIconButton extends StatelessWidget {
  final String iconName;
  final double iconSize;
  final Color? iconColor;
  final double buttonSize;
  final Color? color;
  final VoidCallback? onPressed;

  const CircularIconButton({
    Key? key,
    required this.iconName,
    this.iconSize = 20,
    this.iconColor = Colors.white,
    this.buttonSize = 44,
    this.color,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: (color ?? AppColors.defaultColor),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0)),
        ),
        child: SvgPicture.asset(
          iconName,
          width: iconSize,
          height: iconSize,
          color: iconColor,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
