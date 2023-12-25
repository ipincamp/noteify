// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:noteify/model.dart';
import 'package:noteify/pages/edit_note_page.dart';
import 'package:noteify/repository.dart';

class DetailNotePage extends StatefulWidget {
  final Note note;
  final NoteRepository noteRepository = NoteRepository();

  DetailNotePage({super.key, required this.note});

  @override
  _DetailNotePageState createState() => _DetailNotePageState();
}

class _DetailNotePageState extends State<DetailNotePage> {
  late Note _note;

  @override
  void initState() {
    super.initState();
    _note = widget.note;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_note.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Category: ${_note.category}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Created at: ${_note.createdAt.toString()}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16.0),
              Text(
                _note.content,
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _navigateToEditNotePage(context);
                    },
                    child: const Text('Edit'),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      _deleteNoteAndNavigateBack(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToEditNotePage(BuildContext context) async {
    final updatedNote = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNotePage(note: _note),
      ),
    );

    if (updatedNote != null && updatedNote is Note) {
      setState(() {
        _note = updatedNote;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note updated!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _deleteNoteAndNavigateBack(BuildContext context) async {
    await widget.noteRepository.deleteNote(_note);
    Navigator.pop(context);
  }
}
