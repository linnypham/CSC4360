import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}


class Counter with ChangeNotifier {
  int age = 0;

  void setAge(double newAge) {
    age = newAge.toInt();
    notifyListeners();
  }

  void increment() {
    if (age < 99) {
      age += 1;
      notifyListeners();
    }
  }

  void decrement() {
    if (age > 0) {
      age -= 1;
      notifyListeners();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Milestones',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  Color getBackgroundColor(int age) {
    if (age <= 12) return Colors.lightBlue;
    if (age <= 19) return Colors.lightGreen;
    if (age <= 30) return Colors.yellow;
    if (age <= 50) return Colors.orange;
    return Colors.grey;
  }

  String getMessage(int age) {
    if (age <= 12) return "You're a child!";
    if (age <= 19) return "Teenager time!";
    if (age <= 30) return "You're a young adult!";
    if (age <= 50) return "You're an adult now!";
    return "Golden years!";
  }

  Color getProgressBarColor(int age) {
    if (age <= 33) return Colors.green;
    if (age <= 67) return Colors.yellow;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Counter>(
      builder: (context, counter, child) {
        return Scaffold(
          backgroundColor: getBackgroundColor(counter.age),
          appBar: AppBar(title: const Text('Age Milestones')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'I am ${counter.age} years old',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(getMessage(counter.age),),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.read<Counter>().decrement();
                      },
                      child: const Text('Decrease'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<Counter>().increment();
                      },
                      child: const Text('Increase'),
                    ),
                  ],
                ),
                Slider(
                  value: counter.age.toDouble(),
                  min: 0,
                  max: 99,
                  onChanged: (value) => counter.setAge(value),
                ),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  value: counter.age / 99,
                  valueColor: AlwaysStoppedAnimation(getProgressBarColor(counter.age)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
