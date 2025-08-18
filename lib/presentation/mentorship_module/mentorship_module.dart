import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/feedback_form_widget.dart';
import './widgets/mentor_card_widget.dart';
import './widgets/mentor_filter_widget.dart';
import './widgets/mentor_profile_widget.dart';
import './widgets/session_booking_widget.dart';
import './widgets/session_history_widget.dart';

class MentorshipModule extends StatefulWidget {
  const MentorshipModule({Key? key}) : super(key: key);

  @override
  State<MentorshipModule> createState() => _MentorshipModuleState();
}

class _MentorshipModuleState extends State<MentorshipModule>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  Map<String, dynamic> _currentFilters = {
    "careerField": "All Fields",
    "language": "All Languages",
    "availability": "All",
    "minRating": 0.0,
  };

  List<Map<String, dynamic>> _filteredMentors = [];
  bool _isLoading = false;

  // Mock data for mentors
  final List<Map<String, dynamic>> _allMentors = [
    {
      "id": 1,
      "name": "Dr. Priya Sharma",
      "expertise": "Software Engineering",
      "bio":
          "Senior Software Engineer at Google with 8+ years of experience in mobile app development.",
      "fullBio":
          "Dr. Priya Sharma is a Senior Software Engineer at Google with over 8 years of experience in mobile app development and system design. She has mentored 100+ students and helped them land jobs at top tech companies. Her expertise includes Flutter, React Native, and backend development.",
      "image":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face",
      "rating": 4.8,
      "reviewCount": 127,
      "languages": ["English", "Hindi", "Tamil"],
      "isAvailable": true,
      "specializations": [
        "Mobile Development",
        "System Design",
        "Career Guidance",
        "Interview Prep"
      ],
      "experience": [
        {
          "position": "Senior Software Engineer",
          "company": "Google",
          "duration": "2019 - Present"
        },
        {
          "position": "Software Engineer",
          "company": "Microsoft",
          "duration": "2016 - 2019"
        }
      ],
      "recentReviews": [
        {
          "studentName": "Arjun K.",
          "rating": 5,
          "comment":
              "Amazing session! Dr. Sharma helped me understand system design concepts clearly.",
          "date": "2 days ago"
        },
        {
          "studentName": "Sneha R.",
          "rating": 5,
          "comment":
              "Very patient and knowledgeable. Great career advice for tech industry.",
          "date": "1 week ago"
        }
      ]
    },
    {
      "id": 2,
      "name": "Dr. Rajesh Kumar",
      "expertise": "Data Science & AI",
      "bio":
          "AI Research Scientist at IIT Delhi with expertise in machine learning and data analytics.",
      "fullBio":
          "Dr. Rajesh Kumar is an AI Research Scientist at IIT Delhi with a PhD in Computer Science. He has published 50+ research papers and has been working in the field of artificial intelligence for over 10 years. He specializes in machine learning, deep learning, and data science applications.",
      "image":
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop&crop=face",
      "rating": 4.9,
      "reviewCount": 89,
      "languages": ["English", "Hindi", "Bengali"],
      "isAvailable": true,
      "specializations": [
        "Machine Learning",
        "Data Science",
        "Research",
        "Academic Guidance"
      ],
      "experience": [
        {
          "position": "AI Research Scientist",
          "company": "IIT Delhi",
          "duration": "2018 - Present"
        },
        {
          "position": "Data Scientist",
          "company": "Flipkart",
          "duration": "2015 - 2018"
        }
      ],
      "recentReviews": [
        {
          "studentName": "Meera P.",
          "rating": 5,
          "comment":
              "Excellent explanation of ML algorithms. Very helpful for my research project.",
          "date": "3 days ago"
        }
      ]
    },
    {
      "id": 3,
      "name": "Ms. Anita Desai",
      "expertise": "Digital Marketing",
      "bio":
          "Marketing Director at Unilever with 12+ years in brand management and digital strategy.",
      "fullBio":
          "Ms. Anita Desai is the Marketing Director at Unilever with over 12 years of experience in brand management, digital marketing, and consumer insights. She has led successful campaigns for major brands and has expertise in social media marketing, content strategy, and market research.",
      "image":
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=400&fit=crop&crop=face",
      "rating": 4.7,
      "reviewCount": 156,
      "languages": ["English", "Hindi", "Gujarati"],
      "isAvailable": false,
      "specializations": [
        "Digital Marketing",
        "Brand Management",
        "Social Media",
        "Content Strategy"
      ],
      "experience": [
        {
          "position": "Marketing Director",
          "company": "Unilever",
          "duration": "2020 - Present"
        },
        {
          "position": "Brand Manager",
          "company": "Procter & Gamble",
          "duration": "2016 - 2020"
        }
      ],
      "recentReviews": [
        {
          "studentName": "Karan S.",
          "rating": 5,
          "comment":
              "Great insights into digital marketing trends. Very practical advice.",
          "date": "5 days ago"
        }
      ]
    },
    {
      "id": 4,
      "name": "Dr. Vikram Singh",
      "expertise": "Mechanical Engineering",
      "bio":
          "Principal Engineer at ISRO with expertise in aerospace and mechanical systems design.",
      "fullBio":
          "Dr. Vikram Singh is a Principal Engineer at ISRO with over 15 years of experience in aerospace engineering and mechanical systems design. He has worked on several satellite missions and has expertise in CAD design, thermal analysis, and project management.",
      "image":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face",
      "rating": 4.6,
      "reviewCount": 73,
      "languages": ["English", "Hindi", "Punjabi"],
      "isAvailable": true,
      "specializations": [
        "Aerospace Engineering",
        "CAD Design",
        "Project Management",
        "Research"
      ],
      "experience": [
        {
          "position": "Principal Engineer",
          "company": "ISRO",
          "duration": "2015 - Present"
        },
        {
          "position": "Senior Engineer",
          "company": "HAL",
          "duration": "2009 - 2015"
        }
      ],
      "recentReviews": [
        {
          "studentName": "Rohit M.",
          "rating": 4,
          "comment":
              "Good technical knowledge. Helped me with my engineering project.",
          "date": "1 week ago"
        }
      ]
    }
  ];

  // Mock session history data
  final List<Map<String, dynamic>> _sessionHistory = [
    {
      "id": 1,
      "mentorId": 1,
      "mentorName": "Dr. Priya Sharma",
      "mentorImage":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face",
      "mentorExpertise": "Software Engineering",
      "date": "15 Aug 2025",
      "time": "10:00 AM",
      "duration": 60,
      "sessionType": "Career Guidance",
      "status": "completed",
      "rating": 5,
      "notes":
          "Discussed career path in software engineering. Got valuable insights about industry trends and skill requirements."
    },
    {
      "id": 2,
      "mentorId": 2,
      "mentorName": "Dr. Rajesh Kumar",
      "mentorImage":
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop&crop=face",
      "mentorExpertise": "Data Science & AI",
      "date": "20 Aug 2025",
      "time": "02:00 PM",
      "duration": 60,
      "sessionType": "Skill Development",
      "status": "upcoming",
      "notes": ""
    },
    {
      "id": 3,
      "mentorId": 3,
      "mentorName": "Ms. Anita Desai",
      "mentorImage":
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=400&fit=crop&crop=face",
      "mentorExpertise": "Digital Marketing",
      "date": "10 Aug 2025",
      "time": "04:00 PM",
      "duration": 60,
      "sessionType": "Interview Preparation",
      "status": "cancelled",
      "notes": ""
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _filteredMentors = List.from(_allMentors);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _filteredMentors = _allMentors.where((mentor) {
          // Career field filter
          if (_currentFilters["careerField"] != "All Fields") {
            if (!(mentor["expertise"] as String).toLowerCase().contains(
                _currentFilters["careerField"].toString().toLowerCase())) {
              return false;
            }
          }

          // Language filter
          if (_currentFilters["language"] != "All Languages") {
            if (!(mentor["languages"] as List)
                .contains(_currentFilters["language"])) {
              return false;
            }
          }

          // Rating filter
          if ((mentor["rating"] as double) <
              (_currentFilters["minRating"] as double)) {
            return false;
          }

          // Availability filter
          if (_currentFilters["availability"] == "Available Now") {
            if (!(mentor["isAvailable"] as bool)) {
              return false;
            }
          }

          // Search filter
          if (_searchController.text.isNotEmpty) {
            final searchTerm = _searchController.text.toLowerCase();
            if (!(mentor["name"] as String)
                    .toLowerCase()
                    .contains(searchTerm) &&
                !(mentor["expertise"] as String)
                    .toLowerCase()
                    .contains(searchTerm)) {
              return false;
            }
          }

          return true;
        }).toList();
        _isLoading = false;
      });
    });
  }

  void _showMentorProfile(Map<String, dynamic> mentorData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MentorProfileWidget(
        mentorData: mentorData,
        onBookSession: () {
          Navigator.pop(context);
          _showSessionBooking(mentorData);
        },
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  void _showSessionBooking(Map<String, dynamic> mentorData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SessionBookingWidget(
        mentorData: mentorData,
        onBookingConfirmed: () {
          // Add to session history
          setState(() {
            _sessionHistory.insert(0, {
              "id": _sessionHistory.length + 1,
              "mentorId": mentorData["id"],
              "mentorName": mentorData["name"],
              "mentorImage": mentorData["image"],
              "mentorExpertise": mentorData["expertise"],
              "date": "25 Aug 2025",
              "time": "03:00 PM",
              "duration": 60,
              "sessionType": "Career Guidance",
              "status": "upcoming",
              "notes": ""
            });
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "Session booked successfully with ${mentorData["name"]}!"),
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            ),
          );
        },
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  void _showFeedbackForm(Map<String, dynamic> sessionData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FeedbackFormWidget(
        sessionData: sessionData,
        onFeedbackSubmitted: (feedbackData) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Thank you for your feedback!"),
            ),
          );
        },
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MentorFilterWidget(
        currentFilters: _currentFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _currentFilters = filters;
          });
          _applyFilters();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Mentorship",
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to notifications
            },
            icon: CustomIconWidget(
              iconName: 'notifications',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          SizedBox(width: 2.w),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Find Mentors"),
            Tab(text: "My Sessions"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFindMentorsTab(),
          _buildMySessionsTab(),
        ],
      ),
    );
  }

  Widget _buildFindMentorsTab() {
    return Column(
      children: [
        // Search and Filter Section
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search mentors by name or expertise...",
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _applyFilters();
                          },
                          icon: CustomIconWidget(
                            iconName: 'clear',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                ),
                onChanged: (value) {
                  setState(() {});
                  _applyFilters();
                },
              ),

              SizedBox(height: 2.h),

              // Filter Button and Active Filters
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _showFilterBottomSheet,
                      icon: CustomIconWidget(
                        iconName: 'filter_list',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      label: Text(
                        "Filters",
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        side: BorderSide(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${_filteredMentors.length} mentors",
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Mentors List
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredMentors.isEmpty
                  ? _buildEmptyState()
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Featured Mentors Carousel
                          Text(
                            "Featured Mentors",
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Container(
                            height: 35.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _filteredMentors.take(3).length,
                              itemBuilder: (context, index) {
                                final mentor = _filteredMentors[index];
                                return MentorCardWidget(
                                  mentorData: mentor,
                                  onTap: () => _showMentorProfile(mentor),
                                );
                              },
                            ),
                          ),

                          SizedBox(height: 3.h),

                          // All Mentors List
                          Text(
                            "All Mentors",
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _filteredMentors.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 2.h),
                            itemBuilder: (context, index) {
                              final mentor = _filteredMentors[index];
                              return _buildMentorListItem(mentor);
                            },
                          ),
                        ],
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _buildMentorListItem(Map<String, dynamic> mentor) {
    return GestureDetector(
      onTap: () => _showMentorProfile(mentor),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CustomImageWidget(
                imageUrl: mentor["image"] as String,
                width: 16.w,
                height: 16.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          mentor["name"] as String,
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: mentor["isAvailable"] as bool
                              ? AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.1)
                              : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          mentor["isAvailable"] as bool ? "Available" : "Busy",
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: mentor["isAvailable"] as bool
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    mentor["expertise"] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    mentor["bio"] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'star',
                        color: Colors.amber,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        "${(mentor["rating"] as double).toStringAsFixed(1)} (${mentor["reviewCount"]} reviews)",
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        (mentor["languages"] as List).take(2).join(", "),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMySessionsTab() {
    return SessionHistoryWidget(
      sessionHistory: _sessionHistory,
      onSessionTap: (session) {
        if (session["status"] == "completed" && session["rating"] == null) {
          _showFeedbackForm(session);
        }
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                .withValues(alpha: 0.5),
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            "No mentors found",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "Try adjusting your search or filters\nto find the perfect mentor",
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 3.h),
          OutlinedButton(
            onPressed: () {
              setState(() {
                _currentFilters = {
                  "careerField": "All Fields",
                  "language": "All Languages",
                  "availability": "All",
                  "minRating": 0.0,
                };
                _searchController.clear();
              });
              _applyFilters();
            },
            child: Text("Clear Filters"),
          ),
        ],
      ),
    );
  }
}
