import 'package:bloc_suite/bloc_suite.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'notepad_bloc.dart';

// Events
sealed class PersonEvent {
  const PersonEvent();
}

class _SelfEmitter extends PersonEvent {
  final PersonState state;
  const _SelfEmitter(this.state);
}

class AddNote extends PersonEvent {
  final String note;
  const AddNote(this.note);
}

class RemoveNote extends PersonEvent {
  final int index;
  const RemoveNote(this.index);
}

class EditNote extends PersonEvent {
  final int index;
  final String note;
  const EditNote(this.index, this.note);
}

// State
sealed class PersonState {}

class PersonIdle extends PersonState {}

class PersonWriting extends PersonState {
  final String action;
  PersonWriting(this.action);
}

class PersonError extends PersonState {
  final String message;
  PersonError(this.message);
}

// Bloc
class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final NotepadBloc notepadBloc; // Dependency Injection

  PersonBloc(this.notepadBloc) : super(PersonIdle()) {
    on<_SelfEmitter>((event, emit) => emit(event.state));
    on<AddNote>((event, emit) {
      var notepadEvent = NotepadEvent.add(event.note);
      // Listen to the notepadBloc for the event response
      listionAndNotify(event: notepadEvent, text: 'Adding note: ${event.note}');
      notepadBloc.add(notepadEvent); // Trigger the event
    });

    on<RemoveNote>((event, emit) {
      var notepadEvent = NotepadEvent.remove(event.index);
      listionAndNotify(
        event: notepadEvent,
        text: 'Removing note at index: ${event.index}',
      );
      notepadBloc.add(notepadEvent);
    });

    on<EditNote>((event, emit) {
      var notepadEvent = NotepadEvent.edit(event.index, event.note);
      // Listen to the notepadBloc for the event response
      listionAndNotify(
        event: notepadEvent,
        text: 'Editing note at index: ${event.index} to: ${event.note}',
      );

      notepadBloc.add(notepadEvent);
    });
  }

  void listionAndNotify({required NotepadEvent event, required String text}) {
    notepadBloc.addEventListener(event, (object) async {
      if (object.status == EventStatus.started) {
        add(_SelfEmitter(PersonWriting(text)));
      } else if (object.status == EventStatus.success) {
        add(_SelfEmitter(PersonIdle()));
      } else if (object.status == EventStatus.completed) {
        notepadBloc.removeEventListeners(object.event);
      }
    });
  }
}
