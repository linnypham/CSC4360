import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _input = "";
  int num1 = 0;
  int num2 = 0;
  String operand = "";

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "Clear") {
        _output = "0";
        _input = "";
        num1 = 0;
        num2 = 0;
        operand = "";
      } else if (buttonText == "+" ||
                buttonText == "-" ||
                buttonText == "*" ||
                buttonText == "/") {
        num1 = int.parse(_output);
        operand = buttonText;
        _input = "";
      } else if (buttonText == "=") {
        num2 = int.parse(_input);
        if (operand == "+") {
          _output = (num1 + num2).toString();
        } else if (operand == "-") {
          _output = (num1 - num2).toString();
        } else if (operand == "*") {
          _output = (num1 * num2).toString();
        } else if (operand == "/") {
          _output = num2 != 0 ? (num1 / num2).toString() : "Div/0";
        }
        _input = "";
        operand = "";
      } else {
        _input += buttonText;
        _output = _input;
      }
    });
  }

  Widget buildButton(String buttonText) {
    return Expanded(
      child: InkWell(
        onTap: () => buttonPressed(buttonText),
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButtonOperand(String buttonText) {
    return Expanded(
      child: InkWell(
        onTap: () => buttonPressed(buttonText),
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButtonSpecial(String buttonText) {
    return Expanded(
      child: InkWell(
        onTap: () => buttonPressed(buttonText),
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.orange,
          ),
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculator")),
      body: Column(
        children: <Widget>[
          Spacer(),
          Container(
            alignment: Alignment.bottomRight,
            child: Text(
              _output,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          
          Column(
            children: [
              Row(
                children: [buildButton("7"), buildButton("8"), buildButton("9"), buildButtonOperand("/")],
              ),
              Row(
                children: [buildButton("4"), buildButton("5"), buildButton("6"), buildButtonOperand("*")],
              ),
              Row(
                children: [buildButton("1"), buildButton("2"), buildButton("3"), buildButtonOperand("-")],
              ),
              Row(
                children: [buildButtonSpecial("Clear"), buildButton("0"), buildButtonSpecial("="), buildButtonOperand("+")],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
