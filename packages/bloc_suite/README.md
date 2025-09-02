<p align="center">
<img src="https://raw.githubusercontent.com/rahulsharmadev0/suite/refs/heads/main/assets/logo/bg_bloc_suite.png" height="150" alt="Flutter Bloc Package" />
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

<p align="center">
  <strong style="font-size:22px; display:block; margin-bottom:10px;">
    📦 Other Packages in This Suite
  </strong>
</p>
  
<p align="center">🧩 <a href="https://pub.dev/packages/dart_suite"><strong>dart_suite</strong></a> — A versatile Dart package offering a comprehensive collection of utilities, extensions, and data structures for enhanced development productivity.</p>
<p align="center">⚙️ <a href="https://pub.dev/packages/gen_suite"><strong>gen_suite</strong></a> — Code-generation tools and annotations to automate boilerplate and speed up development.</p>

<p align="center">
  <a href="https://pub.dev/packages/dart_suite">
    <img src="https://img.shields.io/pub/v/dart_suite.svg?label=dart_suite&color=1f7aed&logo=dart" alt="dart_suite" />
  </a>
  &nbsp;&nbsp;
  <a href="https://pub.dev/packages/gen_suite">
    <img src="https://img.shields.io/pub/v/gen_suite.svg?label=gen_suite&color=ffcc00&logo=google" alt="gen_suite" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/rahulsharmadev0/suite"><strong>🔎 Explore the full suite →</strong></a>
</p>

---
# Bloc Suite
Bloc Suite is a comprehensive package that extends the functionality of the Flutter Bloc library. It provides additional utilities, widgets, and patterns to simplify state management in Flutter applications.

## Features

- **[BlocWidget](#blocwidget)**: A base widget that simplifies building UI components that depend on a BLoC.
- **[BlocSelectorWidget](#blocselectorwidget)**: A specialized widget that optimizes rebuilds by selecting specific parts of a Bloc's state.
- **[LifecycleBloc](#lifecyclebloc)**: A specialized Bloc that automatically handles lifecycle callbacks for events.
- **[FlutterBlocObserver](#flutterblocobserver)**: A BlocObserver that provides detailed logging capabilities for Flutter Bloc events and state changes.
- **[BlocEventTransformers](#bloceventtransformer)**: A collection of event transformers for handling event streams.
- **[ReplayBloc](#replaybloc)**: A specialized Bloc which supports `undo` and `redo` operations.

---

## BlocWidget

The `BlocWidget` is a base widget that simplifies building UI components that depend on a BLoC. It handles the complexity of BLoC subscription and state management internally.

#### Example

```dart
class CounterBloc extends Cubit<int> {
  CounterBloc() : super(0);

  void increment() => emit(state + 1);
}

class CounterWidget extends BlocWidget<CounterBloc, int> {
  const CounterWidget({super.key});

  @override
  Widget build(BuildContext context, CounterBloc bloc, int state) {
    return ...your_code;
  }
}
```

## BlocSelectorWidget

The `BlocSelectorWidget` is a specialized widget that optimizes rebuilds by selecting specific parts of a Bloc's state.

#### Example

```dart
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
    return ...your_code;
  }
}
```

## LifecycleBloc

The `LifecycleBloc` is a specialized Bloc that enhances event lifecycle tracking in a reactive and decoupled way. It automatically tracks the full lifecycle of each event, making it perfect for complex workflows and inter-bloc communication.

### Key Features

- **Automatic event lifecycle tracking** with distinct phases:
  - `started` - Event received and processing begun
  - `success` - Event processed successfully
  - `error` - Error occurred during processing
  - `completed` - Processing finished (regardless of outcome)
- **Decoupled communication** between blocs without tight dependencies
- **Reactive architecture** supporting complex workflows
- **Event-specific listeners** that can be added and removed dynamically

### Best Use Cases

- **Bloc-to-Bloc communication** with minimal coupling
- **Multi-step workflows** like authentication, payments, or file uploads
- **Background processes** that require real-time UI updates
- **Real-time event-driven systems** like chat apps or notification handlers

### Example Usage

Let's explore a practical example of communication between two blocs:

```dart
// First, create a NotepadBloc that extends LifecycleBloc
class NotepadBloc extends LifecycleBloc<NotepadEvent, List<String>> {
  NotepadBloc() : super([]) {
    on<NotepadEvent>(_noteEvent);
  }

  FutureOr<void> _noteEvent(NotepadEvent event, Emitter emit) async {
    // Processing logic with artificial delay to demonstrate async behavior
    await Future.delayed(const Duration(seconds: 1));

    NotepadState newState = List<String>.from(state);
    switch (event.type) {
      case NotepadType.add:
        newState.add(event.note!);
        break;
      case NotepadType.remove:
        newState.removeAt(event.index!);
        break;
      case NotepadType.edit:
        newState[event.index!] = event.note!;
        break;
    }
    emit(newState);
  }
}

// Then, create a PersonBloc that depends on NotepadBloc
class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final NotepadBloc notepadBloc;

  PersonBloc(this.notepadBloc) : super(PersonIdle()) {
    // Event handlers
    on<AddNote>((event, emit) {
      var notepadEvent = NotepadEvent.add(event.note);

      // Register a listener for this specific event's lifecycle
      notepadBloc.addEventListener(notepadEvent, (wrapper) {
        switch (wrapper.status) {
          case EventStatus.started:
            add(_SelfEmitter(PersonWriting('Adding note: ${event.note}')));
            break;
          case EventStatus.success:
            add(_SelfEmitter(PersonIdle()));
            break;
          case EventStatus.completed:
            // Clean up when done
            notepadBloc.removeEventListeners(wrapper.event);
            break;
        }
      });

      // Trigger the event in the notepad bloc
      notepadBloc.add(notepadEvent);
    });

    // Additional event handlers
  }
}
```

### Event Lifecycle Tracking API

The LifecycleBloc provides several methods for tracking events:

```dart
// Add a listener for a specific event
StreamSubscription<EventWrapper<Event>> addEventListener(
  Event key,
  void Function(EventWrapper<Event> eventWrapper) callback
);

// Remove all listeners for a specific event
void removeEventListeners(Event key);

// Check if a specific event has listeners
bool hasListenersForEvent(Event key);

// Check if any events have listeners
bool get hasListeners;
```

### EventWrapper and EventStatus

Event tracking uses an `EventWrapper` class that contains:

```dart
class EventWrapper<T> {
  final T event;        // The original event
  final EventStatus status;  // Current status
  final dynamic error;  // Error (if any)
}

enum EventStatus {
  started,    // Event processing has begun
  success,    // Event was processed successfully
  error,      // An error occurred
  completed   // Processing has finished (always called)
}
```

### Best Practices

1. **Always remove event listeners** when you're done with them to prevent memory leaks
2. **Use the completed status** for cleanup operations
3. **Keep processing logic in the primary bloc** that extends LifecycleBloc
4. **Consider error handling** by checking for the error status

LifecycleBloc provides a powerful pattern for managing complex state transitions and inter-bloc communication while maintaining loose coupling between components.

## BlocEventTransformer

The `BlocEventTransformer` class provides a collection of event transformers that help control the flow of events in BLoC (Business Logic Component) patterns. These transformers allow you to manipulate events before they are processed by the BLoC's event handlers.

### Choosing the Right Transformer

| Transformer       | Sequential      | Distinct        | Best Use Case                                                                 |
| ----------------- | --------------- | --------------- | ----------------------------------------------------------------------------- |
| **`delay`**       | ✅ Always       | 🔄 Configurable | Postpone processing (e.g., brief loading indicators).                         |
| **`debounce`**    | ✅ Always       | 🔄 Configurable | Wait for inactivity before processing (e.g., search inputs, form validation). |
| **`throttle`**    | ✅ Always       | 🔄 Configurable | Control frequent events (e.g., scrolling, resizing).                          |
| **`restartable`** | ✅ Always       | 🔄 Configurable | Cancel outdated events when new ones arrive (e.g., live search API calls).    |
| **`sequential`**  | ✅ Always       | 🔄 Configurable | Ensure ordered execution (e.g., sending messages one by one).                 |
| **`droppable`**   | ✅ Always       | 🔄 Configurable | Process only the latest event, dropping older ones (e.g., UI animations).     |
| **`skip`**        | 🔄 Configurable | 🔄 Configurable | Ignore initial events (e.g., first trigger in a lifecycle).                   |
| **`distinct`**    | 🔄 Configurable | ✅ Always       | Avoid duplicate event processing (e.g., filtering unchanged user actions).    |
| **`take`**        | 🔄 Configurable | 🔄 Configurable | Limit the number of events (e.g., first N items in a list).                   |

### 1. `delay`

Delays the processing of each event by a specified duration, shifting the entire sequence forward in time.

**Parameters:**

- `duration`: The time to delay each event.
- `distinct`: When true, skips events that are equal to the previous event. Default: `false`

**Usage:**

```dart
on<ExampleEvent>(
  _handleEvent,
  transformer: BlocEventTransformer.delay(const Duration(seconds: 1)),
);
```

**Visual Representation:**

```
Input:  --a--------b---c--->
Output: ----a--------b---c->  (with 1s delay)
```

### 2. `debounce`

Debouncing is useful when the event is frequently being triggered in a short interval of time Useful for handling rapidly firing events like search input.

**Parameters:**

- `duration`: The time window to wait for inactivity.

**Usage:**

```dart
on<SearchQueryEvent>(
  _handleSearchQuery,
  transformer: BlocEventTransformer.debounce(const Duration(milliseconds: 300)),
);
```

**Visual Representation:**

```
Input:  --a-ab-bc--c------d->
Output: --------c---------d->  (with 300ms debounce)
```

### 3. `throttle`

Limits how often an event can be processed.

**Parameters:**

- `duration`: The minimum time between processed events.
- `leading`: If `true`, process the first event in a burst (default: `true`).
- `trailing`: If `true`, process the last event in a burst (default: `false`).

**Usage:**

```dart
on<ScrollEvent>(
  _handleScrollEvent,
  transformer: BlocEventTransformer.throttle(
    const Duration(milliseconds: 200),
    trailing: true,
  ),
);
```

**Visual Representation:**

```
Input:  --a-ab-bc--c-------d-->
Output: --a----b----c-------d->  (with 200ms throttle, leading: true)
```

### 4. `restartable`

Cancels any in-progress event processing when a new event arrives. Useful for operations that can be abandoned if newer data is available.

**Usage:**

```dart
on<FetchDataEvent>(
  _handleFetchData,
  transformer: BlocEventTransformer.restartable(),
);
```

**Visual Representation:**

```
Input:     --a-----b---c--->
Processing: --[a]--X
                  --[b]X
                      --[c]--->
Output:     ---------x----x--->
```

### 5. `sequential`

Processes events one after another, ensuring order is maintained. Events are queued and handled in sequence.

**Usage:**

```dart
on<SaveDataEvent>(
  _handleSaveData,
  transformer: BlocEventTransformer.sequential(),
);
```

**Visual Representation:**

```
Input:      --a--b--c-------->
Processing: --[a]--[b]--[c]-->
Output:     ----x----x----x-->
```

### 6. `droppable`

Ignores new events until the current event processing is complete.

**Usage:**

```dart
on<ProcessIntensiveEvent>(
  _handleIntensiveTask,
  transformer: BlocEventTransformer.droppable(),
);
```

**Visual Representation:**

```
Input:      --a--b--c-------->
Processing: ---[a]-------->
Output:     --------x--------->  (b and c are dropped)
```

### 7. `skip`

Skips a specified number of initial events.

**Parameters:**

- `count`: The number of events to skip.

**Usage:**

```dart
on<PageLoadEvent>(
  _handlePageLoad,
  transformer: BlocEventTransformer.skip(1), // Skip first event
);
```

**Visual Representation:**

```
Input:  --a--b--c--d--e-->
Output: -----b--c--d--e-->  (with count: 1)
```

### 7. `distinct`

Skips events if they are equal to the previous event.

**Usage:**

```dart
on<FilterEvent>(
  _handleFilterEvent,
  transformer: BlocEventTransformer.distinct(),
);
```

**Visual Representation:**

```
Input:  --a--a--b--b--c--c-->
Output: --a-----b-----c----->  (duplicate events are skipped)
```

### 8. `take`

Creates an event transformer that takes a specified number of events.

**Usage:**

```dart
on<LoadEvent>(
  _handleLoadEvent,
  transformer: BlocEventTransformer.take(3), // Take first 3 events
);
```

**Visual Representation:**

```
Input:  --a--b--c--d--e-->
Output: --a--b--c-------->  (with limit: 3)
```

## FlutterBlocObserver

The `FlutterBlocObserver` is a BlocObserver that provides detailed logging capabilities for Flutter Bloc events and state changes.

#### Example

```dart
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
...more

```

<img src="https://raw.githubusercontent.com/rahulsharmadev0/suite/refs/heads/main/assets/screenshots/fbo_1.png" height="200" alt="Flutter Bloc Observer" />

## ReplayBloc

> This section is inspired by the [replay_bloc](https://github.com/felangel/bloc/tree/master/packages/replay_bloc) package from the official Bloc library. For more detailed information and examples, please refer to the original repository.

### Creating a ReplayCubit

```dart
class CounterCubit extends ReplayCubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
}
```

### Using a ReplayCubit

```dart
void main() {
  final cubit = CounterCubit();

  // trigger a state change
  cubit.increment();
  print(cubit.state); // 1

  // undo the change
  cubit.undo();
  print(cubit.state); // 0

  // redo the change
  cubit.redo();
  print(cubit.state); // 1
}
```

### ReplayCubitMixin

If you wish to be able to use a `ReplayCubit` in conjuction with a different type of cubit like `HydratedCubit`, you can use the `ReplayCubitMixin`.

```dart
class CounterCubit extends HydratedCubit<int> with ReplayCubitMixin {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);

  @override
  int fromJson(Map<String, dynamic> json) => json['value'] as int;

  @override
  Map<String, int> toJson(int state) => {'value': state};
}
```

### Creating a ReplayBloc

```dart
class CounterEvent extends ReplayEvent {}
class CounterIncrementPressed extends CounterEvent {}
class CounterDecrementPressed extends CounterEvent {}

class CounterBloc extends ReplayBloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<CounterIncrementPressed>((event, emit) => emit(state + 1));
    on<CounterDecrementPressed>((event, emit) => emit(state - 1));
  }
}
```

### Using a ReplayBloc

```dart
void main() {
  // trigger a state change
  final bloc = CounterBloc()..add(CounterIncrementPressed());

  // wait for state to update
  await bloc.stream.first;
  print(bloc.state); // 1

  // undo the change
  bloc.undo();
  print(bloc.state); // 0

  // redo the change
  bloc.redo();
  print(bloc.state); // 1
}
```

### ReplayBlocMixin

If you wish to be able to use a `ReplayBloc` in conjuction with a different type of cubit like `HydratedBloc`, you can use the `ReplayBlocMixin`.

```dart
sealed class CounterEvent with ReplayEvent {}
final class CounterIncrementPressed extends CounterEvent {}
final class CounterDecrementPressed extends CounterEvent {}

class CounterBloc extends HydratedBloc<CounterEvent, int> with ReplayBlocMixin {
  CounterBloc() : super(0) {
    on<CounterIncrementPressed>((event, emit) => emit(state + 1));
    on<CounterDecrementPressed>((event, emit) => emit(state - 1));
  }

  @override
  int fromJson(Map<String, dynamic> json) => json['value'] as int;

  @override
  Map<String, int> toJson(int state) => {'value': state};
}
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request on [GitHub](https://github.com/rahulsharmadev0/suite).

## License

This project is licensed under the [MIT License](https://github.com/rahulsharmadev0/suite/blob/main/packages/bloc_suite/LICENSE).
