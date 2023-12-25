// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:noteify/model.dart';
import 'package:noteify/repository.dart';

class EditNotePage extends StatefulWidget {
  final Note note;

  const EditNotePage({super.key, required this.note});

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  String selectedCategory = '';
  late NoteRepository noteRepository;

  @override
  void initState() {
    super.initState();
    noteRepository = NoteRepository();
    titleController.text = widget.note.title;
    contentController.text = widget.note.content;
    selectedCategory = widget.note.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField(
              value: selectedCategory,
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
                  selectedCategory = value.toString();
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Note Content'),
              maxLines: 5,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                saveEditedNoteAndNavigateBack(context);
              },
              child: const Text('Save'),
            ),
            const SizedBox(height: 8.0),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  void saveEditedNoteAndNavigateBack(BuildContext context) {
    if (titleController.text.isEmpty || contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final updatedNote = Note(
      title: titleController.text,
      category: selectedCategory,
      content: contentController.text,
      createdAt: widget.note.createdAt,
    );

    noteRepository.editNote(updatedNote);

    Navigator.pop(context, updatedNote);
  }
}
