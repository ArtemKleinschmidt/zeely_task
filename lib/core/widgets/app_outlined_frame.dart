import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

final class AppOutlinedFrame extends StatelessWidget {
  const AppOutlinedFrame({
    required this.child,
    this.onTap,
    this.backgroundColor = AppColors.surface,
    this.borderColor = AppColors.border,
    this.borderWidth = 1,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    super.key,
  });

  final VoidCallback? onTap;
  final Widget child;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.fromBorderSide(
              BorderSide(color: borderColor, width: borderWidth),
            ),
            borderRadius: borderRadius,
          ),
          child: child,
        ),
      ),
    );
  }
}
