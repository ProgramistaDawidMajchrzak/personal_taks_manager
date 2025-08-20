enum TaskCategory { work, personal, other }

class Task {
  final int? id;
  final String title;
  final TaskCategory category;
  final DateTime deadline;
  final String? note;
  final bool isDone;

  Task({
    this.id,
    required this.title,
    required this.category,
    required this.deadline,
    this.note,
    this.isDone = false,
  });
}
