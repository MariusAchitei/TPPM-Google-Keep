import 'dart:convert';
import 'dart:io';

import 'package:keep/json/note.dart';
import 'dart:math';
import 'package:path_provider/path_provider.dart';

class JsonUtils {
  static Future<File> getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/notes.json');
    // if (!await file.exists()) {
    await file.create();
    await file.writeAsString('[]');
    // }
    return file;
  }

  static Future<List<Note>> loadNotes() async {
    final file = await getLocalFile();
    String jsonString = await file.readAsString();
    final List<dynamic> jsonResponse = jsonDecode(jsonString);
    return jsonResponse.map<Note>((json) => Note.fromJson(json)).toList();
  }

  static Future<void> appendToJsonFile(String filePath, dynamic newData) async {
    final file = await getLocalFile();
    String jsonString = await file.readAsString();
    List<dynamic> jsonData = json.decode(jsonString);

    jsonData.add(newData);

    String updatedJsonString = json.encode(jsonData);
    await file.writeAsString(updatedJsonString);
  }

  static Future<int> getMaximumIdFromJson(String filePath) async {
    final file = await getLocalFile();
    String jsonString = await file.readAsString();
    final List<dynamic> jsonResponse = jsonDecode(jsonString);
    List<Note> notes =
        jsonResponse.map<Note>((json) => Note.fromJson(json)).toList();
    print(notes);
    var ids = notes.map((e) => e.id);
    return ids.isEmpty ? 1 : ids.reduce(max);
  }

  static Future<void> deleteNoteFromJson(String filePath, int id) async {
    final file = await getLocalFile();
    String jsonString = await file.readAsString();
    List<dynamic> jsonData = json.decode(jsonString);

    jsonData.removeWhere((element) => element['id'] == id);

    String updatedJsonString = json.encode(jsonData);
    await file.writeAsString(updatedJsonString);
  }

  static Future<void> updateNoteTitleFromJson(int noteId, String title) async {
    updateNoteFromJson(noteId, title, null);
  }

  static Future<void> updateNoteDescriptionFromJson(
      int noteId, String description) async {
    updateNoteFromJson(noteId, null, description);
  }

  static Future<void> updateNoteFromJson(
      int noteId, String? title, String? description) async {
    final file = await getLocalFile();
    String jsonString = await file.readAsString();
    final List<dynamic> jsonResponse = jsonDecode(jsonString);
    List<Note> notes =
        jsonResponse.map<Note>((json) => Note.fromJson(json)).toList();

    Note note = notes.firstWhere((element) => element.id == noteId);
    if (title != null) note.title = title;
    if (description != null) note.description = description;

    print(notes);

    String updatedJsonString = json.encode(notes);
    await file.writeAsString(updatedJsonString);
  }

  static getNoteTitleFromJson(int noteId) {}

  static getNoteDescriptionFromJson(int noteId) {}
}
