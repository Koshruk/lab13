import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab13_1/models/notes_model.dart';
import 'package:lab13_1/database/database_connection.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key, required this.title});

  final String title;

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();

  List<Notes> _notes = [];

  void _loadNotes() async {
    final notes = await DBProvider.db.getRows();
    setState(() {
      _notes = notes.map((data) => Notes.fromMap(data)).toList();
    });
  }

  void _addNote() async {
    final newNote = Notes(
      text: _textController.text,
      date: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
    );

    await DBProvider.db.newNote(newNote);

    _textController.clear();

    _loadNotes();
  }

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field cannot be empty";
                        } else if (value.length > 100) {
                          return "Description is too long";
                        } else {
                          return null;
                        }
                      },
                      controller: _textController,
                    ),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () async {
                      final isValid = _formKey.currentState?.validate();
                      if (isValid == true) {
                        _addNote();
                      }
                    },
                    child: const Text("Add"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
            Expanded(
              child: _notes.isEmpty
                  ? const Center(child: Text('No notes available'))
                  : ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  return Column(
                    children: [
                      Card(
                        elevation: 3,
                        child: ListTile(
                          title: Text(
                            note.text,
                            style: const TextStyle(fontSize: 20),
                          ),
                          trailing: Text(
                            note.date,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
