import 'dart:convert';

class Note {
  String? id;
  String title;
  String content;
  int priority;
  DateTime createAt;
  DateTime modifiedAt;
  List<String> tags;
  String? color;
  String? idAccount;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.priority,
    required this.createAt,
    required this.modifiedAt,
    required this.tags,
    this.color,
    this.idAccount,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    int? priority,
    DateTime? createAt,
    DateTime? modifiedAt,
    List<String>? tags,
    String? color,
    String? idAccount,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      priority: priority ?? this.priority,
      createAt: createAt ?? this.createAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      tags: tags ?? this.tags,
      color: color ?? this.color,
      idAccount: idAccount ?? this.idAccount,
    );
  }

  // Constants for map keys
  static const String _idKey = 'id';
  static const String _titleKey = 'title';
  static const String _contentKey = 'content';
  static const String _priorityKey = 'priority';
  static const String _createAtKey = 'createAt';
  static const String _modifiedAtKey = 'modifiedAt';
  static const String _tagsKey = 'tags';
  static const String _colorKey = 'color';
  static const String _idAccountKey = 'idAccount';

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['_id'] as String?,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      priority: map['priority'] ?? 0,
      createAt: DateTime.parse(map['createAt']),
      modifiedAt: DateTime.parse(map['modifiedAt']),
      tags: List<String>.from(map['tags'] ?? []),
      color: map['color'].toString(),
      idAccount: map['idAccount'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      _titleKey: title,
      _contentKey: content,
      _priorityKey: priority,
      _createAtKey: createAt.toIso8601String(),
      _modifiedAtKey: modifiedAt.toIso8601String(),
      _tagsKey: tags,
      _colorKey: color,
      _idAccountKey: idAccount,
    };
    if (id != null) {
      map[_idKey] = id!;
    }
    return map;
  }

  String toJson() => json.encode(toMap());
}