import 'package:flutter/material.dart';
import 'greeting_page.dart';
import 'calculator_page.dart';
import 'exchange_page.dart';
import 'todoList.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => GreetingPage(),
        '/calculator': (context) => CalculatorPage(),
        '/api': (context) => ExchangeRate(),
        '/todos': (context) => TodoList(),
      },
    );
  }
}
