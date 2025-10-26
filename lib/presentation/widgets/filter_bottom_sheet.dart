import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class FilterBottomSheet extends StatelessWidget {
  final TaskPriority? selectedPriority;
  final TaskStatus? selectedStatus;
  final Function(TaskPriority) onPrioritySelected;
  final Function(TaskStatus) onStatusSelected;
  final VoidCallback onClearFilter;

  const FilterBottomSheet({
    super.key,
    this.selectedPriority,
    this.selectedStatus,
    required this.onPrioritySelected,
    required this.onStatusSelected,
    required this.onClearFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.filter,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: onClearFilter,
                child: const Text(
                  'Clear',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Priority',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: TaskPriority.values.map((priority) {
              final isSelected = selectedPriority == priority;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onPrioritySelected(priority),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? _getPriorityColor(priority) : AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getPriorityString(priority),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text(
            'Status',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: TaskStatus.values.map((status) {
              final isSelected = selectedStatus == status;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onStatusSelected(status),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getStatusString(status),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return AppColors.priorityLow;
      case TaskPriority.medium:
        return AppColors.priorityMedium;
      case TaskPriority.high:
        return AppColors.priorityHigh;
    }
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
}

