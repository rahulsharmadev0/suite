import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'person_bloc.dart';
import 'notepad_bloc.dart';

void main(List<String> args) {
  runApp(const LifecycleDemoApp());
}

class LifecycleDemoApp extends StatelessWidget {
  const LifecycleDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLoC to BloC Communication via LifecycleBloc',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<NotepadBloc>(create: (context) => NotepadBloc()),
          BlocProvider<PersonBloc>(
            create: (context) => PersonBloc(context.read<NotepadBloc>()),
          ),
        ],
        child: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _noteController = TextEditingController();
  final _editController = TextEditingController();
  int? _editingIndex;

  @override
  void dispose() {
    _noteController.dispose();
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BLoC Communication Example')),
      body: Column(
        children: [
          // Person status indicator
          BlocBuilder<PersonBloc, PersonState>(
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(16),
                color: switch (state) {
                  PersonIdle() => Colors.green.shade100,
                  PersonWriting() => Colors.amber.shade100,
                  PersonError() => Colors.red.shade100,
                },
                width: double.infinity,
                child: Center(
                  child: Text(
                      switch (state) {
                        PersonIdle() => 'Ready',
                        PersonWriting() => state.action,
                        PersonError() => 'Error: ${state.message}',
                      },
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              );
            },
          ),

          // Add note form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      labelText: 'Add a new note',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_noteController.text.isNotEmpty) {
                      context
                          .read<PersonBloc>()
                          .add(AddNote(_noteController.text));
                      _noteController.clear();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),

          // Edit form (conditionally shown)
          if (_editingIndex != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _editController,
                      decoration: const InputDecoration(
                        labelText: 'Edit note',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_editController.text.isNotEmpty &&
                          _editingIndex != null) {
                        context.read<PersonBloc>().add(
                              EditNote(_editingIndex!, _editController.text),
                            );
                        _editController.clear();
                        setState(() {
                          _editingIndex = null;
                        });
                      }
                    },
                    child: const Text('Save'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _editingIndex = null;
                        _editController.clear();
                      });
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),

          // Notes list
          Expanded(
            child: BlocBuilder<NotepadBloc, List<String>>(
              builder: (context, notes) {
                if (notes.isEmpty) {
                  return const Center(child: Text('No notes yet. Add some!'));
                }

                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(notes[index]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                _editingIndex = index;
                                _editController.text = notes[index];
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              context.read<PersonBloc>().add(RemoveNote(index));
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
