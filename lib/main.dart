import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      home: const Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _display = '0';
  String _expression = '';
  double _firstOperand = 0;
  String? _operation;
  bool _newNumber = true;

  void _onNumberPressed(String number) {
    setState(() {
      if (_newNumber) {
        _display = number;
        _newNumber = false;
      } else {
        if (_display == '0' && number != '.') {
          _display = number;
        } else {
          _display += number;
        }
      }
    });
  }

  void _onOperationPressed(String operation) {
    setState(() {
      if (!_newNumber) {
        _calculateResult();
      }
      _firstOperand = double.parse(_display);
      _operation = operation;
      _expression = '$_firstOperand $_operation';
      _newNumber = true;
    });
  }

  void _calculateResult() {
    if (_operation == null || _newNumber) return;

    final secondOperand = double.parse(_display);
    double result;

    switch (_operation) {
      case '+':
        result = _firstOperand + secondOperand;
        break;
      case '-':
        result = _firstOperand - secondOperand;
        break;
      case '×':
        result = _firstOperand * secondOperand;
        break;
      case '÷':
        result = secondOperand != 0 ? _firstOperand / secondOperand : double.infinity;
        break;
      case '%':
        result = _firstOperand % secondOperand;
        break;
      default:
        return;
    }

    setState(() {
      _expression = '$_firstOperand $_operation $secondOperand =';
      _display = result == result.toInt().toDouble()
          ? result.toInt().toString()
          : result.toString();
      _operation = null;
      _newNumber = true;
    });
  }

  void _clear() {
    setState(() {
      _display = '0';
      _expression = '';
      _firstOperand = 0;
      _operation = null;
      _newNumber = true;
    });
  }

  Widget _buildButton(String text, {Color? color, VoidCallback? onPressed}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[300],
            foregroundColor: color != null ? Colors.white : Colors.black,
            padding: const EdgeInsets.all(24.0),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(fontSize: 24.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _expression,
                  style: const TextStyle(
                    fontSize: 24.0,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  _display,
                  style: const TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _buildButton('C', color: Colors.red, onPressed: _clear),
                      _buildButton('( )', color: Colors.orange, onPressed: ()=> _onOperationPressed('()')),
                      _buildButton('%', color: Colors.orange, onPressed: () => _onOperationPressed('%')),
                      _buildButton('÷', color: Colors.orange, onPressed: () => _onOperationPressed('÷')),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      _buildButton('7', onPressed: () => _onNumberPressed('7')),
                      _buildButton('8', onPressed: () => _onNumberPressed('8')),
                      _buildButton('9', onPressed: () => _onNumberPressed('9')),
                      _buildButton('×', color: Colors.orange, onPressed: () => _onOperationPressed('×')),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      _buildButton('4', onPressed: () => _onNumberPressed('4')),
                      _buildButton('5', onPressed: () => _onNumberPressed('5')),
                      _buildButton('6', onPressed: () => _onNumberPressed('6')),
                      _buildButton('-', color: Colors.orange, onPressed: () => _onOperationPressed('-')),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      _buildButton('1', onPressed: () => _onNumberPressed('1')),
                      _buildButton('2', onPressed: () => _onNumberPressed('2')),
                      _buildButton('3', onPressed: () => _onNumberPressed('3')),
                      _buildButton('+', color: Colors.orange, onPressed: () => _onOperationPressed('+')),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      _buildButton('0', onPressed: () => _onNumberPressed('0')),
                      _buildButton('.', onPressed: () => _onNumberPressed('.')),
                      _buildButton('=', color: Colors.green, onPressed: _calculateResult),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
