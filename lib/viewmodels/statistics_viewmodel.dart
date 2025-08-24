import 'package:flutter/foundation.dart';
import '../services/task_service.dart';
import '../models/task_model.dart' as model;

class StatsViewModel extends ChangeNotifier {
  final TaskService _taskService;

  List<model.Task> _allTasks = [];

  StatsViewModel(this._taskService) {
    _observeTasks();
  }

  void _observeTasks() {
    _taskService.watchAllTasksSorted().listen((tasks) {
      _allTasks =
          tasks.map((t) {
            return model.Task(
              id: t.id,
              title: t.title,
              category: model.TaskCategory.values[t.category],
              deadline: t.deadline,
              note: t.note,
              isDone: t.isDone,
            );
          }).toList();

      notifyListeners();
    });
  }

  List<model.Task> get currentWeekTasks {
    final now = DateTime.now();
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(
      const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
    );

    return _allTasks.where((t) {
      final d = t.deadline;
      return !d.isBefore(startOfWeek) && !d.isAfter(endOfWeek);
    }).toList();
  }

  List<model.Task> get previousWeekTasks {
    final now = DateTime.now();
    final startOfPrevWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1 + 7));
    final endOfPrevWeek = startOfPrevWeek.add(
      const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
    );

    return _allTasks.where((t) {
      final d = t.deadline;
      return !d.isBefore(startOfPrevWeek) && !d.isAfter(endOfPrevWeek);
    }).toList();
  }

  int get completedCountCurrentWeek =>
      currentWeekTasks.where((t) => t.isDone).length;

  int get totalCountCurrentWeek => currentWeekTasks.length;

  int get completedCountPreviousWeek =>
      previousWeekTasks.where((t) => t.isDone).length;

  int get totalCountPreviousWeek => previousWeekTasks.length;
}
