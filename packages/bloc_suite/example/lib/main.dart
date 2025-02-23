import 'package:example/counter_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_suite/bloc_suite.dart';

void main() {
  Bloc.observer = FlutterBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MainAppScreens(),
    );
  }
}

class MainAppScreens extends StatelessWidget {
  const MainAppScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text('Counter App'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CounterScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
