import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stateful Widget',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CounterWidget(),
    );
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;
  int _incrementValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stateful Widget'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
                color: _counter == 0 ? Colors.red : (_counter > 50 ? Colors.green : Colors.blue),
              child: Text(
                '$_counter',
                style: TextStyle(fontSize: 50.0),
              ),
            ),
          ),
          Slider(
            min: 0,
            max: 100,
            value: _counter.toDouble(),
            onChanged: (double value) {
              setState(() {
                _counter = value.toInt();
              });
            },
            activeColor: Colors.blue,
            inactiveColor: Colors.red,
          ),
          ElevatedButton(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () {
              setState(() {
                _counter -= 1;
              });
            },
            child: Text('Decrease'),
          ),
          ElevatedButton(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () {
              setState(() {
                _counter = 0;
              });
            },
            child: Text('Reset'),
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a number to add...',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _incrementValue = int.tryParse(value) ?? 0;
              });
            },
          ),
          ElevatedButton(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () {
              setState(() {
                _counter += _incrementValue;
                if (_counter > 100) {
                  _counter = 100;
                }
              });
            },
            child: Text('Increase'),
          ),
          if (_counter == 100) Text('Maximum limit reached'),
        ],
      ),
    );
  }
}
