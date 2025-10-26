import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/task.dart';
import 'auth_providers.dart';
import '../../models/app_user.dart';

class TaskRepository extends StateNotifier<List<Task>> {
  final Ref _ref;
  ProviderSubscription<AppUser?>? _authSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _taskSub;

  TaskRepository(this._ref) : super([]) {
    // React to auth changes to attach/detach Firestore listener
    _authSub = _ref.listen<AppUser?>(authNotifierProvider, (prev, next) {
      _bindTasksStream(next?.id);
    });
    final current = _ref.read(authNotifierProvider);
    _bindTasksStream(current?.id);
  }

  void _bindTasksStream(String? userId) {
    _taskSub?.cancel();
    state = [];
    if (userId == null || userId.isEmpty) return;
    final query = FirebaseFirestore.instance
        .collection('tasks')
        .where('userId', isEqualTo: userId);
    _taskSub = query.snapshots().listen((snapshot) {
      final tasks = snapshot.docs.map((doc) {
        final data = doc.data();
        return Task.fromMap(data, doc.id);
      }).toList()
        ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
      state = tasks;
    });
  }

  Future<void> createTask(Task task) async {
    final doc = FirebaseFirestore.instance.collection('tasks').doc(task.id);
    await doc.set(task.toMap());
  }

  Future<void> updateTask(Task task) async {
    final doc = FirebaseFirestore.instance.collection('tasks').doc(task.id);
    await doc.update(task.toMap());
  }

  Future<void> deleteTask(String taskId) async {
    final doc = FirebaseFirestore.instance.collection('tasks').doc(taskId);
    await doc.delete();
  }

  @override
  void dispose() {
    _taskSub?.cancel();
    _authSub?.close();
    super.dispose();
  }
}

final taskRepositoryProvider =
    StateNotifierProvider<TaskRepository, List<Task>>((ref) {
      return TaskRepository(ref);
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
