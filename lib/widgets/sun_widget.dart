import 'package:flutter/material.dart';

class SunWidget extends StatelessWidget {
  const SunWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: MediaQuery.of(context).size.width / 2 - 50.0,
      top: MediaQuery.of(context).size.height / 2 - 50.0,
      child: CustomPaint(
        painter: SunPainter(),
        size: const Size(100, 100),
      ),
    );
  }
}

class SunPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const sunRadius = 50.0;
    const Gradient sunGlow = RadialGradient(
      colors: [
        Colors.yellow,
        Colors.yellowAccent,
        Colors.orangeAccent,
        Colors.transparent,
      ],
      stops: [0, 0.6, 0.8, 1],
    );

    final Offset center = Offset(size.width / 2, size.height / 2);
    final Rect sunBounds =
        Rect.fromCircle(center: center, radius: sunRadius * 1.5);

    final Paint sunPaint = Paint()..shader = sunGlow.createShader(sunBounds);
    canvas.drawCircle(center, sunRadius * 1.5, sunPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
