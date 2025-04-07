import 'package:flutter/material.dart';
import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(AquariumApp());
}

class AquariumApp extends StatelessWidget {
  const AquariumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AquariumScreen(),
    );
  }
}

class Fish {
  Color color;
  double speed;
  Offset position;
  Offset direction;
  Fish({required this.color, required this.speed, required this.position})
      : direction = Offset(Random().nextDouble() * 2 - 1, Random().nextDouble() * 2 - 1);

  void move() {
    position = Offset(position.dx + direction.dx * speed, position.dy + direction.dy * speed);
  }
}

class AquariumScreen extends StatefulWidget {
  const AquariumScreen({super.key});

  @override
  _AquariumScreenState createState() => _AquariumScreenState();
}

class _AquariumScreenState extends State<AquariumScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Fish> fishList = [];
  Color selectedColor = Colors.red;
  double selectedSpeed = 2.0;
  final List<double> speedOptions = [1.0, 2.0, 3.0, 4.0, 5.0];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    )..addListener(() {
        setState(() {
          for (var fish in fishList) {
            fish.move();
            if (fish.position.dx < 0 || fish.position.dx > 280) {
              fish.direction = Offset(-fish.direction.dx, fish.direction.dy);
            }
            if (fish.position.dy < 0 || fish.position.dy > 280) {
              fish.direction = Offset(fish.direction.dx, -fish.direction.dy);
            }
          }
        });
      })..repeat();
    loadSettings();
  }

  void _addFish() {
    if (fishList.length < 10) {
      setState(() {
        fishList.add(Fish(
          color: selectedColor,
          speed: selectedSpeed,
          position: Offset(Random().nextDouble() * 250, Random().nextDouble() * 250),
        ));
      });
      saveSettings();
    }
  }

  Future<void> saveSettings() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'aquarium.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE settings(id INTEGER PRIMARY KEY, fish_count INTEGER, speed REAL, color INTEGER)",
        );
      },
      version: 1,
    );
    final db = await database;
    await db.insert(
      'settings',
      {'id': 1, 'fish_count': fishList.length, 'speed': selectedSpeed, 'color': selectedColor.value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> loadSettings() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'aquarium.db'),
    );
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('settings');
    if (maps.isNotEmpty) {
      setState(() {
        selectedSpeed = maps[0]['speed'];
        selectedColor = Color(maps[0]['color']);
        fishList = List.generate(maps[0]['fish_count'], (index) => Fish(
              color: selectedColor,
              speed: selectedSpeed,
              position: Offset(Random().nextDouble() * 250, Random().nextDouble() * 250),
            ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Aquarium')),
      body: Column(
        children: [
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: Stack(
              children: fishList
                  .map((fish) => AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Positioned(
                            left: fish.position.dx,
                            top: fish.position.dy,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: fish.color,
                                shape: BoxShape.rectangle,
                              ),
                            ),
                          );
                        },
                      ))
                  .toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<double>(
              value: selectedSpeed,
              items: speedOptions
                  .map((speed) => DropdownMenuItem(
                        value: speed,
                        child: Text('$speed'),
                      ))
                  .toList(),
              onChanged: (speed) {
                if (speed != null) {
                  setState(() {
                    selectedSpeed = speed;
                  });
                }
              },
            ),
              DropdownButton<Color>(
                value: selectedColor,
                items: [Colors.red, Colors.blue, Colors.green]
                    .map((color) => DropdownMenuItem(
                          value: color,
                          child: Container(
                            width: 20,
                            height: 20,
                            color: color,
                          ),
                        ))
                    .toList(),
                onChanged: (color) {
                  if (color != null) {
                    setState(() {
                      selectedColor = color;
                    });
                  }
                },
              ),
            ]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: _addFish, child: Text('Add Fish')),
              SizedBox(width: 10),
              ElevatedButton(onPressed: saveSettings, child: Text('Save')),
            ],
          ),
        ],
      ),
    );
  }
}
