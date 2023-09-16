import 'package:flutter/material.dart';
import 'package:solar_system_emulation/planet_model.dart';

class Constants {
  static const baseDistance = 100.0;
  static const distanceIncrement = 46.0;
  static final planets = [
    Planet(
      name: PlanetNames.Mercury,
      color: Colors.grey,
      distanceFromSun: baseDistance,
      radius: 5.0,
      orbitalDuration: 1,
    ),
    Planet(
      name: PlanetNames.Venus,
      color: Colors.amber,
      distanceFromSun: baseDistance + distanceIncrement * 1,
      radius: 7.0,
      orbitalDuration: 224.7 / 88,
    ),
    Planet(
      name: PlanetNames.Earth,
      color: Colors.blue,
      distanceFromSun: baseDistance + distanceIncrement * 2,
      radius: 8.0,
      orbitalDuration: 365 / 88,
    ),
    Planet(
      name: PlanetNames.Mars,
      color: Colors.red,
      distanceFromSun: baseDistance + distanceIncrement * 3,
      radius: 6.0,
      orbitalDuration: 687 / 88,
    ),
    Planet(
      name: PlanetNames.Jupiter,
      color: Colors.orange,
      distanceFromSun: baseDistance + distanceIncrement * 4,
      radius: 15.0,
      orbitalDuration: 4333 / 88,
    ),
    Planet(
      name: PlanetNames.Saturn,
      color: Colors.yellow,
      distanceFromSun: baseDistance + distanceIncrement * 5,
      radius: 12.0,
      orbitalDuration: 10757 / 88,
    ),
    Planet(
      name: PlanetNames.Uranus,
      color: Colors.lightBlue,
      distanceFromSun: baseDistance + distanceIncrement * 6,
      radius: 10.0,
      orbitalDuration: 30687 / 88,
    ),
    Planet(
      name: PlanetNames.Neptune,
      color: Colors.blueAccent,
      distanceFromSun: baseDistance + distanceIncrement * 7,
      radius: 9.0,
      orbitalDuration: 60190 / 88,
    ),
  ];
}
