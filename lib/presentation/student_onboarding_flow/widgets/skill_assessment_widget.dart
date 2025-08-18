import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SkillAssessmentWidget extends StatefulWidget {
  final Function(List<String>) onSkillsSelected;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const SkillAssessmentWidget({
    Key? key,
    required this.onSkillsSelected,
    required this.onNext,
    required this.onSkip,
  }) : super(key: key);

  @override
  State<SkillAssessmentWidget> createState() => _SkillAssessmentWidgetState();
}

class _SkillAssessmentWidgetState extends State<SkillAssessmentWidget>
    with TickerProviderStateMixin {
  List<String> selectedSkills = [];
  late AnimationController _dragController;
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> skillCategories = [
    {
      'title': 'Creative Skills',
      'icon': 'palette',
      'color': const Color(0xFFE91E63),
      'skills': ['Drawing', 'Music', 'Writing', 'Dancing', 'Crafts'],
    },
    {
      'title': 'Problem Solving',
      'icon': 'psychology',
      'color': const Color(0xFF9C27B0),
      'skills': ['Math', 'Puzzles', 'Logic Games', 'Science', 'Building'],
    },
    {
      'title': 'Communication',
      'icon': 'chat',
      'color': const Color(0xFF2196F3),
      'skills': [
        'Speaking',
        'Storytelling',
        'Languages',
        'Presentation',
        'Debate'
      ],
    },
    {
      'title': 'Leadership',
      'icon': 'groups',
      'color': const Color(0xFF4CAF50),
      'skills': [
        'Team Work',
        'Organizing',
        'Helping Others',
        'Decision Making',
        'Planning'
      ],
    },
    {
      'title': 'Sports & Physical',
      'icon': 'sports_soccer',
      'color': const Color(0xFFFF9800),
      'skills': ['Football', 'Cricket', 'Running', 'Swimming', 'Yoga'],
    },
    {
      'title': 'Technology',
      'icon': 'computer',
      'color': const Color(0xFF607D8B),
      'skills': ['Coding', 'Gaming', 'Digital Art', 'Robotics', 'Apps'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _dragController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _dragController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleSkill(String skill) {
    setState(() {
      if (selectedSkills.contains(skill)) {
        selectedSkills.remove(skill);
      } else {
        selectedSkills.add(skill);
      }
    });
    widget.onSkillsSelected(selectedSkills);
    _dragController.forward().then((_) => _dragController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      color: AppTheme.lightTheme.colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with voice support
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'psychology',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 8.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'What Are You Good At?',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Voice support implementation would go here
                    },
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 + (_pulseController.value * 0.1),
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.secondary
                                  .withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: CustomIconWidget(
                              iconName: 'volume_up',
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              size: 5.w,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 1.h),

              Text(
                'Tap on the skills you enjoy or are good at. Don\'t worry, you can always change these later!',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),

              SizedBox(height: 3.h),

              // Selected skills counter
              if (selectedSkills.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${selectedSkills.length} skills selected',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              SizedBox(height: 2.h),

              // Skill categories
              Expanded(
                child: ListView.separated(
                  itemCount: skillCategories.length,
                  separatorBuilder: (context, index) => SizedBox(height: 3.h),
                  itemBuilder: (context, categoryIndex) {
                    final category = skillCategories[categoryIndex];

                    return Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.lightTheme.colorScheme.shadow
                                .withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category header
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  color: (category['color'] as Color)
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: CustomIconWidget(
                                  iconName: category['icon'],
                                  color: category['color'],
                                  size: 6.w,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                category['title'],
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 2.h),

                          // Skills grid
                          Wrap(
                            spacing: 2.w,
                            runSpacing: 1.h,
                            children: (category['skills'] as List<String>)
                                .map((skill) {
                              final isSelected = selectedSkills.contains(skill);

                              return GestureDetector(
                                onTap: () => _toggleSkill(skill),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4.w, vertical: 1.5.h),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? category['color']
                                        : AppTheme
                                            .lightTheme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? category['color']
                                          : AppTheme
                                              .lightTheme.colorScheme.outline,
                                      width: isSelected ? 2 : 1,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color:
                                                  (category['color'] as Color)
                                                      .withValues(alpha: 0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        skill,
                                        style: AppTheme
                                            .lightTheme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: isSelected
                                              ? Colors.white
                                              : AppTheme.lightTheme.colorScheme
                                                  .onSurface,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                        ),
                                      ),
                                      if (isSelected) ...[
                                        SizedBox(width: 1.w),
                                        CustomIconWidget(
                                          iconName: 'check_circle',
                                          color: Colors.white,
                                          size: 4.w,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Action buttons
              Container(
                width: 100.w,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Row(
                  children: [
                    // Skip button
                    Expanded(
                      child: SizedBox(
                        height: 6.h,
                        child: OutlinedButton(
                          onPressed: widget.onSkip,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.outline,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Skip for now',
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 4.w),

                    // Continue button
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 6.h,
                        child: ElevatedButton(
                          onPressed:
                              selectedSkills.isNotEmpty ? widget.onNext : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppTheme.lightTheme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Continue',
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              CustomIconWidget(
                                iconName: 'arrow_forward',
                                color: Colors.white,
                                size: 4.w,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
