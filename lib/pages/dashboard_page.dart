// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:noteify/model.dart';
import 'package:noteify/repository.dart';
import 'package:noteify/pages/add_note_page.dart';
import 'package:noteify/pages/detail_note_page.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final NoteRepository noteRepository = NoteRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noteify'),
        actions: const [
          Padding(
            padding: EdgeInsets.all(4.0),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage('https://avatars.githubusercontent.com/u/70874414?v=4'),
            ),
          ),
          SizedBox(width: 4.0),
          Text(
            'ipincamp',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 20.0),
        ],
      ),
      body: FutureBuilder(
        future: noteRepository.getNotes(),
        builder: (context, AsyncSnapshot<List<Note>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No notes available.'));
          } else {
            return buildNoteList(snapshot.data!);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNotePage()),
          ).then((value) {
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildNoteList(List<Note> notes) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Card(
          elevation: 3.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text(note.title),
            subtitle: Text('${note.category} - ${note.createdAt.toString()}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailNotePage(note: note),
                ),
              ).then((value) {
                setState(() {});
              });
            },
          ),
        );
      },
    );
  }
}
