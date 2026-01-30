import 'package:flutter/material.dart';
import 'program_detail_screen.dart';
import 'program_list_screen.dart';
import '../data/programs_data.dart';
import '../models/program_model.dart';
import '../constants/constants.dart';

class MyProgramsScreen extends StatelessWidget {
  const MyProgramsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myPrograms = ProgramsData.getMyPrograms();

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context, myPrograms),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('My Courses'),
      backgroundColor: AppConstants.primaryColor,
      elevation: 0,
    );
  }

  Widget _buildBody(
      BuildContext context, List<Map<String, dynamic>> myPrograms) {
    return myPrograms.isEmpty
        ? _buildEmptyState(context)
        : _buildProgramsList(context, myPrograms);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'No Programs Enrolled',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Browse programs and enroll to see them here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _navigateToProgramList(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Browse Programs'),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramsList(
      BuildContext context, List<Map<String, dynamic>> myPrograms) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: myPrograms.length,
      itemBuilder: (context, index) =>
          _buildProgramCard(context, myPrograms[index]),
    );
  }

  Widget _buildProgramCard(BuildContext context, Map<String, dynamic> program) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: _buildProgramIcon(program['category']),
        title: Text(
          program['title']?.toString() ?? 'Unknown Course',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: _buildProgramSubtitle(program),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _navigateToProgramDetail(context, program),
      ),
    );
  }

  Widget _buildProgramIcon(String? category) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: _getCategoryColor(category),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        _getCategoryIcon(category),
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Widget _buildProgramSubtitle(Map<String, dynamic> program) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          program['category']?.toString() ?? 'Unknown Category',
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.schedule, size: 14, color: Colors.grey),
            const SizedBox(width: 4),
            Text(program['duration']?.toString() ?? '8 Weeks'),
            const Spacer(),
            Chip(
              label: const Text('Enrolled'),
              backgroundColor: Colors.green.shade50,
              labelStyle: const TextStyle(color: Colors.green, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const LinearProgressIndicator(
          value: 0.65,
          backgroundColor: Colors.grey,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        const SizedBox(height: 4),
        const Text(
          '65% Complete',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  void _navigateToProgramDetail(
      BuildContext context, Map<String, dynamic> program) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProgramDetailScreen(
          program: Program.fromMap(program),
        ),
      ),
    );
  }

  void _navigateToProgramList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProgramListScreen(isAdmin: false),
      ),
    );
  }

  Color _getCategoryColor(String? category) {
    final colorMap = {
      'Mobile Development': Colors.blue,
      'Data Science': Colors.purple,
      'Web Development': Colors.green,
      'Cloud Computing': Colors.orange,
      'DevOps': Colors.red,
      'Design': Colors.pink,
      'Security': Colors.deepOrange,
      'Computer Science': Colors.indigo,
      'Blockchain': Colors.teal,
      'Marketing': Colors.cyan,
    };
    return colorMap[category] ?? Colors.blue;
  }

  IconData _getCategoryIcon(String? category) {
    final iconMap = {
      'Mobile Development': Icons.phone_android,
      'Data Science': Icons.analytics,
      'Web Development': Icons.code,
      'Cloud Computing': Icons.cloud,
      'DevOps': Icons.settings,
      'Design': Icons.design_services,
      'Security': Icons.security,
      'Computer Science': Icons.computer,
      'Blockchain': Icons.account_balance_wallet,
      'Marketing': Icons.trending_up,
    };
    return iconMap[category] ?? Icons.school;
  }
}
