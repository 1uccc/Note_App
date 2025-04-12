class Note {
  String? id; // String vì MongoDB dùng ObjectId
  String title;
  String content;
  int priority;
  DateTime createAt;
  DateTime modifiedAt;
  List<String> tags;
  String color;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.priority,
    required this.createAt,
    required this.modifiedAt,
    required this.tags,
    required this.color,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['_id'], // MongoDB ObjectId
      title: map['title'],
      content: map['content'],
      priority: map['priority'],
      createAt: DateTime.parse(map['createAt']),
      modifiedAt: DateTime.parse(map['modifiedAt']),
      tags: List<String>.from(map['tags'] ?? []),
      color: map['color'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'title': title,
      'content': content,
      'priority': priority,
      'createAt': createAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
      'tags': tags,
      'color': color,
    };
    if (id != null) {
      map['_id'] = id!;
    }
    return map;
  }
}
