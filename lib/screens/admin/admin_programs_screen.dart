import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../models/program_model.dart';
import '../../data/sample_programs.dart';
import 'admin_program_form_screen.dart';
import '../../screens/program_detail_screen.dart';

class AdminProgramsScreen extends StatefulWidget {
  const AdminProgramsScreen({super.key});

  @override
  State<AdminProgramsScreen> createState() => _AdminProgramsScreenState();
}

class _AdminProgramsScreenState extends State<AdminProgramsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String _searchQuery = '';

  // Get 15 programs from sample data
  List<Program> get _allPrograms {
    final samplePrograms = getSamplePrograms();
    // Ensure we have at least 15 programs
    if (samplePrograms.length < 15) {
      // Add more programs if needed
      return samplePrograms + _generateAdditionalPrograms(15 - samplePrograms.length);
    }
    return samplePrograms.take(15).toList();
  }

  List<Program> _generateAdditionalPrograms(int count) {
    final categories = ['Web Development', 'Mobile Development', 'Data Science', 'Design', 'Business'];
    final levels = ['Beginner', 'Intermediate', 'Advanced'];
    final instructors = ['John Smith', 'Sarah Johnson', 'Mike Davis', 'Emma Wilson', 'David Brown'];
    
    return List.generate(count, (index) {
      final i = index + 11;
      return Program(
        id: i.toString(),
        title: 'Course ${i}',
        description: 'Comprehensive course covering all essential topics',
        category: categories[i % categories.length],
        duration: 8 + (i % 5),
        difficulty: levels[i % levels.length],
        skills: ['Skill 1', 'Skill 2', 'Skill 3'],
        modules: ['Module 1', 'Module 2', 'Module 3'],
        provider: instructors[i % instructors.length],
        rating: 4.0 + (i % 10) / 10,
        enrolledCount: 50 + (i * 10),
        startDate: DateTime.now().subtract(Duration(days: i * 10)),
        endDate: DateTime.now().add(Duration(days: (8 + (i % 5)) * 7)),
        level: levels[i % levels.length],
        price: 49.99 + (i * 5),
        instructor: instructors[i % instructors.length],
        enrolledStudents: 50 + (i * 10),
        detailedDescription: 'Detailed description for course $i',
      );
    });
  }

  List<Program> get _filteredPrograms {
    var filtered = _allPrograms;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((program) {
        final title = program.title.toLowerCase();
        final category = program.category.toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || category.contains(query);
      }).toList();
    }

    // Apply status filter
    if (_selectedFilter == 'Active') {
      filtered = filtered.where((p) => p.isActive).toList();
    } else if (_selectedFilter == 'Inactive') {
      filtered = filtered.where((p) => !p.isActive).toList();
    } else if (_selectedFilter == 'Popular') {
      filtered = filtered.where((p) => p.enrolledCount > 100).toList();
      filtered.sort((a, b) => b.enrolledCount.compareTo(a.enrolledCount));
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
    final filteredPrograms = _filteredPrograms;

    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 Manage Programs'),
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

            // Programs List
            _buildProgramsList(filteredPrograms),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminProgramFormScreen(),
            ),
          ).then((_) {
            // Refresh if needed
            setState(() {});
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Program'),
        backgroundColor: AppConstants.primaryColor,
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
            hintText: '🔍 Search programs...',
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
                    _buildFilterChip('Inactive'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Popular'),
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

  Widget _buildProgramsList(List<Program> programs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Programs (${programs.length})',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (programs.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('No programs found'),
            ),
          )
        else
          ...programs.map((program) {
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                program.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      AppConstants.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  program.category,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppConstants.primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _editProgram(program);
                            } else if (value == 'view') {
                              _viewProgram(program);
                            } else if (value == 'delete') {
                              _deleteProgram(program);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 18),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'view',
                              child: Row(
                                children: [
                                  Icon(Icons.visibility, size: 18),
                                  SizedBox(width: 8),
                                  Text('View'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, size: 18, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Delete',
                                      style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.people,
                                size: 16, color: AppConstants.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              '${program.enrolledCount} enrolled',
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppConstants.textSecondary),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              '${program.rating.toStringAsFixed(1)} ⭐',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        Text(
                          'Updated: ${_getUpdatedText(program)}',
                          style: const TextStyle(
                              fontSize: 12, color: AppConstants.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        const SizedBox(height: 20),
        Center(
          child: Text(
            'Showing ${programs.length} of ${_allPrograms.length} programs',
            style: const TextStyle(color: AppConstants.textSecondary),
          ),
        ),
      ],
    );
  }

  String _getUpdatedText(Program program) {
    final daysAgo = DateTime.now().difference(program.startDate).inDays;
    if (daysAgo < 1) return 'Today';
    if (daysAgo == 1) return '1 day ago';
    if (daysAgo < 7) return '$daysAgo days ago';
    if (daysAgo < 30) return '${(daysAgo / 7).floor()} weeks ago';
    return '${(daysAgo / 30).floor()} months ago';
  }

  void _editProgram(Program program) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminProgramFormScreen(program: program),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  void _viewProgram(Program program) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProgramDetailScreen(program: program),
      ),
    );
  }

  void _deleteProgram(Program program) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Program'),
        content: Text('Are you sure you want to delete "${program.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${program.title} deleted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
