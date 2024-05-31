import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Note {
  static int idCounter = 0;
  int id;
  String title;
  String description;

  Note(this.title, this.description, this.id);

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      json['title'] as String,
      json['description'] as String,
      json['id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'id': id,
    };
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, description: $description}';
  }
}
