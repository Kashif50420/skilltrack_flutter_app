import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../constants/constants.dart';

class CourseContentScreen extends StatefulWidget {
  final String moduleId;
  final String moduleTitle;
  final String courseTitle;

  const CourseContentScreen({
    super.key,
    required this.moduleId,
    required this.moduleTitle,
    required this.courseTitle,
  });

  @override
  State<CourseContentScreen> createState() => _CourseContentScreenState();
}

class _CourseContentScreenState extends State<CourseContentScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  int _currentContentIndex = 0;
  bool _isVideoInitialized = false;
  double _videoProgress = 0.0;

  final List<Map<String, dynamic>> _contentItems = [
    {
      'type': 'video',
      'title': 'Introduction to Module',
      'duration': '15:30',
      'completed': true,
    },
    {
      'type': 'reading',
      'title': 'Chapter 1: Basic Concepts',
      'duration': '10 min read',
      'completed': true,
    },
    {
      'type': 'quiz',
      'title': 'Quick Quiz - Part 1',
      'duration': '5 questions',
      'completed': false,
    },
    {
      'type': 'assignment',
      'title': 'Practice Assignment',
      'duration': 'Submit by tomorrow',
      'completed': false,
    },
    {
      'type': 'video',
      'title': 'Advanced Concepts',
      'duration': '22:15',
      'completed': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'),
    );

    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
      allowFullScreen: true,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      placeholder: Container(color: Colors.black),
      autoInitialize: true,
    );

    setState(() => _isVideoInitialized = true);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentContent = _contentItems[_currentContentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.courseTitle,
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              widget.moduleTitle,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: Column(
        children: [
          // Content Navigation
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.grey.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _currentContentIndex > 0
                      ? () => _changeContent(-1)
                      : null,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '${_currentContentIndex + 1} of ${_contentItems.length}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _currentContentIndex < _contentItems.length - 1
                      ? () => _changeContent(1)
                      : null,
                ),
              ],
            ),
          ),

          // Main Content Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Content Title
                  Text(
                    currentContent['title'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        _getContentIcon(currentContent['type']),
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        currentContent['duration'],
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const Spacer(),
                      if (currentContent['completed'])
                        const Row(
                          children: [
                            Icon(Icons.check_circle,
                                size: 16, color: Colors.green),
                            SizedBox(width: 4),
                            Text('Completed',
                                style: TextStyle(color: Colors.green)),
                          ],
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Content based on type
                  Expanded(
                    child: _buildContentByType(currentContent),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  _buildActionButtons(currentContent),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildContentByType(Map<String, dynamic> content) {
    switch (content['type']) {
      case 'video':
        return _buildVideoContent();
      case 'reading':
        return _buildReadingContent();
      case 'quiz':
        return _buildQuizContent();
      case 'assignment':
        return _buildAssignmentContent();
      default:
        return const Center(child: Text('Content type not supported'));
    }
  }

  Widget _buildVideoContent() {
    if (!_isVideoInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: Chewie(controller: _chewieController!),
        ),
        const SizedBox(height: 16),
        _buildVideoControls(),
      ],
    );
  }

  Widget _buildVideoControls() {
    return Column(
      children: [
        // Progress Bar
        Slider(
          value: _videoProgress,
          onChanged: (value) {
            setState(() => _videoProgress = value);
            final duration = _videoPlayerController.value.duration;
            _videoPlayerController.seekTo(
              duration * value,
            );
          },
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Playback Speed
            DropdownButton<double>(
              value: 1.0,
              items: const [
                DropdownMenuItem(value: 0.5, child: Text('0.5x')),
                DropdownMenuItem(value: 0.75, child: Text('0.75x')),
                DropdownMenuItem(value: 1.0, child: Text('1.0x')),
                DropdownMenuItem(value: 1.25, child: Text('1.25x')),
                DropdownMenuItem(value: 1.5, child: Text('1.5x')),
                DropdownMenuItem(value: 2.0, child: Text('2.0x')),
              ],
              onChanged: (value) {
                _videoPlayerController.setPlaybackSpeed(value!);
              },
            ),

            // Captions Button
            IconButton(
              icon: const Icon(Icons.subtitles),
              onPressed: () {
                // Toggle captions
              },
            ),

            // Download Button
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
                // Download video
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReadingContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chapter Content',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
            'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
            'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris '
            'nisi ut aliquip ex ea commodo consequat.\n\n'
            'Duis aute irure dolor in reprehenderit in voluptate velit esse '
            'cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat '
            'cupidatat non proident, sunt in culpa qui officia deserunt mollit '
            'anim id est laborum.\n\n'
            'Sed ut perspiciatis unde omnis iste natus error sit voluptatem '
            'accusantium doloremque laudantium, totam rem aperiam, eaque ipsa '
            'quae ab illo inventore veritatis et quasi architecto beatae vitae '
            'dicta sunt explicabo.',
            style: TextStyle(fontSize: 16, height: 1.6),
          ),
          const SizedBox(height: 24),
          const Text(
            'Key Points',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ..._buildKeyPoints(),
        ],
      ),
    );
  }

  List<Widget> _buildKeyPoints() {
    return [
      '• Understanding basic concepts',
      '• Practical applications',
      '• Common mistakes to avoid',
      '• Best practices',
      '• Further reading suggestions',
    ]
        .map((point) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(point),
            ))
        .toList();
  }

  Widget _buildQuizContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quiz Instructions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'This quiz contains 5 multiple-choice questions.\n'
          'You need to score at least 80% to pass.\n'
          'You have unlimited attempts.',
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sample Question',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text('What is Flutter primarily used for?'),
                const SizedBox(height: 16),
                ..._buildQuizOptions(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Note: This is just a preview. Start quiz to attempt all questions.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  List<Widget> _buildQuizOptions() {
    return [
      'Mobile app development',
      'Web development',
      'Desktop applications',
      'All of the above',
    ]
        .map((option) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Radio(
                    value: option,
                    groupValue: null,
                    onChanged: (value) {},
                  ),
                  const SizedBox(width: 8),
                  Text(option),
                ],
              ),
            ))
        .toList();
  }

  Widget _buildAssignmentContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Assignment Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create a Simple Flutter App',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Create a Flutter app with the following features:\n'
                  '• Two screens with navigation\n'
                  '• State management using Provider\n'
                  '• API integration\n'
                  '• Local data persistence\n\n'
                  'Submit your GitHub repository link.',
                ),
                const SizedBox(height: 16),
                _buildRequirementItem('Deadline', 'Tomorrow, 11:59 PM'),
                _buildRequirementItem('Points', '100'),
                _buildRequirementItem('Format', 'GitHub Repository'),
                _buildRequirementItem('Grading', 'Rubric-based'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Submission',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter your submission link or text...',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: () {
                // Attach file
              },
            ),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildRequirementItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$title:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> content) {
    return Row(
      children: [
        if (!content['completed'])
          Expanded(
            child: ElevatedButton(
              onPressed: _markAsComplete,
              child: const Text('Mark as Complete'),
            ),
          ),
        if (content['completed'])
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              child: const Text('Review'),
            ),
          ),
        const SizedBox(width: 12),
        if (content['type'] == 'quiz')
          Expanded(
            child: ElevatedButton(
              onPressed: _startQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Start Quiz'),
            ),
          ),
        if (content['type'] == 'assignment')
          Expanded(
            child: ElevatedButton(
              onPressed: _submitAssignment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text('Submit'),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _currentContentIndex,
      onTap: (index) => setState(() => _currentContentIndex = index),
      items: _contentItems.map((content) {
        return BottomNavigationBarItem(
          icon: Icon(
            _getContentIcon(content['type']),
            color: content['completed'] ? Colors.green : Colors.grey,
          ),
          label: content['type'],
        );
      }).toList(),
    );
  }

  IconData _getContentIcon(String type) {
    switch (type) {
      case 'video':
        return Icons.videocam;
      case 'reading':
        return Icons.menu_book;
      case 'quiz':
        return Icons.quiz;
      case 'assignment':
        return Icons.assignment;
      default:
        return Icons.article;
    }
  }

  void _changeContent(int direction) {
    final newIndex = _currentContentIndex + direction;
    if (newIndex >= 0 && newIndex < _contentItems.length) {
      setState(() => _currentContentIndex = newIndex);

      // If switching to video content, reinitialize video
      if (_contentItems[newIndex]['type'] == 'video') {
        _initializeVideoPlayer();
      }
    }
  }

  void _markAsComplete() {
    setState(() {
      _contentItems[_currentContentIndex]['completed'] = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Content marked as complete!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _startQuiz() {
    // Navigate to quiz screen
  }

  void _submitAssignment() {
    // Submit assignment
  }
}
