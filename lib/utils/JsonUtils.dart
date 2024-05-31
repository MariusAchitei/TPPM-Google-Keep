import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:keep/json/note.dart';
import 'dart:math';

class JsonUtils {
  static Future<List<Note>> loadNotes() async {
    final jsonString = await rootBundle.loadString('assets/notes.json');
    final List<dynamic> jsonResponse = jsonDecode(jsonString);
    return jsonResponse.map<Note>((json) => Note.fromJson(json)).toList();
  }

  static Future<void> appendToJsonFile(String filePath, dynamic newData) async {
    File file = File(filePath);
    String jsonString = await file.readAsString();
    List<dynamic> jsonData = json.decode(jsonString);

    jsonData.add(newData);

    String updatedJsonString = json.encode(jsonData);
    await file.writeAsString(updatedJsonString);
  }

  static Future<int> getMaximumIdFromJson(String filePath) async {
    final jsonString = await rootBundle.loadString('assets/notes.json');
    final List<dynamic> jsonResponse = jsonDecode(jsonString);
    List<Note> notes =
        jsonResponse.map<Note>((json) => Note.fromJson(json)).toList();
    print(notes);
    var salut = notes.map((e) => e.id);
    print(salut);
    print(salut.reduce(max));
    return salut.reduce(max);
  }

  static Future<void> deleteNoteFromJson(String filePath, int id) async {
    File file = File(filePath);
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
    final jsonString = await rootBundle.loadString('assets/notes.json');
    final List<dynamic> jsonResponse = jsonDecode(jsonString);
    List<Note> notes =
        jsonResponse.map<Note>((json) => Note.fromJson(json)).toList();

    Note note = notes.firstWhere((element) => element.id == noteId);
    if (title != null) note.title = title;
    if (description != null) note.description = description;

    print(notes);

    String updatedJsonString = json.encode(notes);
    File file = File('assets/notes.json');
    await file.writeAsString(updatedJsonString);
  }

  static getNoteTitleFromJson(int noteId) {}

  static getNoteDescriptionFromJson(int noteId) {}
}
