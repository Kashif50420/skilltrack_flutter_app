import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../constants/constants.dart';
import '../models/program_model.dart';
import 'program_detail_screen.dart';
import 'admin/admin_program_form_screen.dart';
import '../services/api_service.dart';

enum ViewMode { list, grid }

class ProgramListScreen extends StatefulWidget {
  final bool isAdmin;

  const ProgramListScreen({super.key, this.isAdmin = false});

  @override
  State<ProgramListScreen> createState() => _ProgramListScreenState();
}

class _ProgramListScreenState extends State<ProgramListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _selectedCategories = [];
  String _selectedLevel = 'All';
  String _selectedDuration = 'All';
  String _sortBy = 'rating';
  bool _sortAscending = false;
  ViewMode _viewMode = ViewMode.list;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPrograms();
  }

  Future<void> _loadPrograms() async {
    setState(() => _isLoading = true);
    try {
      final provider = Provider.of<AppProvider>(context, listen: false);
      await provider.refreshData();
      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading programs: $e')),
      );
    }
  }

  List<Program> _getFilteredPrograms(List<Program> programs) {
    List<Program> filtered = [...programs];

    if (_searchController.text.isNotEmpty) {
      final q = _searchController.text.toLowerCase();
      filtered = filtered
          .where((p) =>
              p.title.toLowerCase().contains(q) ||
              p.description.toLowerCase().contains(q) ||
              p.category.toLowerCase().contains(q))
          .toList();
    }

    if (_selectedCategories.isNotEmpty) {
      filtered = filtered
          .where((p) => _selectedCategories.contains(p.category))
          .toList();
    }

    if (_selectedLevel != 'All') {
      filtered = filtered.where((p) => (p.level ?? p.difficulty) == _selectedLevel).toList();
    }

    if (_selectedDuration != 'All') {
      final durationWeeks = _weeks(_selectedDuration);
      filtered = filtered.where((p) => p.duration == durationWeeks).toList();
    }

    filtered.sort((a, b) {
      int c;
      switch (_sortBy) {
        case 'title':
          c = a.title.compareTo(b.title);
          break;
        case 'price':
          final priceA = a.price ?? 0.0;
          final priceB = b.price ?? 0.0;
          c = priceA.compareTo(priceB);
          break;
        case 'duration':
          c = a.duration.compareTo(b.duration);
          break;
        default:
          c = b.rating.compareTo(a.rating);
      }
      return _sortAscending ? c : -c;
    });

    return filtered;
  }

  int _weeks(String d) {
    final m = RegExp(r'\d+').firstMatch(d);
    return m != null ? int.parse(m.group(0)!) : 0;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final allPrograms = provider.programs;
    final programs = _getFilteredPrograms(allPrograms);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Programs & Courses'),
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : programs.isEmpty
              ? _empty()
              : _viewMode == ViewMode.grid
                  ? _grid(programs)
                  : _list(programs),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppConstants.primaryColor,
        onPressed: _loadPrograms,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _empty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.search_off, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text('No programs found'),
        ],
      ),
    );
  }

  Widget _list(List<Program> programs) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: programs.length,
      itemBuilder: (_, i) => _listCard(programs[i]),
    );
  }

  Widget _grid(List<Program> programs) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: programs.length,
      itemBuilder: (_, i) => _gridCard(programs[i]),
    );
  }

  Widget _listCard(Program p) {
    return Card(
      child: ListTile(
        title: Text(p.title),
        subtitle: Text(p.category),
        trailing: widget.isAdmin
            ? PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('Edit'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminProgramFormScreen(program: p),
                        ),
                      );
                    },
                  ),
                  PopupMenuItem(
                    child: const Text('Delete'),
                    onTap: () => _deleteProgram(p.id),
                  ),
                ],
              )
            : Text('\$${p.price}'),
        onTap: () => _openDetail(p),
      ),
    );
  }

  Widget _gridCard(Program p) {
    return Card(
      child: InkWell(
        onTap: () => _openDetail(p),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isAdmin)
                Align(
                  alignment: Alignment.topRight,
                  child: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text('Edit'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AdminProgramFormScreen(program: p),
                            ),
                          );
                        },
                      ),
                      PopupMenuItem(
                        child: const Text('Delete'),
                        onTap: () => _deleteProgram(p.id),
                      ),
                    ],
                  ),
                ),
              Text(p.category,
                  style: TextStyle(
                      color: AppConstants.categoryColors[p.category])),
              const SizedBox(height: 8),
              Text(p.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Text('\$${p.price ?? 0.0}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
        ),
      ),
    );
  }

  void _openDetail(Program p) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProgramDetailScreen(program: p),
      ),
    );
  }

  Future<void> _deleteProgram(String programId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Program'),
        content: const Text('Are you sure you want to delete this program?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ApiService.deleteProgram(programId);
                Navigator.pop(context);
                await _loadPrograms();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
