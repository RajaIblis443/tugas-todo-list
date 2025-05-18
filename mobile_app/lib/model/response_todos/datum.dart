import 'dart:convert';

class Datum {
  int? id;
  String? title;
  bool? priority;
  DateTime? dueDate;
  String? description;
  String? category;
  bool? isFinished;
  DateTime? createdAt;

  Datum({
    this.id,
    this.title,
    this.priority,
    this.dueDate,
    this.description,
    this.category,
    this.isFinished,
    this.createdAt,
  });

  @override
  String toString() {
    return 'Datum(id: $id, title: $title, priority: $priority, dueDate: $dueDate, description: $description, category: $category, isFinished: $isFinished, createdAt: $createdAt)';
  }

  factory Datum.fromMap(Map<String, dynamic> data) => Datum(
    id: data['id'] as int?,
    title: data['title'] as String?,
    priority: data['priority'] as bool?,
    dueDate:
        data['due_date'] == null
            ? null
            : DateTime.parse(data['due_date'] as String),
    description: data['description'] as String?,
    category: data['category'] as String?,
    isFinished: data['isFinished'] as bool?,
    createdAt:
        data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'priority': priority,
    'due_date': dueDate?.toIso8601String(),
    'description': description,
    'category': category,
    'isFinished': isFinished,
    'createdAt': createdAt?.toIso8601String(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Datum].
  factory Datum.fromJson(String data) {
    return Datum.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Datum] to a JSON string.
  String toJson() => json.encode(toMap());

  Datum copyWith({
    int? id,
    String? title,
    bool? priority,
    DateTime? dueDate,
    String? description,
    String? category,
    bool? isFinished,
    DateTime? createdAt,
  }) {
    return Datum(
      id: id ?? this.id,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      description: description ?? this.description,
      category: category ?? this.category,
      isFinished: isFinished ?? this.isFinished,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
