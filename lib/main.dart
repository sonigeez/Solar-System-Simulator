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

      final planetPaint = Paint()..color = planet.color;
      canvas.drawCircle(Offset(dx, dy), planet.radius, planetPaint);
      final orbitPaint = Paint()
        ..color = planet.color
            .withOpacity(0.3) // Using a faded version of the planet color
        ..style = PaintingStyle.stroke // We only want the outline
        ..strokeWidth = 1.0; // Width of the orbit

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
  double _elapsedTime = 0; // in seconds

  final planets = [
    Planet(
      name: 'Mercury',
      color: Colors.grey,
      distanceFromSun: 60.0,
      radius: 5.0,
      orbitalDuration: 88 / 365.25,
    ),
    Planet(
      name: 'Venus',
      color: Colors.amber,
      distanceFromSun: 90.0,
      radius: 7.0,
      orbitalDuration: 224.7 / 365.25,
    ),
    Planet(
      name: 'Earth',
      color: Colors.blue,
      distanceFromSun: 120.0,
      radius: 8.0,
      orbitalDuration:
          1.0, // Earth's time period is our reference, so 1 second.
    ),
    Planet(
      name: 'Mars',
      color: Colors.red,
      distanceFromSun: 150.0,
      radius: 6.0,
      orbitalDuration: 687 / 365.25,
    ),
    Planet(
      name: 'Jupiter',
      color: Colors.orange,
      distanceFromSun: 180.0,
      radius: 15.0,
      orbitalDuration: 11.9,
    ),
    Planet(
      name: 'Saturn',
      color: Colors.yellow,
      distanceFromSun: 210.0,
      radius: 12.0,
      orbitalDuration: 29.5,
    ),
    Planet(
      name: 'Uranus',
      color: Colors.lightBlue,
      distanceFromSun: 240.0,
      radius: 10.0,
      orbitalDuration: 84.0,
    ),
    Planet(
      name: 'Neptune',
      color: Colors.blue,
      distanceFromSun: 270.0,
      radius: 9.0,
      orbitalDuration: 164.8,
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
        return CustomPaint(
          painter: SolarSystemPainter(
              planets: planets,
              animation: _controller,
              elapsedTime: _elapsedTime),
          size: Size.infinite,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
