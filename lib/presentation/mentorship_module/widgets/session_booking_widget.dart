import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SessionBookingWidget extends StatefulWidget {
  final Map<String, dynamic> mentorData;
  final VoidCallback onBookingConfirmed;
  final VoidCallback onClose;

  const SessionBookingWidget({
    Key? key,
    required this.mentorData,
    required this.onBookingConfirmed,
    required this.onClose,
  }) : super(key: key);

  @override
  State<SessionBookingWidget> createState() => _SessionBookingWidgetState();
}

class _SessionBookingWidgetState extends State<SessionBookingWidget> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlot;
  String _sessionType = "Career Guidance";
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _questionsController = TextEditingController();

  final List<String> _sessionTypes = [
    "Career Guidance",
    "Skill Development",
    "Interview Preparation",
    "Project Review",
    "General Mentorship",
  ];

  final List<String> _timeSlots = [
    "09:00 AM",
    "10:00 AM",
    "11:00 AM",
    "02:00 PM",
    "03:00 PM",
    "04:00 PM",
    "05:00 PM",
    "06:00 PM",
  ];

  @override
  void dispose() {
    _goalController.dispose();
    _questionsController.dispose();
    super.dispose();
  }

  bool _isSlotAvailable(String timeSlot) {
    // Mock availability logic - in real app, this would check mentor's calendar
    final unavailableSlots = ["10:00 AM", "03:00 PM"];
    return !unavailableSlots.contains(timeSlot);
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
                    iconName: 'arrow_back',
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
                        "Book Session",
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "with ${widget.mentorData["name"]}",
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
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
                  // Session Type Selection
                  _buildSection(
                    title: "Session Type",
                    child: Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: _sessionTypes.map((type) {
                        final isSelected = _sessionType == type;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _sessionType = type;
                            });
                          },
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
                              type,
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

                  // Date Selection
                  _buildSection(
                    title: "Select Date",
                    child: Container(
                      height: 12.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 14, // Next 14 days
                        itemBuilder: (context, index) {
                          final date =
                              DateTime.now().add(Duration(days: index));
                          final isSelected = _selectedDate.day == date.day &&
                              _selectedDate.month == date.month;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDate = date;
                                _selectedTimeSlot = null; // Reset time slot
                              });
                            },
                            child: Container(
                              width: 16.w,
                              margin: EdgeInsets.only(right: 2.w),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme.surface,
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : AppTheme.lightTheme.colorScheme.outline,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    [
                                      "Sun",
                                      "Mon",
                                      "Tue",
                                      "Wed",
                                      "Thu",
                                      "Fri",
                                      "Sat"
                                    ][date.weekday % 7],
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: isSelected
                                          ? Colors.white
                                          : AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    date.day.toString(),
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      color: isSelected
                                          ? Colors.white
                                          : AppTheme
                                              .lightTheme.colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Time Slot Selection
                  _buildSection(
                    title: "Available Time Slots",
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2.5,
                        crossAxisSpacing: 2.w,
                        mainAxisSpacing: 1.h,
                      ),
                      itemCount: _timeSlots.length,
                      itemBuilder: (context, index) {
                        final timeSlot = _timeSlots[index];
                        final isAvailable = _isSlotAvailable(timeSlot);
                        final isSelected = _selectedTimeSlot == timeSlot;

                        return GestureDetector(
                          onTap: isAvailable
                              ? () {
                                  setState(() {
                                    _selectedTimeSlot = timeSlot;
                                  });
                                }
                              : null,
                          child: Container(
                            decoration: BoxDecoration(
                              color: !isAvailable
                                  ? AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.1)
                                  : isSelected
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : AppTheme.lightTheme.colorScheme.surface,
                              border: Border.all(
                                color: !isAvailable
                                    ? AppTheme
                                        .lightTheme.colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.3)
                                    : isSelected
                                        ? AppTheme
                                            .lightTheme.colorScheme.primary
                                        : AppTheme
                                            .lightTheme.colorScheme.outline,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                timeSlot,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: !isAvailable
                                      ? AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant
                                          .withValues(alpha: 0.5)
                                      : isSelected
                                          ? Colors.white
                                          : AppTheme
                                              .lightTheme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Session Goal
                  _buildSection(
                    title: "Session Goal (Optional)",
                    child: TextField(
                      controller: _goalController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText:
                            "What do you hope to achieve in this session?",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                  // Preparation Questions
                  _buildSection(
                    title: "Questions to Discuss (Optional)",
                    child: TextField(
                      controller: _questionsController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText:
                            "List any specific questions you'd like to ask...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                  // Session Details Summary
                  if (_selectedTimeSlot != null)
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Session Summary",
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          _buildSummaryRow("Type", _sessionType),
                          _buildSummaryRow("Date",
                              "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}"),
                          _buildSummaryRow("Time", _selectedTimeSlot!),
                          _buildSummaryRow("Duration", "60 minutes"),
                          _buildSummaryRow("Platform", "Video Call"),
                        ],
                      ),
                    ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Book Button
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
                onPressed: _selectedTimeSlot != null
                    ? () {
                        widget.onBookingConfirmed();
                        Navigator.pop(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Confirm Booking",
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

  Widget _buildSection({
    required String title,
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
        SizedBox(height: 1.5.h),
        child,
        SizedBox(height: 3.h),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
