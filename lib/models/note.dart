class Note {
  int id;
  String title;
  String content;
  DateTime createdDate;
  DateTime updatedDate;
  List<String> labels;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdDate,
    required this.updatedDate,
    required this.labels,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'createdDate': createdDate.toIso8601String(),
        'updatedDate': updatedDate.toIso8601String(),
        'labels': labels,
      };

  static Note fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        createdDate: DateTime.parse(json['createdDate']),
        updatedDate: DateTime.parse(json['updatedDate']),
        labels: List<String>.from(json['labels']),
      );
}
