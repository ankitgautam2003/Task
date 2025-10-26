import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String? icon;
  final IconData? iconData;
  final Color color;
  final VoidCallback onTap;

  const SocialButton({
    super.key,
    this.icon,
    this.iconData,
    required this.color,
    required this.onTap,
  }) : assert(
         icon != null || iconData != null,
         'Either icon or iconData must be provided',
       );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: iconData != null
            ? Icon(iconData, color: Colors.white, size: 24)
            : Center(
                child: Text(
                  icon!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }
}
