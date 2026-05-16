class Task {
  final String id;
  final String userId;
  final String title;
  final bool completed;
  final String priority;
  final DateTime createdAt;
  final DateTime? reminderAt;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    required this.completed,
    required this.priority,
    required this.createdAt,
    this.reminderAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      completed: json['completed'],
      priority: json['priority'],
      createdAt: DateTime.parse(json['createdAt']),
      reminderAt: json['reminderAt'] != null ? DateTime.parse(json['reminderAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'completed': completed,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'reminderAt': reminderAt?.toIso8601String(),
    };
  }

  Task copyWith({
    String? title,
    bool? completed,
    String? priority,
    DateTime? reminderAt,
  }) {
    return Task(
      id: id,
      userId: userId,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      priority: priority ?? this.priority,
      createdAt: createdAt,
      reminderAt: reminderAt ?? this.reminderAt,
    );
  }
}
