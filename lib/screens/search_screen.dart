import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../constants/constants.dart';
import 'program_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<String> _searchHistory = [];
  List<String> _suggestions = [];
  bool _isSearching = false;
  String _lastSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  void _loadSearchHistory() {
    // Load search history from storage
    _searchHistory = [
      'Flutter Development',
      'Web Development',
      'Machine Learning',
      'Data Science',
      'UI/UX Design',
    ];
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _suggestions.clear();
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _lastSearchQuery = query;

      // Add to search history
      if (!_searchHistory.contains(query)) {
        _searchHistory.insert(0, query);
        if (_searchHistory.length > 10) {
          _searchHistory.removeLast();
        }
      }
    });

    // In real app, you would call API or filter local data
    _loadSearchResults(query);
  }

  Future<void> _loadSearchResults(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Mock suggestions
    final mockSuggestions = [
      '$query course',
      'Advanced $query',
      '$query for beginners',
      '$query tutorial',
      '$query certification',
    ];

    setState(() {
      _suggestions = mockSuggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final programs = provider.programs;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.primaryColor,
        automaticallyImplyLeading: false,
        title: _buildSearchBar(),
      ),
      body: _buildBody(provider, programs),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: const InputDecoration(
                hintText: 'Search programs, courses, skills...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onChanged: _performSearch,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _performSearch(value);
                }
              },
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, size: 20),
              onPressed: () {
                _searchController.clear();
                _performSearch('');
                _searchFocusNode.requestFocus();
              },
            ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildBody(AppProvider provider, List<dynamic> programs) {
    if (_isSearching && _lastSearchQuery.isNotEmpty) {
      return _buildSearchResults(provider, programs);
    } else {
      return _buildInitialState();
    }
  }

  Widget _buildInitialState() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search History
          if (_searchHistory.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(AppConstants.defaultPadding),
              child: Text(
                'Recent Searches',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _searchHistory.map((query) {
                  return ActionChip(
                    label: Text(query),
                    onPressed: () {
                      _searchController.text = query;
                      _performSearch(query);
                    },
                    avatar: const Icon(Icons.history, size: 16),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _clearSearchHistory,
                  child: const Text('Clear History'),
                ),
              ),
            ),
            const Divider(),
          ],

          // Popular Searches
          const Padding(
            padding: EdgeInsets.all(AppConstants.defaultPadding),
            child: Text(
              'Popular Searches',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'Flutter',
                'React Native',
                'Python',
                'Data Science',
                'Web Development',
                'UI/UX Design',
                'Machine Learning',
                'Cloud Computing',
              ].map((query) {
                return ActionChip(
                  label: Text(query),
                  onPressed: () {
                    _searchController.text = query;
                    _performSearch(query);
                  },
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Search Tips
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Search Tips',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildTipItem('Use specific keywords', Icons.search),
                _buildTipItem('Try different spellings', Icons.spellcheck),
                _buildTipItem('Filter by category', Icons.filter_list),
                _buildTipItem('Sort by rating or price', Icons.sort),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(AppProvider provider, List<dynamic> programs) {
    final searchQuery = _lastSearchQuery.toLowerCase();

    // Filter programs based on search query
    final filteredPrograms = programs.where((program) {
      return program.title.toLowerCase().contains(searchQuery) ||
          program.description.toLowerCase().contains(searchQuery) ||
          program.category.toLowerCase().contains(searchQuery);
    }).toList();

    return Column(
      children: [
        // Search Info
        Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Results for "$_lastSearchQuery"',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${filteredPrograms.length} found',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),

        // Suggestions
        if (_suggestions.isNotEmpty && filteredPrograms.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Did you mean:',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _suggestions.map((suggestion) {
                    return ActionChip(
                      label: Text(suggestion),
                      onPressed: () {
                        _searchController.text = suggestion;
                        _performSearch(suggestion);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

        // Search Results
        Expanded(
          child: filteredPrograms.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No results found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Try different keywords',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  itemCount: filteredPrograms.length,
                  itemBuilder: (context, index) {
                    final program = filteredPrograms[index];
                    return _buildSearchResultCard(program, provider);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSearchResultCard(dynamic program, AppProvider provider) {
    final isEnrolled = provider.enrollments
        .any((e) => e.programId == program.id && e.isActive);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color:
                AppConstants.categoryColors[program.category]?.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            AppConstants.categoryIcons[program.category],
            color: AppConstants.categoryColors[program.category],
          ),
        ),
        title: Text(
          program.title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(program.category),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                Text(program.rating.toStringAsFixed(1)),
                const SizedBox(width: 16),
                const Icon(Icons.schedule, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(program.duration),
              ],
            ),
          ],
        ),
        trailing: isEnrolled
            ? const Chip(
                label: Text('Enrolled'),
                backgroundColor: Colors.green.shade50,
                labelStyle: TextStyle(color: Colors.green, fontSize: 10),
              )
            : const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProgramDetailScreen(
                program: {
                  'id': program.id,
                  'title': program.title,
                  'description': program.description,
                  'category': program.category,
                  'duration': program.duration,
                  'level': program.level,
                  'price': program.price,
                  'rating': program.rating,
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTipItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blue),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }

  void _clearSearchHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Search History'),
        content:
            const Text('Are you sure you want to clear all search history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _searchHistory.clear());
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
