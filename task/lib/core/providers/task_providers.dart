import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/task.dart';
import 'auth_providers.dart';

class TaskRepository extends StateNotifier<List<Task>> {
  static const _storageKey = 'tasks_v1';

  TaskRepository() : super([]) {
    _loadTasks();
  }

  Future<void> createTask(Task task) async {
    final newState = List<Task>.from(state)..add(task);
    state = newState;
    await _saveTasks();
  }

  Future<void> updateTask(Task task) async {
    final newState = List<Task>.from(state);
    final index = newState.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      newState[index] = task;
      state = newState;
      await _saveTasks();
    }
  }

  Future<void> deleteTask(String taskId) async {
    final newState = List<Task>.from(state);
    newState.removeWhere((t) => t.id == taskId);
    state = newState;
    await _saveTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_storageKey);
    if (jsonStr == null) return;
    try {
      final List<dynamic> decoded = jsonDecode(jsonStr) as List<dynamic>;
      final tasks = decoded.map((e) {
        final map = Map<String, dynamic>.from(e as Map);
        final id = map['id'] as String? ?? '';
        return Task.fromMap(map, id);
      }).toList();
      state = tasks;
    } catch (_) {
      // ignore parse errors
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final list = state.map((t) => {
          'id': t.id,
          ...t.toMap(),
        }).toList();
    await prefs.setString(_storageKey, jsonEncode(list));
  }
}

final taskRepositoryProvider =
    StateNotifierProvider<TaskRepository, List<Task>>((ref) {
      return TaskRepository();
    });

final tasksProvider = Provider<List<Task>>((ref) {
  final user = ref.watch(authNotifierProvider);
  final tasks = ref.watch(taskRepositoryProvider);

  if (user == null) {
    return [];
  }

  return tasks.where((t) => t.userId == user.id).toList()
    ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
});

final filteredTasksProvider = Provider.family<List<Task>, TaskFilter>((
  ref,
  filter,
) {
  final tasks = ref.watch(tasksProvider);

  List<Task> filteredTasks = List.from(tasks);

  if (filter.status != null) {
    filteredTasks = filteredTasks
        .where((task) => task.status == filter.status)
        .toList();
  }

  if (filter.priority != null) {
    filteredTasks = filteredTasks
        .where((task) => task.priority == filter.priority)
        .toList();
  }

  return filteredTasks;
});

class TaskFilter {
  final TaskStatus? status;
  final TaskPriority? priority;

  TaskFilter({this.status, this.priority});
}
