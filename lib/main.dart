// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solar System Emulation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const SolarSystem(),
    );
  }
}

class Planet {
  final String name;
  final Color color;
  final double distanceFromSun;
  final double radius;
  final double
      orbitalDuration; // in seconds based on Earth's time period as 1 second

  Planet({
    required this.name,
    required this.color,
    required this.distanceFromSun,
    required this.radius,
    required this.orbitalDuration,
  });
}

class SolarSystemPainter extends CustomPainter {
  final List<Planet> planets;
  final Animation<double> animation;
  final double elapsedTime; // Add this

  SolarSystemPainter({
    required this.planets,
    required this.animation,
    this.elapsedTime = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const sunRadius = 50.0;
    final sunPaint = Paint()..color = Colors.yellow;

    final Offset center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, sunRadius, sunPaint);

    for (var planet in planets) {
      final double completedOrbits = elapsedTime / planet.orbitalDuration;
      final double angle = 2 * pi * completedOrbits;
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SolarSystem extends StatefulWidget {
  const SolarSystem({super.key});

  @override
  _SolarSystemState createState() => _SolarSystemState();
}

class _SolarSystemState extends State<SolarSystem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TransformationController _transformationController =
      TransformationController();

  double _elapsedTime = 0;
  static const baseDistance = 80.0;
  static const distanceIncrement = 50.0;

  final planets = [
    Planet(
      name: 'Mercury',
      color: Colors.grey,
      distanceFromSun: baseDistance,
      radius: 5.0,
      orbitalDuration: 1,
    ),
    Planet(
      name: 'Venus',
      color: Colors.amber,
      distanceFromSun: baseDistance + distanceIncrement * 1,
      radius: 7.0,
      orbitalDuration: 224.7 / 88,
    ),
    Planet(
      name: 'Earth',
      color: Colors.blue,
      distanceFromSun: baseDistance + distanceIncrement * 2,
      radius: 8.0,
      orbitalDuration: 365 / 88,
    ),
    Planet(
      name: 'Mars',
      color: Colors.red,
      distanceFromSun: baseDistance + distanceIncrement * 3,
      radius: 6.0,
      orbitalDuration: 687 / 88,
    ),
    Planet(
      name: 'Jupiter',
      color: Colors.orange,
      distanceFromSun: baseDistance + distanceIncrement * 4,
      radius: 15.0,
      orbitalDuration: 4333 / 88,
    ),
    Planet(
      name: 'Saturn',
      color: Colors.yellow,
      distanceFromSun: baseDistance + distanceIncrement * 5,
      radius: 12.0,
      orbitalDuration: 10757 / 88,
    ),
    Planet(
      name: 'Uranus',
      color: Colors.lightBlue,
      distanceFromSun: baseDistance + distanceIncrement * 6,
      radius: 10.0,
      orbitalDuration: 30687 / 88,
    ),
    Planet(
      name: 'Neptune',
      color: Colors.blueAccent,
      distanceFromSun: baseDistance + distanceIncrement * 7,
      radius: 9.0,
      orbitalDuration: 60190 / 88,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..addListener(() {
            setState(() {
              _elapsedTime += 1 / 60;
            });
          })
          ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return InteractiveViewer(
          transformationController: _transformationController,
          minScale: 0.5, // Minimum zoom scale
          maxScale: 5.0, // Maximum zoom scale
          child: CustomPaint(
            painter: SolarSystemPainter(
              planets: planets,
              animation: _controller,
              elapsedTime: _elapsedTime,
            ),
            size: Size.infinite,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _transformationController
        .dispose(); // Dispose the transformation controller
    super.dispose();
  }
}
