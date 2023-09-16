import 'dart:math';

import 'package:flutter/material.dart';
import 'package:solar_system_emulation/planet_model.dart';

class PlanetOrbitWidget extends StatelessWidget {
  final Planet planet;
  final double angle;
  final Offset center;
  final bool isHighlighted;

  const PlanetOrbitWidget({
    required this.planet,
    required this.angle,
    required this.center,
    this.isHighlighted = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double dx = center.dx + planet.distanceFromSun * cos(angle);
    final double dy = center.dy + planet.distanceFromSun * sin(angle);
    final largestDiameterWithRing = 2 * (planet.radius + planet.radius * 1.4);
    final offsetForCentering = largestDiameterWithRing / 2;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Orbit
        Positioned(
          left: center.dx - planet.distanceFromSun,
          top: center.dy - planet.distanceFromSun,
          child: Container(
            width: 2 * planet.distanceFromSun,
            height: 2 * planet.distanceFromSun,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(planet.distanceFromSun),
              border: Border.all(color: Colors.white10, width: 1.5),
            ),
          ),
        ),

        // Planet
        Positioned(
          left: dx - offsetForCentering,
          top: dy - offsetForCentering,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 2 * planet.radius,
                height: 2 * planet.radius,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: planet.color.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 8,
                    ),
                  ],
                ),
              ),
              isHighlighted
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        SemiCircle(radius: planet.radius + planet.radius * 0.6),
                        SemiCircle(
                            radius: planet.radius + planet.radius * 1,
                            clockwise: false),
                        SemiCircle(radius: planet.radius + planet.radius * 1.4),
                      ],
                    )
                  : SizedBox(
                      width: largestDiameterWithRing,
                      height: largestDiameterWithRing,
                    ),
              CircleAvatar(
                radius: planet.radius,
                backgroundColor: planet.color,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SemiCircle extends StatefulWidget {
  const SemiCircle({
    super.key,
    required this.radius,
    this.clockwise = true, // Default is clockwise
  });

  final double radius;
  final bool clockwise;

  @override
  SemiCircleState createState() => SemiCircleState();
}

class SemiCircleState extends State<SemiCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    // If clockwise, then Tween goes from 0 to 1. If anti-clockwise, then 1 to 0.
    final rotationTween = widget.clockwise
        ? Tween(begin: 0.0, end: 1.0)
        : Tween(begin: 1.0, end: 0.0);

    return RotationTransition(
      turns: rotationTween.animate(_controller),
      child: Container(
        width: 2 * widget.radius,
        height: 2 * widget.radius,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: CustomPaint(
          painter: HalfBorderPainter(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class HalfBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white30
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    const startAngle = -pi / 2;
    const sweepAngle = pi;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}





    // List<Widget> sprinkles = [];
    // for (int i = 1; i <= 10; i++) {
    //   double trailAngle = angle - (2 * pi * i * 0.005);
    //   double trailDx = center.dx + planet.distanceFromSun * cos(trailAngle);
    //   double trailDy = center.dy + planet.distanceFromSun * sin(trailAngle);

    //   for (int j = 0; j < 5; j++) {
    //     final offsetX = _random.nextDouble() * 8 - 4;
    //     final offsetY = _random.nextDouble() * 8 - 4;
    //     double sprinkleSize = _random.nextDouble() * 2;

    //     sprinkles.add(
    //       Positioned(
    //         left: trailDx + offsetX,
    //         top: trailDy + offsetY,
    //         child: CircleAvatar(
    //           radius: sprinkleSize,
    //           backgroundColor: planet.color.withOpacity(0.65 * (1 - i * 0.1)),
    //         ),
    //       ),
    //     );
    //   }
    // }