import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/task.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/providers/task_providers.dart';
import '../../core/providers/auth_providers.dart';
import '../widgets/task_item.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/filter_bottom_sheet.dart';

class TasksScreen extends ConsumerStatefulWidget {
  final VoidCallback onLogout;

  const TasksScreen({super.key, required this.onLogout});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  TaskFilter _currentFilter = TaskFilter();
  TaskPriority? _selectedPriority;
  TaskStatus? _selectedStatus;

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => FilterBottomSheet(
        selectedPriority: _selectedPriority,
        selectedStatus: _selectedStatus,
        onPrioritySelected: (priority) {
          setState(() {
            _selectedPriority = priority;
            _currentFilter = TaskFilter(
              priority: priority,
              status: _selectedStatus,
            );
          });
          Navigator.pop(context);
        },
        onStatusSelected: (status) {
          setState(() {
            _selectedStatus = status;
            _currentFilter = TaskFilter(
              priority: _selectedPriority,
              status: status,
            );
          });
          Navigator.pop(context);
        },
        onClearFilter: () {
          setState(() {
            _selectedPriority = null;
            _selectedStatus = null;
            _currentFilter = TaskFilter();
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        onSave: (title, description, dueDate, priority, type) async {
          final user = ref.read(authNotifierProvider);
          if (user == null) return;

          final task = Task(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            userId: user.id,
            title: title,
            description: description,
            dueDate: dueDate,
            priority: priority,
            status: TaskStatus.pending,
            type: type,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          final repository = ref.read(taskRepositoryProvider.notifier);
          await repository.createTask(task);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = ref.watch(filteredTasksProvider(_currentFilter));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () {},
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const TextField(
                              decoration: InputDecoration(
                                hintText: 'Search tasks...',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('EEEE, d MMMM').format(DateTime.now()),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const Text(
                            AppStrings.myTasks,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Filter Chip
            if (_selectedPriority != null || _selectedStatus != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (_selectedPriority != null)
                        Chip(
                          label: Text(_getPriorityString(_selectedPriority!)),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            setState(() {
                              _selectedPriority = null;
                              _currentFilter = TaskFilter(
                                priority: null,
                                status: _selectedStatus,
                              );
                            });
                          },
                        ),
                      if (_selectedStatus != null) ...[
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(_getStatusString(_selectedStatus!)),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            setState(() {
                              _selectedStatus = null;
                              _currentFilter = TaskFilter(
                                priority: _selectedPriority,
                                status: null,
                              );
                            });
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            // Task List
            Expanded(
              child: filteredTasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.task_alt,
                            size: 80,
                            color: AppColors.textSecondary.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No tasks found',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _buildTaskList(filteredTasks),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: _showFilterSheet,
            ),
            const SizedBox(width: 48),
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  void _toggleTaskComplete(Task task) {
    final repository = ref.read(taskRepositoryProvider.notifier);
    final updatedTask = task.copyWith(
      status: task.status == TaskStatus.completed
          ? TaskStatus.pending
          : TaskStatus.completed,
      updatedAt: DateTime.now(),
    );
    repository.updateTask(updatedTask);
  }

  void _deleteTask(Task task) {
    final repository = ref.read(taskRepositoryProvider.notifier);
    repository.deleteTask(task.id);
  }

  void _showEditTaskDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        task: task,
        onSave: (title, description, dueDate, priority, type) async {
          final updatedTask = task.copyWith(
            title: title,
            description: description,
            dueDate: dueDate,
            priority: priority,
            type: type,
            updatedAt: DateTime.now(),
          );

          final repository = ref.read(taskRepositoryProvider.notifier);
          await repository.updateTask(updatedTask);
        },
      ),
    );
  }

  String _getPriorityString(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return AppStrings.low;
      case TaskPriority.medium:
        return AppStrings.medium;
      case TaskPriority.high:
        return AppStrings.high;
    }
  }

  String _getStatusString(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return AppStrings.pending;
      case TaskStatus.completed:
        return AppStrings.completed;
    }
  }

  Widget _buildTaskList(List<Task> tasks) {
    final todayTasks = tasks.where((task) => _isToday(task.dueDate)).toList();
    final tomorrowTasks = tasks
        .where((task) => _isTomorrow(task.dueDate))
        .toList();
    final weekTasks = tasks
        .where((task) => !_isToday(task.dueDate) && !_isTomorrow(task.dueDate))
        .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (todayTasks.isNotEmpty) ...[
          _buildSectionHeader(AppStrings.today),
          ...todayTasks.map(
            (task) => TaskItem(
              task: task,
              onTap: () => _showEditTaskDialog(task),
              onToggleComplete: () => _toggleTaskComplete(task),
              onDelete: () => _deleteTask(task),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (tomorrowTasks.isNotEmpty) ...[
          _buildSectionHeader(AppStrings.tomorrow),
          ...tomorrowTasks.map(
            (task) => TaskItem(
              task: task,
              onTap: () => _showEditTaskDialog(task),
              onToggleComplete: () => _toggleTaskComplete(task),
              onDelete: () => _deleteTask(task),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (weekTasks.isNotEmpty) ...[
          _buildSectionHeader(AppStrings.thisWeek),
          ...weekTasks.map(
            (task) => TaskItem(
              task: task,
              onTap: () => _showEditTaskDialog(task),
              onToggleComplete: () => _toggleTaskComplete(task),
              onDelete: () => _deleteTask(task),
            ),
          ),
        ],
      ],
    );
  }
}
