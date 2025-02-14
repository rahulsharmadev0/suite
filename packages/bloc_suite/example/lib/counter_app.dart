import 'package:example/bloc_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Event
abstract class CounterEvent {}

class Increment extends CounterEvent {}

class Decrement extends CounterEvent {}

// State
class CounterState {
  final int counterValue;
  CounterState(this.counterValue);
}

// Bloc
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(0)) {
    on<Increment>(_incrementCounter);
    on<Decrement>(_decrementCounter);
  }

  _incrementCounter(CounterEvent event, Emitter<CounterState> emit) {
    emit(CounterState(state.counterValue + 1));
  }

  _decrementCounter(CounterEvent event, Emitter<CounterState> emit) {
    emit(CounterState(state.counterValue - 1));
  }

  @override
  Future<void> close() {
    print('CounterBloc closed');
    return super.close();
  }
}

class CounterScreen extends BlocWidget<CounterBloc, CounterState> {
  CounterScreen({super.key}) : super(bloc: CounterBloc());

  @override
  Widget build(context, bloc, state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: Text('${state.counterValue}'),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          IconButton(
            key: const Key('increment_floatingActionButton'),
            onPressed: () => bloc.add(Increment()),
            tooltip: 'Increment',
            icon: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          IconButton(
            key: const Key('decrement_floatingActionButton'),
            onPressed: () => bloc.add(Decrement()),
            tooltip: 'Decrement',
            icon: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
