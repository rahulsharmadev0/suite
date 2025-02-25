<p align="center">
<img src="https://raw.githubusercontent.com/rahulsharmadev0/suite/refs/heads/main/assets/logo/bg_bloc_suite.png" height="100" alt="Flutter Bloc Package" />
</p>

<p align="center">
<a href="https://pub.dev/packages/bloc_suite"><img src="https://img.shields.io/pub/v/bloc_suite.svg" alt="Pub"></a>
<a href="https://github.com/rahulsharmadev0/bloc/actions"><img src="https://github.com/felangel/bloc/workflows/build/badge.svg" alt="build"></a>
<a href="https://github.com/rahulsharmadev0/suite"><img src="https://img.shields.io/github/stars/rahulsharmadev0/suite.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Star on Github"></a>
<a href="https://flutter.dev/docs/development/data-and-backend/state-mgmt/options#bloc--rx"><img src="https://img.shields.io/badge/flutter-website-deepskyblue.svg" alt="Flutter Website"></a>
<a href="https://fluttersamples.com"><img src="https://img.shields.io/badge/flutter-samples-teal.svg?longCache=true" alt="Flutter Samples"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
<a href="https://github.com/felangel/bloc"><img src="https://tinyurl.com/bloc-library" alt="Bloc Library"></a>
</p>

---

Bloc Suite is a comprehensive package that extends the functionality of the Flutter Bloc library. It provides additional utilities, widgets, and patterns to simplify state management in Flutter applications.

## Features

- **BlocWidget**: A base widget that simplifies building UI components that depend on a BLoC.
- **BlocSelectorWidget**: A specialized widget that optimizes rebuilds by selecting specific parts of a Bloc's state.
- **LifecycleBloc**: A specialized Bloc that automatically handles lifecycle callbacks for events.
- **FlutterBlocObserver**: A BlocObserver that provides detailed logging capabilities for Flutter Bloc events and state changes.
- **ReplayCubit**: A specialized Cubit which supports `undo` and `redo` operations.
- **ReplayBloc**: A specialized Bloc which supports `undo` and `redo` operations.
- **BlocState**: A set of classes representing different states in a BLoC.
- **BlocEventTransformers**: A collection of event transformers for handling event streams.

## Use Cases

- Simplifying UI components that depend on BLoC state.
- Optimizing widget rebuilds by selecting specific parts of a BLoC's state.
- Automatically handling lifecycle callbacks for BLoC events.
- Providing detailed logging for BLoC events and state changes.
- Supporting `undo` and `redo` operations in BLoC and Cubit.
- Managing different states in a BLoC with ease.
- Handling event streams with custom transformers.

## Examples

### BlocWidget

The `BlocWidget` is a base widget that simplifies building UI components that depend on a BLoC. It handles the complexity of BLoC subscription and state management internally.

#### Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_suite/bloc_suite.dart';

class CounterBloc extends Cubit<int> {
  CounterBloc() : super(0);

  void increment() => emit(state + 1);
}

class CounterWidget extends BlocWidget<CounterBloc, int> {
  const CounterWidget({super.key});

  @override
  Widget build(BuildContext context, CounterBloc bloc, int state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Count: $state'),
        ElevatedButton(
          onPressed: bloc.increment,
          child: Text('Increment'),
        ),
      ],
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: BlocProvider(
          create: (_) => CounterBloc(),
          child: CounterWidget(),
        ),
      ),
    ),
  );
}
```

### BlocSelectorWidget

The `BlocSelectorWidget` is a specialized widget that optimizes rebuilds by selecting specific parts of a Bloc's state.

#### Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_suite/bloc_suite.dart';

class CounterState {
  final int counterValue;
  CounterState(this.counterValue);
}

class CounterBloc extends Cubit<CounterState> {
  CounterBloc() : super(CounterState(0));

  void increment() => emit(CounterState(state.counterValue + 1));
}

class CounterScreen extends BlocSelectorWidget<CounterBloc, CounterState, int> {
  CounterScreen() : super(
    bloc: CounterBloc(),
    selector: (state) => state.counterValue,
  );

  @override
  Widget build(context, bloc, value) {
    return Scaffold(
      body: Center(child: Text('$value')),
      floatingActionButton: FloatingActionButton(
        onPressed: bloc.increment,
        child: Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: BlocProvider(
        create: (_) => CounterBloc(),
        child: CounterScreen(),
      ),
    ),
  );
}
```

### LifecycleBloc

The `LifecycleBloc` is a specialized Bloc that automatically handles lifecycle callbacks for events.

#### Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_suite/bloc_suite.dart';

class CounterState {
  final int value;
  const CounterState(this.value);
}

sealed class CounterEvent extends LifecycleEvent {
  const CounterEvent({super.onCompleted, super.onError});
}

class Increment extends CounterEvent {
  const Increment({
    super.onCompleted,
    super.onSuccess,
    super.onError,
  });
}

class CounterBloc extends LifecycleBloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(0)) {
    on<Increment>(
      (event, emit) => emit(CounterState(state.value + 1)),
      transformer: BlocEventTransformer.throttle(
        const Duration(milliseconds: 500),
      ),
    );
  }
}

class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CounterBloc>();
    return Scaffold(
      body: Center(
        child: BlocBuilder<CounterBloc, CounterState>(
          builder: (context, state) {
            return Text('Count: ${state.value}');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => bloc.add(
          Increment(
            onSuccess: () => print('Counter increased'),
            onCompleted: () => print('Operation completed'),
            onError: (error) => print('Error: $error'),
          ),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: BlocProvider(
        create: (_) => CounterBloc(),
        child: CounterScreen(),
      ),
    ),
  );
}
```

### ReplayCubit

The `ReplayCubit` is a specialized Cubit which supports `undo` and `redo` operations.

#### Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_suite/bloc_suite.dart';

class CounterCubit extends ReplayCubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
}

class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CounterCubit>();
    return Scaffold(
      body: Center(
        child: BlocBuilder<CounterCubit, int>(
          builder: (context, state) {
            return Text('Count: $state');
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: cubit.increment,
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: cubit.undo,
            child: Icon(Icons.undo),
          ),
          FloatingActionButton(
            onPressed: cubit.redo,
            child: Icon(Icons.redo),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: BlocProvider(
        create: (_) => CounterCubit(),
        child: CounterScreen(),
      ),
    ),
  );
}
```

### ReplayBloc

The `ReplayBloc` is a specialized Bloc which supports `undo` and `redo` operations.

#### Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_suite/bloc_suite.dart';

abstract class CounterEvent {}
class CounterIncrementPressed extends CounterEvent {}

class CounterBloc extends ReplayBloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<CounterIncrementPressed>((event, emit) => emit(state + 1));
  }
}

class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CounterBloc>();
    return Scaffold(
      body: Center(
        child: BlocBuilder<CounterBloc, int>(
          builder: (context, state) {
            return Text('Count: $state');
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => bloc.add(CounterIncrementPressed()),
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: bloc.undo,
            child: Icon(Icons.undo),
          ),
          FloatingActionButton(
            onPressed: bloc.redo,
            child: Icon(Icons.redo),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: BlocProvider(
        create: (_) => CounterBloc(),
        child: CounterScreen(),
      ),
    ),
  );
}
```

### FlutterBlocObserver

The `FlutterBlocObserver` is a BlocObserver that provides detailed logging capabilities for Flutter Bloc events and state changes.

#### Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_suite/bloc_suite.dart';

void main() {
  Bloc.observer = FlutterBlocObserver(
    enabled: true,
    printEvents: true,
    printTransitions: true,
    printChanges: true,
    printCreations: true,
    printClosings: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text('Flutter Bloc Observer Example')),
      ),
    );
  }
}
```

### BlocState

The `BlocState` is a set of classes representing different states in a BLoC.

#### Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_suite/bloc_suite.dart';

class MyBloc extends Bloc<MyEvent, BlocState<int>> {
  MyBloc() : super(BlocStateInitial());

  @override
  Stream<BlocState<int>> mapEventToState(MyEvent event) async* {
    yield BlocStateLoading();
    try {
      final data = await fetchData();
      yield BlocStateSuccess(data);
    } catch (e) {
      yield BlocStateFailure('Failed to fetch data');
    }
  }
}

class MyEvent {}

Future<int> fetchData() async {
  await Future.delayed(Duration(seconds: 2));
  return 42;
}

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MyBloc>();
    return Scaffold(
      body: Center(
        child: BlocBuilder<MyBloc, BlocState<int>>(
          builder: (context, state) {
            return state.on(
              onInitial: Text('Initial State'),
              onLoading: (state) => CircularProgressIndicator(),
              onSuccess: (state) => Text('Data: ${state.data}'),
              onFailure: (state) => Text('Error: ${state.message}'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => bloc.add(MyEvent()),
        child: Icon(Icons.refresh),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: BlocProvider(
        create: (_) => MyBloc(),
        child: MyScreen(),
      ),
    ),
  );
}
```

### BlocEventTransformers

The `BlocEventTransformers` is a collection of event transformers for handling event streams.

#### Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_suite/bloc_suite.dart';

class MyEvent {}

class MyState {}

class MyBloc extends Bloc<MyEvent, MyState> {
  MyBloc() : super(MyState()) {
    on<MyEvent>(
      (event, emit) => emit(MyState()),
      transformer: BlocEventTransformer.debounce(const Duration(seconds: 1)),
    );
  }
}

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MyBloc>();
    return Scaffold(
      body: Center(
        child: BlocBuilder<MyBloc, MyState>(
          builder: (context, state) {
            return Text('State: $state');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => bloc.add(MyEvent()),
        child: Icon(Icons.refresh),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: BlocProvider(
        create: (_) => MyBloc(),
        child: MyScreen(),
      ),
    ),
  );
}
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request on [GitHub](https://github.com/rahulsharmadev0/suite).

## License

This project is licensed under the [MIT License](https://github.com/rahulsharmadev0/suite/blob/main/packages/bloc_suite/LICENSE).
