import 'dart:math';

import 'package:flutter/material.dart';
import 'package:solar_system_emulation/constants.dart';
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
  PlanetNames selectedPlanet = PlanetNames.Earth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          SizedBox(
            width: 100.0, // Adjust width to your needs
            child: ListView.builder(
              itemCount: Constants.planets.length,
              itemBuilder: (context, index) {
                final planet = Constants.planets[index];
                return ListTile(
                  enableFeedback: false,
                  title: Text(
                    planet.name.toString(),
                    style: TextStyle(
                      color: planet.name == selectedPlanet
                          ? Colors.white
                          : Colors.white30,
                    ),
                  ), // Assuming your Planet class has a property called 'name'

                  onTap: () {
                    setState(() {
                      selectedPlanet = planet.name;
                    });
                  },
                );
              },
            ),
          ),
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
                      const SunWidget(),
                      ...Constants.planets.map((planet) {
                        final double completedOrbits =
                            _elapsedTime / planet.orbitalDuration;
                        double angle = 2 * pi * completedOrbits;

                        // Make Venus rotate in the opposite direction
                        if (planet.name == PlanetNames.Venus) {
                          angle = -angle;
                        }

                        return PlanetOrbitWidget(
                          planet: planet,
                          angle: angle,
                          isHighlighted: planet.name == selectedPlanet,
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _transformationController.dispose();
    super.dispose();
  }
}
