import 'package:flutter/material.dart';
import '../../constants/constants.dart';

class AdminLearnersScreen extends StatefulWidget {
  const AdminLearnersScreen({super.key});

  @override
  State<AdminLearnersScreen> createState() => _AdminLearnersScreenState();
}

class _AdminLearnersScreenState extends State<AdminLearnersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String _searchQuery = '';

  // 20 Learners Data
  final List<Map<String, dynamic>> _allLearners = [
    {
      'id': '1',
      'name': 'John Doe',
      'email': 'john.doe@email.com',
      'progress': 75,
      'status': 'Active',
      'joined': 'Jan 15, 2024',
      'courses': 3,
    },
    {
      'id': '2',
      'name': 'Sarah Smith',
      'email': 'sarah.smith@email.com',
      'progress': 100,
      'status': 'Completed',
      'joined': 'Dec 20, 2023',
      'courses': 2,
    },
    {
      'id': '3',
      'name': 'Alex Johnson',
      'email': 'alex.johnson@email.com',
      'progress': 10,
      'status': 'Struggling',
      'joined': 'Jan 1, 2024',
      'courses': 1,
    },
    {
      'id': '4',
      'name': 'Maria Garcia',
      'email': 'maria.garcia@email.com',
      'progress': 85,
      'status': 'Active',
      'joined': 'Nov 10, 2023',
      'courses': 4,
    },
    {
      'id': '5',
      'name': 'David Brown',
      'email': 'david.brown@email.com',
      'progress': 60,
      'status': 'Active',
      'joined': 'Feb 5, 2024',
      'courses': 2,
    },
    {
      'id': '6',
      'name': 'Emily Wilson',
      'email': 'emily.wilson@email.com',
      'progress': 95,
      'status': 'Completed',
      'joined': 'Oct 15, 2023',
      'courses': 5,
    },
    {
      'id': '7',
      'name': 'Michael Chen',
      'email': 'michael.chen@email.com',
      'progress': 45,
      'status': 'Active',
      'joined': 'Jan 20, 2024',
      'courses': 2,
    },
    {
      'id': '8',
      'name': 'Jessica Martinez',
      'email': 'jessica.martinez@email.com',
      'progress': 30,
      'status': 'Struggling',
      'joined': 'Feb 1, 2024',
      'courses': 1,
    },
    {
      'id': '9',
      'name': 'Robert Taylor',
      'email': 'robert.taylor@email.com',
      'progress': 100,
      'status': 'Completed',
      'joined': 'Sep 1, 2023',
      'courses': 6,
    },
    {
      'id': '10',
      'name': 'Lisa Anderson',
      'email': 'lisa.anderson@email.com',
      'progress': 80,
      'status': 'Active',
      'joined': 'Dec 5, 2023',
      'courses': 3,
    },
    {
      'id': '11',
      'name': 'James White',
      'email': 'james.white@email.com',
      'progress': 55,
      'status': 'Active',
      'joined': 'Jan 10, 2024',
      'courses': 2,
    },
    {
      'id': '12',
      'name': 'Amanda Lee',
      'email': 'amanda.lee@email.com',
      'progress': 90,
      'status': 'Active',
      'joined': 'Nov 20, 2023',
      'courses': 4,
    },
    {
      'id': '13',
      'name': 'Christopher Harris',
      'email': 'christopher.harris@email.com',
      'progress': 25,
      'status': 'Struggling',
      'joined': 'Feb 10, 2024',
      'courses': 1,
    },
    {
      'id': '14',
      'name': 'Michelle Clark',
      'email': 'michelle.clark@email.com',
      'progress': 100,
      'status': 'Completed',
      'joined': 'Aug 15, 2023',
      'courses': 5,
    },
    {
      'id': '15',
      'name': 'Daniel Lewis',
      'email': 'daniel.lewis@email.com',
      'progress': 70,
      'status': 'Active',
      'joined': 'Dec 1, 2023',
      'courses': 3,
    },
    {
      'id': '16',
      'name': 'Jennifer Walker',
      'email': 'jennifer.walker@email.com',
      'progress': 50,
      'status': 'Active',
      'joined': 'Jan 25, 2024',
      'courses': 2,
    },
    {
      'id': '17',
      'name': 'Matthew Hall',
      'email': 'matthew.hall@email.com',
      'progress': 100,
      'status': 'Completed',
      'joined': 'Jul 10, 2023',
      'courses': 7,
    },
    {
      'id': '18',
      'name': 'Nicole Allen',
      'email': 'nicole.allen@email.com',
      'progress': 65,
      'status': 'Active',
      'joined': 'Nov 30, 2023',
      'courses': 2,
    },
    {
      'id': '19',
      'name': 'Andrew Young',
      'email': 'andrew.young@email.com',
      'progress': 40,
      'status': 'Struggling',
      'joined': 'Feb 5, 2024',
      'courses': 1,
    },
    {
      'id': '20',
      'name': 'Stephanie King',
      'email': 'stephanie.king@email.com',
      'progress': 88,
      'status': 'Active',
      'joined': 'Dec 15, 2023',
      'courses': 4,
    },
  ];

  List<Map<String, dynamic>> get _filteredLearners {
    var filtered = _allLearners;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((learner) {
        final name = learner['name'].toString().toLowerCase();
        final email = learner['email'].toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || email.contains(query);
      }).toList();
    }

    // Apply status filter
    if (_selectedFilter != 'All') {
      filtered = filtered.where((learner) {
        return learner['status'] == _selectedFilter;
      }).toList();
    }

    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredLearners = _filteredLearners;

    return Scaffold(
      appBar: AppBar(
        title: const Text('👥 Manage Learners'),
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search and Filter
            _buildSearchAndFilterSection(),
            const SizedBox(height: AppConstants.largePadding),

            // Learners List
            _buildLearnersList(filteredLearners),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: '🔍 Search learners...',
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppConstants.defaultBorderRadius),
            ),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Active'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Completed'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Struggling'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
      selectedColor: AppConstants.primaryColor.withOpacity(0.2),
      checkmarkColor: AppConstants.primaryColor,
    );
  }

  Widget _buildLearnersList(List<Map<String, dynamic>> learners) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Learners (${learners.length})',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (learners.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('No learners found'),
            ),
          )
        else
          ...learners.map((learner) {
            final progress = learner['progress'] as int;
            Color progressColor = AppConstants.successColor;
            if (progress < 30) {
              progressColor = AppConstants.errorColor;
            } else if (progress < 70) {
              progressColor = AppConstants.warningColor;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppConstants.dividerColor),
                  borderRadius:
                      BorderRadius.circular(AppConstants.defaultBorderRadius),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppConstants.primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              (learner['name'] as String)[0],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: AppConstants.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                learner['name'] as String,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                learner['email'] as String,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppConstants.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: progressColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            learner['status'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: progressColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Progress Bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Progress',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${progress}%',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress / 100,
                            backgroundColor: AppConstants.dividerColor,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(progressColor),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Info Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 14, color: AppConstants.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              'Joined: ${learner['joined']}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppConstants.textSecondary),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.book,
                                size: 14, color: AppConstants.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              '${learner['courses']} courses',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppConstants.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _showLearnerDetails(context, learner);
                            },
                            icon: const Icon(Icons.info, size: 16),
                            label: const Text('Details'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _showMessageDialog(context, learner);
                            },
                            icon: const Icon(Icons.mail, size: 16),
                            label: const Text('Message'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
      ],
    );
  }

  void _showLearnerDetails(BuildContext context, Map<String, dynamic> learner) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(learner['name'] as String),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${learner['email']}'),
            const SizedBox(height: 8),
            Text('Status: ${learner['status']}'),
            const SizedBox(height: 8),
            Text('Progress: ${learner['progress']}%'),
            const SizedBox(height: 8),
            Text('Courses: ${learner['courses']}'),
            const SizedBox(height: 8),
            Text('Joined: ${learner['joined']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showMessageDialog(BuildContext context, Map<String, dynamic> learner) {
    final messageController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Message ${learner['name']}'),
        content: TextField(
          controller: messageController,
          decoration: const InputDecoration(
            hintText: 'Enter your message...',
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Message sent to ${learner['name']}'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}
