import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuestRecommendationWidget extends StatelessWidget {
  final Function(Map<String, dynamic>) onQuestAssigned;

  const QuestRecommendationWidget({
    Key? key,
    required this.onQuestAssigned,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> recommendedQuests = [
      {
        'id': 'quest_001',
        'title': 'Critical Thinking Challenge',
        'description':
            'Analyze real-world scenarios and propose innovative solutions using structured thinking frameworks.',
        'difficulty': 'Medium',
        'estimatedTime': '45 minutes',
        'skillsTargeted': ['Critical Thinking', 'Problem Solving'],
        'nepAlignment': 'NEP 2020 - 21st Century Skills',
        'ageGroup': 'Grades 6-8',
        'category': 'Thinking Skills',
        'xpReward': 150,
        'badgeReward': 'Critical Thinker',
        'icon': 'psychology',
        'color': AppTheme.lightTheme.colorScheme.primary,
      },
      {
        'id': 'quest_002',
        'title': 'Team Collaboration Project',
        'description':
            'Work together to solve environmental challenges in your community through collaborative planning.',
        'difficulty': 'Easy',
        'estimatedTime': '60 minutes',
        'skillsTargeted': ['Team Collaboration', 'Communication'],
        'nepAlignment': 'NEP 2020 - Collaborative Learning',
        'ageGroup': 'Grades 4-6',
        'category': 'Social Skills',
        'xpReward': 120,
        'badgeReward': 'Team Player',
        'icon': 'groups',
        'color': AppTheme.lightTheme.colorScheme.secondary,
      },
      {
        'id': 'quest_003',
        'title': 'Digital Literacy Explorer',
        'description':
            'Navigate the digital world safely while learning about online ethics and digital citizenship.',
        'difficulty': 'Hard',
        'estimatedTime': '90 minutes',
        'skillsTargeted': ['Digital Literacy', 'Ethics'],
        'nepAlignment': 'NEP 2020 - Digital Education',
        'ageGroup': 'Grades 8-10',
        'category': 'Technology',
        'xpReward': 200,
        'badgeReward': 'Digital Citizen',
        'icon': 'computer',
        'color': AppTheme.lightTheme.colorScheme.tertiary,
      },
      {
        'id': 'quest_004',
        'title': 'Creative Expression Workshop',
        'description':
            'Express your ideas through various creative mediums while developing artistic and innovative thinking.',
        'difficulty': 'Medium',
        'estimatedTime': '75 minutes',
        'skillsTargeted': ['Creative Thinking', 'Self Expression'],
        'nepAlignment': 'NEP 2020 - Arts Integration',
        'ageGroup': 'Grades 5-9',
        'category': 'Creative Skills',
        'xpReward': 175,
        'badgeReward': 'Creative Genius',
        'icon': 'palette',
        'color': AppTheme.lightTheme.colorScheme.secondary,
      },
    ];

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
                iconName: 'auto_awesome',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'AI Quest Recommendations',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'NEP 2020 aligned challenges tailored for your class',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          SizedBox(
            height: 45.h,
            child: ListView.separated(
              itemCount: recommendedQuests.length,
              separatorBuilder: (context, index) => SizedBox(height: 2.h),
              itemBuilder: (context, index) {
                final quest = recommendedQuests[index];
                return _buildQuestCard(context, quest);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestCard(BuildContext context, Map<String, dynamic> quest) {
    final title = quest['title'] as String? ?? '';
    final description = quest['description'] as String? ?? '';
    final difficulty = quest['difficulty'] as String? ?? '';
    final estimatedTime = quest['estimatedTime'] as String? ?? '';
    final skillsTargeted = quest['skillsTargeted'] as List<dynamic>? ?? [];
    final nepAlignment = quest['nepAlignment'] as String? ?? '';
    final ageGroup = quest['ageGroup'] as String? ?? '';
    final category = quest['category'] as String? ?? '';
    final xpReward = quest['xpReward'] as int? ?? 0;
    final badgeReward = quest['badgeReward'] as String? ?? '';
    final iconName = quest['icon'] as String? ?? 'assignment';
    final color =
        quest['color'] as Color? ?? AppTheme.lightTheme.colorScheme.primary;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: color,
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      category,
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(difficulty).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  difficulty,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: _getDifficultyColor(difficulty),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            description,
            style: AppTheme.lightTheme.textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 1.w,
            runSpacing: 0.5.h,
            children: skillsTargeted.map((skill) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  skill.toString(),
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'schedule',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                estimatedTime,
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              SizedBox(width: 4.w),
              CustomIconWidget(
                iconName: 'school',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  ageGroup,
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'verified',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  nepAlignment,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'star',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '$xpReward XP',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 2.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'military_tech',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      badgeReward,
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => onQuestAssigned(quest),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                ),
                child: const Text('Assign'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'medium':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'hard':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }
}
