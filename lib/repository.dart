import 'dart:convert';
import 'package:noteify/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteRepository {
  final String key = 'notes';

  Future<List<Note>> getNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final notes = prefs.getStringList(key) ?? [];

    return notes.map((noteJson) {
      Map<String, dynamic> noteMap = json.decode(noteJson);
      return Note(
        title: noteMap['title'],
        category: noteMap['category'],
        content: noteMap['content'],
        createdAt: DateTime.parse(noteMap['createdAt']),
      );
    }).toList();
  }

  Future<void> addNote(Note note) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final notes = prefs.getStringList(key) ?? [];
    notes.add(json.encode({
      'title': note.title,
      'category': note.category,
      'content': note.content,
      'createdAt': note.createdAt.toIso8601String(),
    }));
    prefs.setStringList(key, notes);
  }

  Future<void> editNote(Note updatedNote) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final notes = prefs.getStringList(key) ?? [];

    final index = notes.indexWhere((noteJson) {
      Map<String, dynamic> noteMap = json.decode(noteJson);
      return noteMap['createdAt'] == updatedNote.createdAt.toIso8601String();
    });

    if (index != -1) {
      notes[index] = json.encode({
        'title': updatedNote.title,
        'category': updatedNote.category,
        'content': updatedNote.content,
        'createdAt': updatedNote.createdAt.toIso8601String(),
      });

      prefs.setStringList(key, notes);
    }
  }

  Future<void> deleteNote(Note note) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final notes = prefs.getStringList(key) ?? [];

    final updatedNotes = notes.where((noteJson) {
      Map<String, dynamic> noteMap = json.decode(noteJson);
      return noteMap['createdAt'] != note.createdAt.toIso8601String();
    }).toList();

    prefs.setStringList(key, updatedNotes);
  }
}
