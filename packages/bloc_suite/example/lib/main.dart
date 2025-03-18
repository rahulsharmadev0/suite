import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_suite/bloc_suite.dart';

void main() {
  Bloc.observer = FlutterBlocObserver();
  runApp(
      BlocProvider(create: (context) => CounterCubit(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter App Demo',
      home: Scaffold(
        body: const Center(child: CounterText()),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: context.read<CounterCubit>().increment,
              ),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: context.read<CounterCubit>().decrement,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}

class CounterText extends BlocWidget<CounterCubit, int> {
  const CounterText({super.key});

  @override
  Widget build(BuildContext context, CounterCubit bloc, int state) =>
      Text('$state');
}
