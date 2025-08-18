import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class NatureBackgroundWidget extends StatefulWidget {
  const NatureBackgroundWidget({Key? key}) : super(key: key);

  @override
  State<NatureBackgroundWidget> createState() => _NatureBackgroundWidgetState();
}

class _NatureBackgroundWidgetState extends State<NatureBackgroundWidget>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();

    _particleController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: Curves.linear,
    ));

    _particleController.repeat();
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF4CAF50), // Fresh green
            AppTheme.lightTheme.colorScheme.primary,
            const Color(0xFF2E7D32), // Deep forest green
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Organic shapes overlay
          Positioned(
            top: -10.h,
            right: -15.w,
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -15.h,
            left: -20.w,
            child: Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          // Floating particles
          AnimatedBuilder(
            animation: _particleAnimation,
            builder: (context, child) {
              return Stack(
                children: List.generate(8, (index) {
                  final double offsetY =
                      (_particleAnimation.value * 100.h) % 120.h;
                  final double startX = (index * 12.w) % 100.w;
                  final double opacity = (1.0 - (offsetY / 120.h)) * 0.6;

                  return Positioned(
                    left: startX,
                    top: offsetY - 20.h,
                    child: Opacity(
                      opacity: opacity.clamp(0.0, 0.6),
                      child: Container(
                        width: 1.w,
                        height: 1.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.5),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          // Subtle pattern overlay
          Positioned.fill(
            child: CustomPaint(
              painter: NaturePatternPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class NaturePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw organic leaf-like patterns
    for (int i = 0; i < 5; i++) {
      final path = Path();
      final startX = (i * size.width / 5) + (size.width / 10);
      final startY = size.height * 0.2 + (i * size.height / 8);

      path.moveTo(startX, startY);
      path.quadraticBezierTo(
        startX + 30,
        startY - 20,
        startX + 60,
        startY,
      );
      path.quadraticBezierTo(
        startX + 30,
        startY + 20,
        startX,
        startY,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
