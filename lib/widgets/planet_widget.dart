import 'dart:math';

import 'package:flutter/material.dart';
import 'package:solar_system_emulation/planet_model.dart';

class PlanetWidget extends StatelessWidget {
  final Planet planet;
  final double angle;
  final Offset center;

  const PlanetWidget(
      {super.key,
      required this.planet,
      required this.angle,
      required this.center});

  @override
  Widget build(BuildContext context) {
    final double dx = center.dx;
    final double dy = center.dy;

    return Positioned(
      left: dx - planet.distanceFromSun - planet.radius,
      top: dy - planet.distanceFromSun - planet.radius,
      child: CustomPaint(
        painter: PlanetPainter(planet: planet, angle: angle),
        size: Size(2 * (planet.distanceFromSun + planet.radius),
            2 * (planet.distanceFromSun + planet.radius)),
      ),
    );
  }
}

class PlanetPainter extends CustomPainter {
  final Planet planet;
  final double angle;

  PlanetPainter({required this.planet, required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double dx = center.dx + planet.distanceFromSun * cos(angle);
    final double dy = center.dy + planet.distanceFromSun * sin(angle);

    final planetPaint = Paint()..color = planet.color.withOpacity(0.65);
    canvas.drawCircle(Offset(dx, dy), planet.radius, planetPaint);

    final orbitPaint = Paint()
      ..color = Colors.white10
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, planet.distanceFromSun, orbitPaint);
  }

  @override
  bool shouldRepaint(PlanetPainter oldDelegate) {
    return oldDelegate.angle != angle;
  }
}
