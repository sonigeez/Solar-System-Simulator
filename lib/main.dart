import 'package:flutter/material.dart';
import 'dart:math';

import 'package:solar_system_emulation/planet_model.dart';
import 'package:solar_system_emulation/widgets/planet_widget.dart';
import 'package:solar_system_emulation/widgets/sun_widget.dart';

void main() => runApp(const SolarEmulatorApp());

class SolarEmulatorApp extends StatelessWidget {
  const SolarEmulatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Solar System Emulation',
      home: SolarSystem(),
    );
  }
}

class SolarSystem extends StatefulWidget {
  const SolarSystem({super.key});

  @override
  SolarSystemState createState() => SolarSystemState();
}

class SolarSystemState extends State<SolarSystem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TransformationController _transformationController =
      TransformationController();

  double _elapsedTime = 0;
  static const baseDistance = 100.0;
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
    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: 1 ~/ _speed))
      ..addListener(() {
        setState(() {
          _elapsedTime += 1 / 60 * _speed;
        });
      })
      ..repeat();
  }

  double _speed = 1; // Default speed is 1

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.1,
                maxScale: 15.0,
                child: Stack(
                  children: [
                    const SunWidget(), // You'd need to create a separate SunWidget too
                    ...planets.map((planet) {
                      final double completedOrbits =
                          _elapsedTime / planet.orbitalDuration;
                      final double angle = 2 * pi * completedOrbits;
                      return PlanetWidget(
                        planet: planet,
                        angle: angle,
                        center: Offset(MediaQuery.of(context).size.width / 2,
                            MediaQuery.of(context).size.height / 2),
                      );
                    }).toList(),
                  ],
                ),
              );
            },
          ),
        ),
        RotatedBox(
          quarterTurns: 1,
          child: Material(
            color: Colors.transparent,
            child: Slider(
              //give all colors to it
              activeColor: Colors.white,

              value: _speed,
              onChanged: (value) {
                setState(() {
                  _speed = value;
                  _controller.duration = Duration(seconds: 1 ~/ _speed);
                });
              },
              min: 0.1,
              max: 5.0,
              divisions: 49,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _transformationController.dispose();
    super.dispose();
  }
}
