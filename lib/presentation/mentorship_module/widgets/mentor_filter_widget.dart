import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MentorFilterWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onFiltersChanged;
  final Map<String, dynamic> currentFilters;

  const MentorFilterWidget({
    Key? key,
    required this.onFiltersChanged,
    required this.currentFilters,
  }) : super(key: key);

  @override
  State<MentorFilterWidget> createState() => _MentorFilterWidgetState();
}

class _MentorFilterWidgetState extends State<MentorFilterWidget> {
  late Map<String, dynamic> _filters;

  final List<String> _careerFields = [
    "All Fields",
    "Technology",
    "Healthcare",
    "Engineering",
    "Business",
    "Arts & Design",
    "Education",
    "Science",
    "Sports",
  ];

  final List<String> _languages = [
    "All Languages",
    "English",
    "Hindi",
    "Tamil",
    "Telugu",
    "Bengali",
    "Marathi",
    "Gujarati",
  ];

  final List<String> _availability = [
    "All",
    "Available Now",
    "This Week",
    "Next Week",
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  void _updateFilter(String key, dynamic value) {
    setState(() {
      _filters[key] = value;
    });
    widget.onFiltersChanged(_filters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Filter Mentors",
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _filters = {
                      "careerField": "All Fields",
                      "language": "All Languages",
                      "availability": "All",
                      "minRating": 0.0,
                    };
                  });
                  widget.onFiltersChanged(_filters);
                },
                child: Text(
                  "Clear All",
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Career Field Filter
          _buildFilterSection(
            title: "Career Field",
            child: Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: _careerFields.map((field) {
                final isSelected = _filters["careerField"] == field;
                return GestureDetector(
                  onTap: () => _updateFilter("careerField", field),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
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
                      field,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
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

          // Language Filter
          _buildFilterSection(
            title: "Language",
            child: DropdownButtonFormField<String>(
              value: _filters["language"] as String,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                ),
              ),
              items: _languages.map((language) {
                return DropdownMenuItem(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  _updateFilter("language", value);
                }
              },
            ),
          ),

          // Availability Filter
          _buildFilterSection(
            title: "Availability",
            child: Column(
              children: _availability.map((option) {
                final isSelected = _filters["availability"] == option;
                return RadioListTile<String>(
                  title: Text(
                    option,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  value: option,
                  groupValue: _filters["availability"] as String,
                  onChanged: (value) {
                    if (value != null) {
                      _updateFilter("availability", value);
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                );
              }).toList(),
            ),
          ),

          // Rating Filter
          _buildFilterSection(
            title: "Minimum Rating",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Slider(
                  value: (_filters["minRating"] as double),
                  min: 0.0,
                  max: 5.0,
                  divisions: 10,
                  label: (_filters["minRating"] as double).toStringAsFixed(1),
                  onChanged: (value) => _updateFilter("minRating", value),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "0.0",
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    Text(
                      "${(_filters["minRating"] as double).toStringAsFixed(1)} stars & above",
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "5.0",
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Apply Filters",
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
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
        SizedBox(height: 1.h),
        child,
        SizedBox(height: 2.h),
      ],
    );
  }
}
