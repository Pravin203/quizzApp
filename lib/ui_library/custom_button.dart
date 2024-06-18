import 'package:flutter/material.dart';
import 'package:quikapp/ui_library/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ButtonVariant {
  primary,
}

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonVariant variant;

  Button({
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    TextStyle? textColor;
    double? height;
    double? fixedWidth;
    Widget? icon;
    Widget? divider;
    Color? borderColor;
    // TextStyle? textSize;
    switch (variant) {
      case ButtonVariant.primary:
        // fixedWidth =
        MediaQuery.of(context).size.width * 0.0; // Set the fixed width here
        height = 48;
        backgroundColor = AppTheme.lightBlue;
        textColor = AppTheme.h6.copyWith(color: AppTheme.white);
        icon = SvgPicture.asset(
          'assets/icons/arrow-right.svg',
          height: 20, // Adjust the height as needed
          width: 20, // Adjust the width as needed
        );
        break;
    }
    return Container(
      width: fixedWidth,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor ?? Colors.transparent),
        // Add border
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        height: height,
        // hoverColor: AppTheme.red,
        color: backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: textColor,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: 4,
            ),
            if (icon != null) ...[
              // Only include icon if it is not null
              if (divider != null) divider,
              icon!,
            ],
          ],
        ),
      ),
    );
  }
}
