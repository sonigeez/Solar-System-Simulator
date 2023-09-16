// ignore_for_file: constant_identifier_names

import 'dart:ui';

class Planet {
  final PlanetNames name;
  final Color color;
  final double distanceFromSun;
  final double radius;
  final double orbitalDuration;

  Planet({
    required this.name,
    required this.color,
    required this.distanceFromSun,
    required this.radius,
    required this.orbitalDuration,
  });
}

enum PlanetNames {
  Mercury,
  Venus,
  Earth,
  Mars,
  Jupiter,
  Saturn,
  Uranus,
  Neptune;

  //toString
  @override
  String toString() => name;
}
