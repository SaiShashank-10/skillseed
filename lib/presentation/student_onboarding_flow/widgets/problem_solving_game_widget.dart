import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProblemSolvingGameWidget extends StatefulWidget {
  final Function(int) onScoreCalculated;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const ProblemSolvingGameWidget({
    Key? key,
    required this.onScoreCalculated,
    required this.onNext,
    required this.onSkip,
  }) : super(key: key);

  @override
  State<ProblemSolvingGameWidget> createState() =>
      _ProblemSolvingGameWidgetState();
}

class _ProblemSolvingGameWidgetState extends State<ProblemSolvingGameWidget>
    with TickerProviderStateMixin {
  int currentQuestion = 0;
  int score = 0;
  bool gameCompleted = false;
  late AnimationController _celebrationController;
  late AnimationController _progressController;

  final List<Map<String, dynamic>> puzzleQuestions = [
    {
      'type': 'pattern',
      'question': 'What comes next in this pattern?',
      'pattern': ['🔴', '🔵', '🔴', '🔵', '🔴', '?'],
      'options': ['🔴', '🔵', '🟡', '🟢'],
      'correct': 1,
      'explanation': 'The pattern alternates between red and blue circles!',
    },
    {
      'type': 'logic',
      'question': 'If 2 apples cost ₹10, how much do 6 apples cost?',
      'options': ['₹20', '₹30', '₹40', '₹50'],
      'correct': 1,
      'explanation': '2 apples = ₹10, so 1 apple = ₹5, and 6 apples = ₹30',
    },
    {
      'type': 'spatial',
      'question': 'Which shape completes the puzzle?',
      'image':
          'https://images.pexels.com/photos/5428836/pexels-photo-5428836.jpeg?auto=compress&cs=tinysrgb&w=800',
      'options': ['Triangle', 'Square', 'Circle', 'Star'],
      'correct': 2,
      'explanation': 'The missing piece is a circle to complete the pattern!',
    },
    {
      'type': 'math',
      'question': 'What number is missing?',
      'sequence': ['2', '4', '6', '?', '10'],
      'options': ['7', '8', '9', '12'],
      'correct': 1,
      'explanation': 'The sequence increases by 2 each time: 2, 4, 6, 8, 10',
    },
    {
      'type': 'riddle',
      'question':
          'I have keys but no locks. I have space but no room. What am I?',
      'options': ['A piano', 'A keyboard', 'A map', 'A book'],
      'correct': 1,
      'explanation':
          'A keyboard has keys and space bar, but no physical locks or rooms!',
    },
  ];

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _selectAnswer(int selectedIndex) {
    final question = puzzleQuestions[currentQuestion];
    final isCorrect = selectedIndex == question['correct'];

    if (isCorrect) {
      score += 20;
      _celebrationController
          .forward()
          .then((_) => _celebrationController.reverse());
    }

    // Show explanation dialog
    _showExplanationDialog(isCorrect, question['explanation']);
  }

  void _showExplanationDialog(bool isCorrect, String explanation) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Result emoji and text
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: isCorrect
                    ? AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                isCorrect ? '🎉' : '🤔',
                style: TextStyle(fontSize: 12.w),
              ),
            ),

            SizedBox(height: 2.h),

            Text(
              isCorrect ? 'Awesome!' : 'Good try!',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: isCorrect
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 1.h),

            Text(
              explanation,
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),

            SizedBox(height: 3.h),

            SizedBox(
              width: 100.w,
              child: ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  currentQuestion < puzzleQuestions.length - 1
                      ? 'Next Question'
                      : 'See Results',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextQuestion() {
    Navigator.of(context).pop();

    if (currentQuestion < puzzleQuestions.length - 1) {
      setState(() {
        currentQuestion++;
      });
      _progressController.forward();
    } else {
      setState(() {
        gameCompleted = true;
      });
      widget.onScoreCalculated(score);
    }
  }

  Widget _buildPatternQuestion(Map<String, dynamic> question) {
    return Column(
      children: [
        // Pattern display
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: (question['pattern'] as List<String>).map((item) {
              return Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: item == '?'
                      ? AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: item == '?'
                      ? Border.all(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          width: 2,
                          style: BorderStyle.solid,
                        )
                      : null,
                ),
                child: Center(
                  child: Text(
                    item,
                    style: TextStyle(fontSize: 8.w),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSequenceQuestion(Map<String, dynamic> question) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: (question['sequence'] as List<String>).map((item) {
          return Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: item == '?'
                  ? AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: item == '?'
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline,
                width: item == '?' ? 2 : 1,
              ),
            ),
            child: Center(
              child: Text(
                item,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (gameCompleted) {
      return _buildResultsScreen();
    }

    final question = puzzleQuestions[currentQuestion];

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
              // Header with progress
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'psychology',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 8.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Brain Challenge',
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Question ${currentQuestion + 1} of ${puzzleQuestions.length}',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Score display
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.tertiary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'star',
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          size: 4.w,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '$score',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Progress bar
              Container(
                width: 100.w,
                height: 1.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (currentQuestion + 1) / puzzleQuestions.length,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 4.h),

              // Question content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question text
                    Text(
                      question['question'],
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Question-specific content
                    if (question['type'] == 'pattern')
                      _buildPatternQuestion(question)
                    else if (question['type'] == 'spatial' &&
                        question['image'] != null)
                      Container(
                        width: 100.w,
                        height: 25.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.lightTheme.colorScheme.shadow
                                  .withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CustomImageWidget(
                          imageUrl: question['image'],
                          width: 100.w,
                          height: 25.h,
                          fit: BoxFit.cover,
                        ),
                      )
                    else if (question['type'] == 'math')
                      _buildSequenceQuestion(question),

                    SizedBox(height: 4.h),

                    // Answer options
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 3.w,
                          mainAxisSpacing: 2.h,
                          childAspectRatio: 2.5,
                        ),
                        itemCount: (question['options'] as List<String>).length,
                        itemBuilder: (context, index) {
                          final option =
                              (question['options'] as List<String>)[index];

                          return GestureDetector(
                            onTap: () => _selectAnswer(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme
                                        .lightTheme.colorScheme.primary
                                        .withValues(alpha: 0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  option,
                                  textAlign: TextAlign.center,
                                  style: AppTheme
                                      .lightTheme.textTheme.titleSmall
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Skip button
              Container(
                width: 100.w,
                padding: EdgeInsets.symmetric(vertical: 2.h),
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
                    'Skip Brain Challenge',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsScreen() {
    final percentage = (score / (puzzleQuestions.length * 20) * 100).round();
    String resultMessage;
    String resultEmoji;

    if (percentage >= 80) {
      resultMessage = 'Amazing! You\'re a problem-solving superstar!';
      resultEmoji = '🌟';
    } else if (percentage >= 60) {
      resultMessage = 'Great job! You have excellent thinking skills!';
      resultEmoji = '🎉';
    } else if (percentage >= 40) {
      resultMessage = 'Good effort! Keep practicing to improve!';
      resultEmoji = '👍';
    } else {
      resultMessage = 'Nice try! Every challenge makes you stronger!';
      resultEmoji = '💪';
    }

    return Container(
      width: 100.w,
      height: 100.h,
      color: AppTheme.lightTheme.colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Result emoji
              AnimatedBuilder(
                animation: _celebrationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_celebrationController.value * 0.3),
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        resultEmoji,
                        style: TextStyle(fontSize: 20.w),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 4.h),

              // Score display
              Text(
                '$score / ${puzzleQuestions.length * 20}',
                style: AppTheme.lightTheme.textTheme.displaySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 1.h),

              Text(
                '$percentage% Correct',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),

              SizedBox(height: 3.h),

              // Result message
              Text(
                resultMessage,
                textAlign: TextAlign.center,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 6.h),

              // Continue button
              SizedBox(
                width: 80.w,
                height: 7.h,
                child: ElevatedButton(
                  onPressed: widget.onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary,
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
                        'Continue Journey',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                        iconName: 'arrow_forward',
                        color: Colors.white,
                        size: 5.w,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
