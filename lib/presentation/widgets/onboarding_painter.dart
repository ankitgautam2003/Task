import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class OnboardingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw rounded purple square
    paint.color = AppColors.primary;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.1, size.width * 0.8, size.height * 0.8),
      const Radius.circular(24),
    );
    canvas.drawRRect(rect, paint);

    // Draw checkmark
    paint.color = Colors.white;
    paint.strokeWidth = 6;
    paint.strokeCap = StrokeCap.round;
    paint.style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * 0.3, size.height * 0.5);
    path.lineTo(size.width * 0.45, size.height * 0.65);
    path.lineTo(size.width * 0.7, size.height * 0.35);
    
    canvas.drawPath(path, paint);

    // Draw decorative dots
    paint.style = PaintingStyle.fill;
    
    // Orange dot
    paint.color = const Color(0xFFFF9800);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.2), 6, paint);
    
    // Blue dot
    paint.color = const Color(0xFF2196F3);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.8), 6, paint);
    
    paint.color = const Color(0xFF2196F3);
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.9), 5, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

