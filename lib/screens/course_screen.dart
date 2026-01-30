// lib/screens/course_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/program_model.dart';
import '../models/enrollment_model.dart';
import 'program_detail_screen.dart';

class CourseScreen extends StatefulWidget {
  final String? programId;

  const CourseScreen({super.key, this.programId});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  Program? _program;
  Enrollment? _enrollment;
  bool _isLoading = true;
  int _selectedModuleIndex = 0;
  double _currentProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCourseData();
  }

  Future<void> _loadCourseData() async {
    final provider = Provider.of<AppProvider>(context, listen: false);

    try {
      if (widget.programId != null) {
        _program = await provider.getProgramById(widget.programId!);

        if (provider.isLearner && provider.userId != null) {
          final enrollments = provider.enrollments;
          _enrollment = enrollments.firstWhere(
            (e) => e.programId == widget.programId,
            orElse: () => Enrollment(
              id: '',
              programId: '',
              learnerId: '',
              enrolledAt: DateTime.now(),
              enrolledDate: DateTime.now(),
            ),
          );
          _currentProgress = _enrollment?.progress ?? 0.0;
        }
      }
    } catch (e) {
      // Handle error
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateProgress(double newProgress) async {
    final provider = Provider.of<AppProvider>(context, listen: false);

    if (_enrollment != null && _enrollment!.id.isNotEmpty) {
      await provider.updateEnrollmentProgress(_enrollment!.id, newProgress);
      setState(() => _currentProgress = newProgress);
    }
  }

  void _markModuleComplete() {
    if (_program == null || _program!.modules.isEmpty) return;

    final totalModules = _program!.modules.length;
    final moduleProgress = 1.0 / totalModules;
    final newProgress = (_currentProgress + moduleProgress).clamp(0.0, 1.0);

    _updateProgress(newProgress);

    // Move to next module if available
    if (_selectedModuleIndex < totalModules - 1) {
      setState(() => _selectedModuleIndex++);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Module marked as complete!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _completeCourse() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Course'),
        content: const Text(
            'Are you sure you want to mark this course as complete?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateProgress(1.0);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Course completed successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Complete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final program = _program; // Capture in local variable for type promotion

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (program == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Course Not Found')),
        body: const Center(
          child: Text('The requested course could not be found.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(program.title),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProgramDetailScreen(
                    program: program,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Header
          if (provider.isLearner)
            Container(
              padding: const EdgeInsets.all(16),
              color: Color.fromARGB(255, 227, 242, 253),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your Progress',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${(_currentProgress * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _currentProgress,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    minHeight: 8,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(program.modules.length * _currentProgress).toInt()} of ${program.modules.length} modules completed',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

          // Course Content
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: TabBar(
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.blue,
                      tabs: const [
                        Tab(text: 'Modules'),
                        Tab(text: 'Resources'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Modules Tab
                        _buildModulesTab(),
                        // Resources Tab
                        _buildResourcesTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: provider.isLearner && _enrollment != null
          ? _buildLearnerBottomBar()
          : null,
    );
  }

  Widget _buildModulesTab() {
    final program = _program;
    if (program == null || program.modules.isEmpty) {
      return const Center(
        child: Text('No modules available for this course.'),
      );
    }

    return Column(
      children: [
        // Module List
        Expanded(
          child: ListView.builder(
            itemCount: program.modules.length,
            itemBuilder: (context, index) {
              final module = program.modules[index];
              final isCompleted =
                  index < (_currentProgress * program.modules.length);
              final isCurrent = index == _selectedModuleIndex;

              return Card(
                margin: const EdgeInsets.all(8),
                color: isCurrent ? Color.fromARGB(255, 227, 242, 253) : null,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isCompleted ? Colors.green : Colors.grey,
                    child: Icon(
                      isCompleted ? Icons.check : Icons.school,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    'Module ${index + 1}: $module',
                    style: TextStyle(
                      fontWeight:
                          isCurrent ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    isCompleted ? 'Completed' : 'Not started',
                    style: TextStyle(
                      color: isCompleted ? Colors.green : Colors.grey,
                    ),
                  ),
                  trailing: isCurrent
                      ? const Icon(Icons.arrow_forward, color: Colors.blue)
                      : null,
                  onTap: () {
                    setState(() => _selectedModuleIndex = index);
                  },
                ),
              );
            },
          ),
        ),

        // Current Module Content
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey.shade50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Module ${_selectedModuleIndex + 1}: ${_program?.modules[_selectedModuleIndex] ?? 'Unknown'}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'This is the content for the current module. In a real app, this would include videos, readings, quizzes, and assignments.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              // Sample content items
              _buildContentItem(Icons.video_library, 'Video Lecture (15 min)'),
              _buildContentItem(Icons.article, 'Reading Material'),
              _buildContentItem(Icons.quiz, 'Quiz (5 questions)'),
              _buildContentItem(Icons.assignment, 'Assignment'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContentItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildResourcesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Course Resources',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 16),
        _buildResourceCard(
          'Course Syllabus',
          'Download the complete course syllabus',
          Icons.description,
        ),
        _buildResourceCard(
          'E-Book',
          'Digital textbook for this course',
          Icons.menu_book,
        ),
        _buildResourceCard(
          'Code Examples',
          'Downloadable code samples',
          Icons.code,
        ),
        _buildResourceCard(
          'Additional Readings',
          'Recommended articles and papers',
          Icons.library_books,
        ),
        _buildResourceCard(
          'Project Templates',
          'Starter templates for final project',
          Icons.folder,
        ),
        const SizedBox(height: 16),
        const Text(
          'Instructor Materials',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        _buildResourceCard(
          'Lecture Slides',
          'PowerPoint presentations',
          Icons.slideshow,
        ),
        _buildResourceCard(
          'Assignment Solutions',
          'Solutions to practice problems',
          Icons.assignment_turned_in,
        ),
      ],
    );
  }

  Widget _buildResourceCard(String title, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 227, 242, 253),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(description),
        trailing: IconButton(
          icon: const Icon(Icons.download, color: Colors.blue),
          onPressed: () {
            // Download functionality
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Downloading $title...'),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLearnerBottomBar() {
    final isCompleted = _currentProgress >= 1.0;
    final currentModule = _selectedModuleIndex + 1;
    final totalModules = _program!.modules.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          if (!isCompleted)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _markModuleComplete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.check_circle, size: 20),
                label: const Text('Mark Module Complete'),
              ),
            ),
          if (!isCompleted) const SizedBox(width: 12),
          if (!isCompleted && currentModule == totalModules)
            ElevatedButton(
              onPressed: _completeCourse,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Complete Course'),
            ),
          if (isCompleted)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // View certificate
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Certificate would be shown here'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.verified, size: 20),
                label: const Text('View Certificate'),
              ),
            ),
        ],
      ),
    );
  }
}
