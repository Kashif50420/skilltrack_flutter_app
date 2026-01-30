import 'package:flutter/material.dart';
import '../models/program_model.dart';
import '../constants/constants.dart';
import 'enroll_form_screen.dart';

class ProgramDetailScreen extends StatelessWidget {
  final Program program;

  const ProgramDetailScreen({
    super.key,
    required this.program,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(program.title),
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgramHeader(),
            const SizedBox(height: 24),
            _buildAboutSection(),
            const SizedBox(height: 24),
            _buildCourseDetailsSection(),
            const SizedBox(height: 32),
            _buildEnrollButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              program.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              program.category,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF4361EE),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              program.description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoChip(Icons.schedule, '${program.duration} weeks'),
                const SizedBox(width: 8),
                _buildInfoChip(Icons.school, program.level ?? program.difficulty),
                const SizedBox(width: 8),
                _buildInfoChip(Icons.attach_money, '\$${program.price ?? 0.0}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(text),
      backgroundColor: Colors.blue.shade50,
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About this Program',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          program.description,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildCourseDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Course Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildDetailRow('Instructor', program.instructor ?? program.provider),
        _buildDetailRow(
            'Total Students', '${program.enrolledStudents ?? program.enrolledCount} students'),
        _buildDetailRow('Rating', '${program.rating} ⭐'),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildEnrollButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EnrollFormScreen(program: program),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text(
          'ENROLL NOW',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
    );
  }
}
