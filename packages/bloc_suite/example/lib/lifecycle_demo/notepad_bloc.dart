import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_suite/bloc_suite.dart';

enum NotepadType { add, remove, edit }

class NotepadEvent {
  final int? index;
  final String? note;
  final NotepadType type;

  NotepadEvent.add(String this.note)
      : type = NotepadType.add,
        index = null;
  NotepadEvent.remove(int this.index)
      : type = NotepadType.remove,
        note = null;
  NotepadEvent.edit(int this.index, this.note) : type = NotepadType.edit;

  @override
  String toString() {
    return switch (type) {
      NotepadType.add => 'Add note: $note',
      NotepadType.remove => 'Remove note at index: $index',
      NotepadType.edit => 'Edit note at index: $index to: $note',
    };
  }
}

typedef NotepadState = List<String>;

// Bloc
class NotepadBloc extends LifecycleBloc<NotepadEvent, List<String>> {
  NotepadBloc() : super([]) {
    on<NotepadEvent>(_noteEvent);
  }

  FutureOr<void> _noteEvent(NotepadEvent event, Emitter emit) async {
    try {
      NotepadState newState;
      await Future.delayed(const Duration(seconds: 1));
      newState = List<String>.from(state);
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
    } catch (e) {
      // In a real app, you might want to emit an error state or log this
      print('Error processing notepad event: $e');
      // Re-emit current state to maintain immutability
      emit(List<String>.from(state));
    }
  }
}
