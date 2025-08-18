import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AssignmentCreationWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onAssignmentCreated;

  const AssignmentCreationWidget({
    Key? key,
    required this.onAssignmentCreated,
  }) : super(key: key);

  @override
  State<AssignmentCreationWidget> createState() =>
      _AssignmentCreationWidgetState();
}

class _AssignmentCreationWidgetState extends State<AssignmentCreationWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedModule = 'Critical Thinking';
  String _selectedDifficulty = 'Medium';
  DateTime _selectedDueDate = DateTime.now().add(const Duration(days: 7));

  final List<String> _modules = [
    'Critical Thinking',
    'Communication Skills',
    'Problem Solving',
    'Team Collaboration',
    'Leadership',
    'Time Management',
    'Creative Thinking',
    'Digital Literacy',
  ];

  final List<String> _difficulties = ['Easy', 'Medium', 'Hard', 'Expert'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _createAssignment() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter assignment title')),
      );
      return;
    }

    final assignment = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'module': _selectedModule,
      'difficulty': _selectedDifficulty,
      'dueDate': _selectedDueDate.toIso8601String(),
      'createdAt': DateTime.now().toIso8601String(),
    };

    widget.onAssignmentCreated(assignment);
    _resetForm();
  }

  void _resetForm() {
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedModule = 'Critical Thinking';
      _selectedDifficulty = 'Medium';
      _selectedDueDate = DateTime.now().add(const Duration(days: 7));
    });
  }

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDueDate) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'assignment',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Create Assignment',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Assignment Title',
              hintText: 'Enter assignment title',
            ),
            maxLines: 1,
          ),
          SizedBox(height: 2.h),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description (Optional)',
              hintText: 'Enter assignment description',
            ),
            maxLines: 3,
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Module',
                      style: AppTheme.lightTheme.textTheme.labelLarge,
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedModule,
                          isExpanded: true,
                          items: _modules.map((String module) {
                            return DropdownMenuItem<String>(
                              value: module,
                              child: Text(
                                module,
                                style: AppTheme.lightTheme.textTheme.bodyMedium,
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedModule = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Difficulty',
                      style: AppTheme.lightTheme.textTheme.labelLarge,
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedDifficulty,
                          isExpanded: true,
                          items: _difficulties.map((String difficulty) {
                            return DropdownMenuItem<String>(
                              value: difficulty,
                              child: Text(
                                difficulty,
                                style: AppTheme.lightTheme.textTheme.bodyMedium,
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedDifficulty = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Due Date',
                style: AppTheme.lightTheme.textTheme.labelLarge,
              ),
              SizedBox(height: 1.h),
              GestureDetector(
                onTap: _selectDueDate,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'calendar_today',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '${_selectedDueDate.day}/${_selectedDueDate.month}/${_selectedDueDate.year}',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _resetForm,
                  child: const Text('Reset'),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _createAssignment,
                  child: const Text('Create Assignment'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
