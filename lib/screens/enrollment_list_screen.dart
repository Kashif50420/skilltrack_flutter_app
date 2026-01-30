// lib/screens/enrollment_list_screen.dart

import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EnrollmentListScreen extends StatefulWidget {
  const EnrollmentListScreen({super.key});

  @override
  State<EnrollmentListScreen> createState() => _EnrollmentListScreenState();
}

class _EnrollmentListScreenState extends State<EnrollmentListScreen> {
  late Future<List<dynamic>> _enrollmentsFuture;

  @override
  void initState() {
    super.initState();
    _enrollmentsFuture = ApiService.getAllEnrollments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enrollments'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _enrollmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No enrollments found'));
          }

          final enrollments = snapshot.data!;
          return ListView.builder(
            itemCount: enrollments.length,
            itemBuilder: (context, index) {
              final enrollment = enrollments[index];
              final progress = enrollment['progress'] ?? 0.0;
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  enrollment['programTitle'] ??
                                      'Unknown Program',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Learner: ${enrollment['learnerName'] ?? 'Unknown'}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Chip(
                            label: Text(enrollment['status'] ?? 'pending'),
                            backgroundColor:
                                _getStatusColor(enrollment['status']),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: progress / 100,
                              minHeight: 8,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getProgressColor(progress),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${progress.toStringAsFixed(1)}%',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'active':
        return Colors.blue.shade100;
      case 'completed':
        return Colors.green.shade100;
      case 'pending':
        return Colors.yellow.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getProgressColor(double progress) {
    if (progress < 33) return Colors.red;
    if (progress < 66) return Colors.orange;
    return Colors.green;
  }
}
