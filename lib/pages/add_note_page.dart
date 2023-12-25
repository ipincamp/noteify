// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:noteify/model.dart';
import 'package:noteify/repository.dart';

class AddNotePage extends StatefulWidget {
  String selectedCategory = 'Personal';
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final NoteRepository noteRepository = NoteRepository();

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Note'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: widget.titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField(
              value: widget.selectedCategory,
              items: [
                'Work',
                'Personal',
                'Shopping',
                'Ideas',
                'Project',
                'Meetings',
                'Education',
                'Finance',
                'Health',
                'Travel'
              ]
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              decoration: const InputDecoration(labelText: 'Category'),
              onChanged: (value) {
                setState(() {
                  widget.selectedCategory = value.toString();
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: widget.contentController,
              decoration: const InputDecoration(labelText: 'Note Content'),
              maxLines: 5,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                saveNote(context);
              },
              child: const Text('Save'),
            ),
            const SizedBox(height: 8.0),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  void saveNote(BuildContext context) async {
    if (widget.titleController.text.isEmpty ||
        widget.contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newNote = Note(
      title: widget.titleController.text,
      category: widget.selectedCategory,
      content: widget.contentController.text,
      createdAt: DateTime.now(),
    );

    await widget.noteRepository.addNote(newNote);

    Navigator.pop(context);
  }
}
