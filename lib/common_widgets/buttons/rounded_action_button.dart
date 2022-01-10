import 'package:flutter/material.dart';
import 'package:flutter_projects/_shared/constants/app_colors.dart';

class RoundedRectangleActionButton extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? icon;
  final Color? color;
  final Color? borderColor;
  final VoidCallback onPressed;
  final bool disabled;
  final bool showLoader;

  const RoundedRectangleActionButton({
    this.title,
    this.subtitle,
    this.icon,
    this.color,
    this.borderColor,
    required this.onPressed,
    this.disabled = false,
    this.showLoader = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (subtitle != null) ? 50 : 40,
      child: MaterialButton(
        minWidth: 50,
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor ?? Colors.transparent),
          borderRadius: BorderRadius.circular(25.0),
        ),
        padding: const EdgeInsets.only(left: 8, right: 8),
        onPressed: (disabled || showLoader) ? null : onPressed,
        color: color ?? AppColors.defaultColor,
        disabledColor:
            showLoader ? color : AppColors.defaultColor.withOpacity(0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: showLoader ? _buildLoader() : _buildIconAndTitle(),
        ),
      ),
    );
  }

  List<Widget> _buildIconAndTitle() {
    return [
      if (icon != null) icon!,
      if (icon != null && title != null && title!.isNotEmpty)
        const SizedBox(width: 8),
      if (title != null && title!.isNotEmpty)
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title!,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 16,
                  color: disabled ? Colors.white60 : Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (subtitle != null) const SizedBox(height: 6),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(130, 130, 130, 1.0),
                  ),
                ),
            ],
          ),
        ),
    ];
  }

  List<Widget> _buildLoader() {
    return [
      SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          backgroundColor: Colors.transparent,
          valueColor:
              AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.7)),
        ),
      )
    ];
  }
}
