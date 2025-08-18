import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InterestAssessmentWidget extends StatefulWidget {
  final Function(List<String>) onInterestsSelected;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const InterestAssessmentWidget({
    Key? key,
    required this.onInterestsSelected,
    required this.onNext,
    required this.onSkip,
  }) : super(key: key);

  @override
  State<InterestAssessmentWidget> createState() =>
      _InterestAssessmentWidgetState();
}

class _InterestAssessmentWidgetState extends State<InterestAssessmentWidget>
    with TickerProviderStateMixin {
  List<String> selectedInterests = [];
  late AnimationController _emojiController;

  final List<Map<String, dynamic>> interestCategories = [
    {
      'emoji': '🎨',
      'title': 'Arts & Creativity',
      'interests': ['Painting', 'Music', 'Theater', 'Photography', 'Design'],
    },
    {
      'emoji': '🔬',
      'title': 'Science & Discovery',
      'interests': ['Experiments', 'Space', 'Animals', 'Nature', 'Inventions'],
    },
    {
      'emoji': '💻',
      'title': 'Technology',
      'interests': ['Coding', 'Robotics', 'Gaming', 'Apps', 'AI'],
    },
    {
      'emoji': '⚽',
      'title': 'Sports & Fitness',
      'interests': ['Football', 'Cricket', 'Basketball', 'Swimming', 'Yoga'],
    },
    {
      'emoji': '📚',
      'title': 'Learning & Reading',
      'interests': ['Books', 'History', 'Languages', 'Writing', 'Research'],
    },
    {
      'emoji': '🎭',
      'title': 'Entertainment',
      'interests': ['Movies', 'Dancing', 'Comedy', 'Magic', 'Singing'],
    },
    {
      'emoji': '🌍',
      'title': 'World & Culture',
      'interests': ['Travel', 'Geography', 'Cultures', 'Food', 'Festivals'],
    },
    {
      'emoji': '🤝',
      'title': 'Helping Others',
      'interests': [
        'Volunteering',
        'Teaching',
        'Environment',
        'Community',
        'Animals'
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _emojiController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _emojiController.dispose();
    super.dispose();
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        selectedInterests.add(interest);
      }
    });
    widget.onInterestsSelected(selectedInterests);
    _emojiController.forward().then((_) => _emojiController.reverse());
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
              // Header
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.secondary
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '❤️',
                      style: TextStyle(fontSize: 8.w),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'What Do You Love?',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 1.h),

              Text(
                'Choose the things that make you excited and happy! Select as many as you like.',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),

              SizedBox(height: 3.h),

              // Selected interests counter
              if (selectedInterests.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '💖',
                        style: TextStyle(fontSize: 4.w),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '${selectedInterests.length} interests selected',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 2.h),

              // Interest categories
              Expanded(
                child: ListView.separated(
                  itemCount: interestCategories.length,
                  separatorBuilder: (context, index) => SizedBox(height: 3.h),
                  itemBuilder: (context, categoryIndex) {
                    final category = interestCategories[categoryIndex];

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
                          // Category header with emoji
                          Row(
                            children: [
                              AnimatedBuilder(
                                animation: _emojiController,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: 1.0 + (_emojiController.value * 0.2),
                                    child: Container(
                                      padding: EdgeInsets.all(2.w),
                                      decoration: BoxDecoration(
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        category['emoji'],
                                        style: TextStyle(fontSize: 8.w),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Text(
                                  category['title'],
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 2.h),

                          // Interests grid with emoji reactions
                          Wrap(
                            spacing: 2.w,
                            runSpacing: 1.h,
                            children: (category['interests'] as List<String>)
                                .map((interest) {
                              final isSelected =
                                  selectedInterests.contains(interest);

                              return GestureDetector(
                                onTap: () => _toggleInterest(interest),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? LinearGradient(
                                            colors: [
                                              AppTheme.lightTheme.colorScheme
                                                  .secondary,
                                              AppTheme.lightTheme.colorScheme
                                                  .secondary
                                                  .withValues(alpha: 0.8),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
                                        : null,
                                    color: isSelected
                                        ? null
                                        : AppTheme
                                            .lightTheme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppTheme
                                              .lightTheme.colorScheme.secondary
                                          : AppTheme
                                              .lightTheme.colorScheme.outline,
                                      width: isSelected ? 2 : 1,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: AppTheme.lightTheme
                                                  .colorScheme.secondary
                                                  .withValues(alpha: 0.4),
                                              blurRadius: 12,
                                              offset: const Offset(0, 6),
                                            ),
                                          ]
                                        : [
                                            BoxShadow(
                                              color: AppTheme
                                                  .lightTheme.colorScheme.shadow
                                                  .withValues(alpha: 0.1),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        interest,
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
                                        SizedBox(width: 2.w),
                                        Text(
                                          '😍',
                                          style: TextStyle(fontSize: 4.w),
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
                          onPressed: selectedInterests.isNotEmpty
                              ? widget.onNext
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppTheme.lightTheme.colorScheme.secondary,
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
