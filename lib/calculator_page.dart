import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';
import 'dart:math';

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String input = "";
  String result = "";

  // Handle button click to update the input
  void handleClick(String value) {
    setState(() {
      input += value;
    });
  }

  // Clear the input and result
  void handleClear() {
    setState(() {
      input = "";
      result = "";
    });
  }

  // Remove the last character from the input
  void handleBackspace() {
    setState(() {
      input = input.isNotEmpty ? input.substring(0, input.length - 1) : "";
    });
  }

  // Evaluate the input expression and set the result
  void handleCalculate() {
    try {
      final res = calculateExpression(input);
      setState(() {
        result = res.toString();
      });
    } catch (error) {
      setState(() {
        result = "Error";
      });
    }
  }

  // Calculate the square of the input expression
  void handleSquare() {
    try {
      final res = pow(calculateExpression(input), 2);
      setState(() {
        result = res.toString();
      });
    } catch (error) {
      setState(() {
        result = "Error";
      });
    }
  }

  // Calculate the square root of the input expression
  void handleSquareRoot() {
    try {
      final res = sqrt(calculateExpression(input));
      setState(() {
        result = res.toString();
      });
    } catch (error) {
      setState(() {
        result = "Error";
      });
    }
  }

  // Helper function to evaluate the mathematical expression
  double calculateExpression(String expression) {
    expression = expression.replaceAll('x', '*').replaceAll('÷', '/');
    final evaluator = ExpressionEvaluator();
    final exp = Expression.parse(expression);
    final num result = evaluator.eval(exp, {});
    return result.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        backgroundColor: Colors.grey[300],
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            alignment: Alignment.centerRight,
            child: Text(
              input,
              style: TextStyle(fontSize: 24, color: Colors.black54),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerRight,
            child: Text(
              result,
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800]),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: <Widget>[
                    button("C", handleClear, Colors.red[600]!),
                    button("x²", handleSquare, Colors.blue[600]!),
                    button("√", handleSquareRoot, Colors.blue[600]!),
                    button("÷", () => handleClick("/"), Colors.blue[600]!),
                  ],
                ),
                Row(
                  children: <Widget>[
                    button("7", () => handleClick("7"), Colors.grey[800]!),
                    button("8", () => handleClick("8"), Colors.grey[800]!),
                    button("9", () => handleClick("9"), Colors.grey[800]!),
                    button("x", () => handleClick("*"), Colors.blue[600]!),
                  ],
                ),
                Row(
                  children: <Widget>[
                    button("4", () => handleClick("4"), Colors.grey[800]!),
                    button("5", () => handleClick("5"), Colors.grey[800]!),
                    button("6", () => handleClick("6"), Colors.grey[800]!),
                    button("-", () => handleClick("-"), Colors.blue[600]!),
                  ],
                ),
                Row(
                  children: <Widget>[
                    button("1", () => handleClick("1"), Colors.grey[800]!),
                    button("2", () => handleClick("2"), Colors.grey[800]!),
                    button("3", () => handleClick("3"), Colors.grey[800]!),
                    button("+", () => handleClick("+"), Colors.blue[600]!),
                  ],
                ),
                Row(
                  children: <Widget>[
                    button(".", () => handleClick("."), Colors.grey[800]!),
                    button("0", () => handleClick("0"), Colors.grey[800]!),
                    button("⌫", handleBackspace, Colors.orange),
                    button("=", handleCalculate, Colors.green),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget button(String text, Function onPress, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: EdgeInsets.all(30.0),
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: 28.0, color: Colors.white),
          ),
          onPressed: () => onPress(),
        ),
      ),
    );
  }
}
