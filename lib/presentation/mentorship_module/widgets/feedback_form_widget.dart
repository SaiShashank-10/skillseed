import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FeedbackFormWidget extends StatefulWidget {
  final Map<String, dynamic> sessionData;
  final Function(Map<String, dynamic>) onFeedbackSubmitted;
  final VoidCallback onClose;

  const FeedbackFormWidget({
    Key? key,
    required this.sessionData,
    required this.onFeedbackSubmitted,
    required this.onClose,
  }) : super(key: key);

  @override
  State<FeedbackFormWidget> createState() => _FeedbackFormWidgetState();
}

class _FeedbackFormWidgetState extends State<FeedbackFormWidget> {
  int _overallRating = 0;
  int _knowledgeRating = 0;
  int _communicationRating = 0;
  int _helpfulnessRating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _improvementController = TextEditingController();
  bool _wouldRecommend = true;
  final List<String> _selectedTags = [];

  final List<String> _feedbackTags = [
    "Very Helpful",
    "Clear Explanation",
    "Good Examples",
    "Patient",
    "Knowledgeable",
    "Inspiring",
    "Well Prepared",
    "Good Listener",
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    _improvementController.dispose();
    super.dispose();
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  bool _isFormValid() {
    return _overallRating > 0 &&
        _knowledgeRating > 0 &&
        _communicationRating > 0 &&
        _helpfulnessRating > 0;
  }

  void _submitFeedback() {
    if (!_isFormValid()) return;

    final feedbackData = {
      "sessionId": widget.sessionData["id"],
      "mentorId": widget.sessionData["mentorId"],
      "overallRating": _overallRating,
      "knowledgeRating": _knowledgeRating,
      "communicationRating": _communicationRating,
      "helpfulnessRating": _helpfulnessRating,
      "feedback": _feedbackController.text.trim(),
      "improvementSuggestions": _improvementController.text.trim(),
      "wouldRecommend": _wouldRecommend,
      "tags": _selectedTags,
      "submittedAt": DateTime.now().toIso8601String(),
    };

    widget.onFeedbackSubmitted(feedbackData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: widget.onClose,
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Session Feedback",
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Help us improve your mentorship experience",
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Session Summary
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: CustomImageWidget(
                            imageUrl:
                                widget.sessionData["mentorImage"] as String,
                            width: 12.w,
                            height: 12.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Session with ${widget.sessionData["mentorName"]}",
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                "${widget.sessionData["date"]} • ${widget.sessionData["time"]}",
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Overall Rating
                  _buildRatingSection(
                    title: "Overall Experience",
                    subtitle: "How would you rate this session overall?",
                    rating: _overallRating,
                    onRatingChanged: (rating) {
                      setState(() {
                        _overallRating = rating;
                      });
                    },
                  ),

                  // Knowledge Rating
                  _buildRatingSection(
                    title: "Mentor's Knowledge",
                    subtitle: "How knowledgeable was your mentor?",
                    rating: _knowledgeRating,
                    onRatingChanged: (rating) {
                      setState(() {
                        _knowledgeRating = rating;
                      });
                    },
                  ),

                  // Communication Rating
                  _buildRatingSection(
                    title: "Communication",
                    subtitle: "How clear was the mentor's communication?",
                    rating: _communicationRating,
                    onRatingChanged: (rating) {
                      setState(() {
                        _communicationRating = rating;
                      });
                    },
                  ),

                  // Helpfulness Rating
                  _buildRatingSection(
                    title: "Helpfulness",
                    subtitle: "How helpful was this session for you?",
                    rating: _helpfulnessRating,
                    onRatingChanged: (rating) {
                      setState(() {
                        _helpfulnessRating = rating;
                      });
                    },
                  ),

                  // Feedback Tags
                  _buildSection(
                    title: "What did you like most?",
                    subtitle: "Select all that apply",
                    child: Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: _feedbackTags.map((tag) {
                        final isSelected = _selectedTags.contains(tag);
                        return GestureDetector(
                          onTap: () => _toggleTag(tag),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.surface,
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme.outline,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tag,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // Written Feedback
                  _buildSection(
                    title: "Additional Feedback",
                    subtitle:
                        "Share your thoughts about the session (optional)",
                    child: TextField(
                      controller: _feedbackController,
                      maxLines: 4,
                      maxLength: 500,
                      decoration: InputDecoration(
                        hintText:
                            "What did you learn? How did the mentor help you?",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        counterText: "${_feedbackController.text.length}/500",
                      ),
                      onChanged: (value) {
                        setState(() {}); // Update counter
                      },
                    ),
                  ),

                  // Improvement Suggestions
                  _buildSection(
                    title: "Suggestions for Improvement",
                    subtitle:
                        "How could this session have been better? (optional)",
                    child: TextField(
                      controller: _improvementController,
                      maxLines: 3,
                      maxLength: 300,
                      decoration: InputDecoration(
                        hintText: "Any suggestions for the mentor or platform?",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        counterText:
                            "${_improvementController.text.length}/300",
                      ),
                      onChanged: (value) {
                        setState(() {}); // Update counter
                      },
                    ),
                  ),

                  // Recommendation
                  _buildSection(
                    title: "Would you recommend this mentor?",
                    subtitle: "Help other students find great mentors",
                    child: Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            title: Text(
                              "Yes, definitely!",
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                            value: true,
                            groupValue: _wouldRecommend,
                            onChanged: (value) {
                              setState(() {
                                _wouldRecommend = value ?? true;
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool>(
                            title: Text(
                              "Not really",
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                            value: false,
                            groupValue: _wouldRecommend,
                            onChanged: (value) {
                              setState(() {
                                _wouldRecommend = value ?? false;
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Submit Button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isFormValid() ? _submitFeedback : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Submit Feedback",
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection({
    required String title,
    required String subtitle,
    required int rating,
    required Function(int) onRatingChanged,
  }) {
    return _buildSection(
      title: title,
      subtitle: subtitle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          final starIndex = index + 1;
          return GestureDetector(
            onTap: () => onRatingChanged(starIndex),
            child: Container(
              padding: EdgeInsets.all(2.w),
              child: CustomIconWidget(
                iconName: 'star',
                color: starIndex <= rating
                    ? Colors.amber
                    : AppTheme.lightTheme.colorScheme.outline,
                size: 32,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          subtitle,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 1.5.h),
        child,
        SizedBox(height: 3.h),
      ],
    );
  }
}
