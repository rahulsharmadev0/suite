import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_suite/bloc_suite.dart';

// State
class CounterState {
  final int counterValue;
  const CounterState(this.counterValue);

  @override
  String toString() => 'CounterState { counterValue: $counterValue }';
}

// Bloc
class CounterBloc extends Cubit<CounterState> {
  CounterBloc() : super(CounterState(0));

  void increment() => emit(CounterState(state.counterValue + 1));

  void decrement() => emit(CounterState(state.counterValue - 1));
}

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(context) {
    final bloc = CounterBloc();
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Counter')),
        body: Center(child: CounterText()),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              key: const Key('increment_floatingActionButton'),
              onPressed: () => bloc.increment(),
              tooltip: 'Increment',
              icon: const Icon(Icons.add),
            ),
            const SizedBox(height: 10),
            IconButton(
              key: const Key('decrement_floatingActionButton'),
              onPressed: () => bloc.decrement(),
              tooltip: 'Decrement',
              icon: const Icon(Icons.remove),
            ),
          ],
        ),
      ),
    );
  }
}

class CounterText extends BlocWidget<CounterBloc, CounterState> {
  const CounterText({super.key});

  @override
  Widget build(BuildContext context, CounterBloc bloc, CounterState state) {
    final textStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
    return Text('${state.counterValue}', style: textStyle);
  }
}
