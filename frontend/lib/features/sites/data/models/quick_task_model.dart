import 'package:frontend/core/enums/task_priority.dart';

class QuickTaskModel {
  final String title;
  final String? description;
  final TaskPriority priority;

  QuickTaskModel({
    required this.title,
    required this.description,
    required this.priority,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'priority': priority.toJson()
    };
  }
}
