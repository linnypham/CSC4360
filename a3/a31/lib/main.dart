import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkTheme = false; //theme state

  @override //building widget tree
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkTheme ? _buildDarkTheme() : _buildLightTheme(),
      home: HomeScreen(onThemeToggle: _toggleTheme, isDarkTheme: isDarkTheme),
    );
  }

  // Light theme customization
  ThemeData _buildLightTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        bodyMedium: TextStyle(color: Colors.black, fontSize: 18),
      ),
    );
  }

  // Dark theme customization
  ThemeData _buildDarkTheme() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Colors.black,
      textTheme: TextTheme(
        bodyMedium: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  // Function to toggle the theme
  void _toggleTheme() {
    setState(() {
      isDarkTheme = !isDarkTheme;
    });
  }
}

class HomeScreen extends StatelessWidget {
  final bool isDarkTheme;
  final VoidCallback onThemeToggle;

  const HomeScreen({required this.isDarkTheme, required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 300,
              decoration: BoxDecoration(
                color: isDarkTheme ? Colors.grey[800] : Colors.grey[300],
                borderRadius: BorderRadius.circular(50),
              ),
              alignment: Alignment.center,
              margin: EdgeInsets.all(20),
              child: Text(
                "Mobile App Development Testing",
                style: TextStyle(color: Colors.blue),
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                      onThemeToggle: onThemeToggle,
                      isDarkTheme: isDarkTheme,
                    ),
                  ),
                );
              },
              child: Text('Go to Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  final bool isDarkTheme;
  final VoidCallback onThemeToggle;

  const SettingsScreen(
      {required this.isDarkTheme, required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SwitchListTile(
              title: Text(isDarkTheme
                  ? 'Switch to Light Theme'
                  : 'Switch to Dark Theme'),
              value: isDarkTheme,
              onChanged: (value) {
                onThemeToggle();
              },
            ),
          ],
        ),
      ),
    );
  }
}
