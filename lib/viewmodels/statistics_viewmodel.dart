import 'package:flutter/foundation.dart';
import '../services/task_service.dart';
import '../models/task_model.dart' as model;

class StatsViewModel extends ChangeNotifier {
  final TaskService _taskService;

  List<model.Task> _allTasks = [];

  StatsViewModel(this._taskService) {
    _observeTasks();
  }

  List<model.Task> get allTasks => _allTasks;

  void _observeTasks() {
    _taskService.watchAllTasksSorted().listen((tasks) {
      _allTasks =
          tasks.map((t) {
            final catIndex = t.category;
            final cat =
                (catIndex >= 0 && catIndex < model.TaskCategory.values.length)
                    ? model.TaskCategory.values[catIndex]
                    : model.TaskCategory.values[0];
            return model.Task(
              id: t.id,
              title: t.title,
              category: cat,
              deadline: t.deadline,
              note: t.note,
              isDone: t.isDone,
            );
          }).toList();
      notifyListeners();
    });
  }

  DateTime _startOfWeek(DateTime date) {
    final monday = date.subtract(Duration(days: date.weekday - 1));
    return DateTime(monday.year, monday.month, monday.day);
  }

  DateTime _endOfWeek(DateTime date) {
    final sunday = _startOfWeek(date).add(const Duration(days: 6));
    return DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);
  }

  List<model.Task> get currentWeekTasks {
    final now = DateTime.now();
    final start = _startOfWeek(now);
    final end = _endOfWeek(now);

    return _allTasks.where((t) {
      final d = t.deadline;
      return !d.isBefore(start) && !d.isAfter(end);
    }).toList();
  }

  List<model.Task> get previousWeekTasks {
    final now = DateTime.now();
    final start = _startOfWeek(now).subtract(const Duration(days: 7));
    final end = _endOfWeek(now).subtract(const Duration(days: 7));

    return _allTasks.where((t) {
      final d = t.deadline;
      return !d.isBefore(start) && !d.isAfter(end);
    }).toList();
  }

  int get completedCountCurrentWeek =>
      currentWeekTasks.where((t) => t.isDone).length;

  int get totalCountCurrentWeek => currentWeekTasks.length;

  int get completedCountPreviousWeek =>
      previousWeekTasks.where((t) => t.isDone).length;

  int get totalCountPreviousWeek => previousWeekTasks.length;
}
