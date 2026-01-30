// lib/screens/progress_tracking_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../constants/constants.dart';
import '../models/program_model.dart';

class ProgressTrackingScreen extends StatefulWidget {
  final String? programId;

  const ProgressTrackingScreen({super.key, this.programId});

  @override
  State<ProgressTrackingScreen> createState() => _ProgressTrackingScreenState();
}

class _ProgressTrackingScreenState extends State<ProgressTrackingScreen> {
  String _selectedTimeRange = 'Last 30 Days';
  final List<String> _timeRanges = [
    'Last 7 Days',
    'Last 30 Days',
    'Last 3 Months',
    'All Time'
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final enrollments = provider.enrollments;

    // If specific program ID is provided, filter enrollments
    final filteredEnrollments = widget.programId != null
        ? enrollments.where((e) => e.programId == widget.programId).toList()
        : enrollments;

    final overallProgress = _calculateOverallProgress(filteredEnrollments);
    final timeSpentData = _generateTimeSpentData();
    const totalLearningHours = 156;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.programId != null
            ? 'Progress Tracking'
            : 'Learning Analytics'),
        backgroundColor: AppConstants.primaryColor,
        actions: [
          DropdownButton<String>(
            value: _selectedTimeRange,
            items: _timeRanges.map((range) {
              return DropdownMenuItem(
                value: range,
                child: Text(range),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedTimeRange = value!);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Overall Progress Summary
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Overall Learning Progress',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CircularProgressIndicator(
                        value: overallProgress,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        strokeWidth: 10,
                        semanticsLabel: 'Overall Progress',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${(overallProgress * 100).toStringAsFixed(1)}% Complete',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${filteredEnrollments.length} ${widget.programId != null ? 'modules' : 'courses'} in progress',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Time Spent Chart
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Time Spent Learning',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total: $totalLearningHours hours',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: _buildSimpleBarChart(timeSpentData),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Course-wise Progress
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Course-wise Progress',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (filteredEnrollments.isEmpty)
                        const Center(
                          child: Text(
                            'No enrollment data available',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      else
                        Column(
                          children: filteredEnrollments.map((enrollment) {
                            final programId = enrollment is Map 
                                ? enrollment['programId']?.toString() 
                                : enrollment.programId?.toString();
                            final program = provider.programs.firstWhere(
                              (p) => p.id == programId,
                              orElse: () => provider.programs.isNotEmpty 
                                  ? provider.programs.first 
                                  : Program(
                                      id: '0',
                                      title: 'Unknown Program',
                                      description: '',
                                      category: 'General',
                                      duration: 0,
                                      difficulty: 'Beginner',
                                      skills: [],
                                      modules: [],
                                      provider: '',
                                      startDate: DateTime.now(),
                                      endDate: DateTime.now(),
                                    ),
                            );

                            return _buildCourseProgressCard(enrollment, program);
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Weekly Goals
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Weekly Learning Goals',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildGoalProgress(
                        title: 'Complete 5 modules',
                        completed: 3,
                        total: 5,
                        color: Colors.blue,
                      ),
                      _buildGoalProgress(
                        title: 'Spend 10 hours learning',
                        completed: 7,
                        total: 10,
                        color: Colors.green,
                      ),
                      _buildGoalProgress(
                        title: 'Score 80%+ on quizzes',
                        completed: 4,
                        total: 5,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Achievements
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recent Achievements',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildAchievementBadge(
                            icon: Icons.flash_on,
                            title: 'Fast Learner',
                            description: 'Completed 5 modules in 3 days',
                            color: Colors.amber,
                          ),
                          _buildAchievementBadge(
                            icon: Icons.star,
                            title: 'Quiz Master',
                            description: 'Scored 100% on 3 quizzes',
                            color: Colors.purple,
                          ),
                          _buildAchievementBadge(
                            icon: Icons.timer,
                            title: 'Consistent Learner',
                            description: '7-day learning streak',
                            color: Colors.green,
                          ),
                          _buildAchievementBadge(
                            icon: Icons.workspace_premium,
                            title: 'Course Completer',
                            description: 'Finished 2 courses',
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Statistics Grid
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _buildStatCard(
                    title: 'Avg. Daily Time',
                    value: '2.5 hours',
                    icon: Icons.access_time,
                    color: Colors.blue,
                  ),
                  _buildStatCard(
                    title: 'Active Days',
                    value: '24/30',
                    icon: Icons.calendar_today,
                    color: Colors.green,
                  ),
                  _buildStatCard(
                    title: 'Avg. Score',
                    value: '87.5%',
                    icon: Icons.score,
                    color: Colors.orange,
                  ),
                  _buildStatCard(
                    title: 'Completion Rate',
                    value: '65%',
                    icon: Icons.trending_up,
                    color: Colors.purple,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseProgressCard(dynamic enrollment, Program? program) {
    if (program == null) return const SizedBox.shrink();
    
    // Extract enrollment data
    final progress = enrollment is Map 
        ? (enrollment['progress'] ?? 0.0).toDouble() 
        : enrollment.progress?.toDouble() ?? 0.0;
    final isCompleted = enrollment is Map 
        ? enrollment['isCompleted'] ?? false 
        : enrollment.isCompleted ?? false;
    final enrollmentDate = enrollment is Map 
        ? (enrollment['enrolledAt'] is DateTime 
            ? enrollment['enrolledAt'] 
            : DateTime.now())
        : enrollment.enrolledAt ?? DateTime.now();
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppConstants.categoryColors[program.category]
                        ?.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    AppConstants.categoryIcons[program.category],
                    color: AppConstants.categoryColors[program.category],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        program.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        program.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppConstants.categoryColors[program.category],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                isCompleted ? Colors.green : Colors.blue,
              ),
              minHeight: 6,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isCompleted ? 'Completed' : 'In Progress',
                  style: TextStyle(
                    fontSize: 12,
                    color: isCompleted ? Colors.green : Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Started: ${_formatDateShort(enrollmentDate)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalProgress({
    required String title,
    required int completed,
    required int total,
    required Color color,
  }) {
    final progress = completed / total;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                '$completed/$total',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          const SizedBox(height: 4),
          Text(
            '${(progress * 100).toStringAsFixed(0)}% complete',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: color),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  double _calculateOverallProgress(List<dynamic> enrollments) {
    if (enrollments.isEmpty) return 0.0;
    final totalProgress = enrollments.fold(0.0, (sum, enrollment) {
      final progress = enrollment is Map 
          ? (enrollment['progress'] ?? 0.0).toDouble() 
          : enrollment.progress?.toDouble() ?? 0.0;
      return sum + progress;
    });
    return totalProgress / enrollments.length;
  }

  List<Map<String, dynamic>> _generateTimeSpentData() {
    // Mock data - in real app, fetch from API
    return [
      {'day': 'Mon', 'hours': 2.5},
      {'day': 'Tue', 'hours': 3.0},
      {'day': 'Wed', 'hours': 1.5},
      {'day': 'Thu', 'hours': 2.0},
      {'day': 'Fri', 'hours': 4.0},
      {'day': 'Sat', 'hours': 2.5},
      {'day': 'Sun', 'hours': 1.0},
    ];
  }

  String _formatDateShort(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildSimpleBarChart(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    final maxHours = data.map((d) => d['hours'] as num).reduce((a, b) => a > b ? a : b).toDouble();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: data.map((item) {
          final hours = (item['hours'] as num).toDouble();
          final day = item['day'] as String;
          final height = maxHours > 0 ? (hours / maxHours) * 150 : 0.0;
          
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: height,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: height > 20
                        ? Center(
                            child: Text(
                              hours.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    day,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
