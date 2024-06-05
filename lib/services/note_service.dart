import 'dart:convert';
import 'dart:io';
import 'package:keep/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteService {
  List<Note> _notes = [];
  int _nextId = 1;

  Future<void> loadNotes() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/notes.json');
    if (await file.exists()) {
      final data = await file.readAsString();
      if (data.isNotEmpty) {
        final json = jsonDecode(data) as List;
        _notes = json.map((item) => Note.fromJson(item)).toList();
        if (_notes.isNotEmpty) {
          _nextId =
              _notes.map((note) => note.id).reduce((a, b) => a > b ? a : b) + 1;
        }
      }
    }
  }

  Future<void> saveNotes() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/notes.json');
    final data = jsonEncode(_notes.map((note) => note.toJson()).toList());
    await file.writeAsString(data);
  }

  List<Note> getNotes() => _notes;

  void addNote(String title, String content, List<String> labels) {
    final now = DateTime.now();
    final note = Note(
      id: _nextId++,
      title: title,
      content: content,
      createdDate: now,
      updatedDate: now,
      labels: labels,
    );
    _notes.add(note);
  }

  void deleteNoteById(int id) {
    _notes.removeWhere((note) => note.id == id);
  }

  void addLabelToNote(int id, String label) {
    for (var note in _notes) {
      if (note.id == id && !note.labels.contains(label)) {
        note.labels.add(label);
        note.updatedDate = DateTime.now();
        break;
      }
    }
  }

  void removeLabelFromNote(int id, String label) {
    for (var note in _notes) {
      if (note.id == id && note.labels.contains(label)) {
        note.labels.remove(label);
        note.updatedDate = DateTime.now();
        break;
      }
    }
  }

  List<String> getAllLabels() {
    final labels = _notes.expand((note) => note.labels).toSet().toList();
    return labels;
  }

  List<Note> getNotesByLabel(String label) {
    return _notes.where((note) => note.labels.contains(label)).toList();
  }
}
