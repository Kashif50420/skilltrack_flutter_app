import 'package:flutter/material.dart';
import 'program_detail_screen.dart';

class ProgramListScreen extends StatelessWidget {
  final List<Map<String, String>> programs = [
    {'name': 'Flutter Development', 'level': 'Beginner'},
    {'name': 'Web Development', 'level': 'Intermediate'},
    {'name': 'Cyber Security', 'level': 'Advanced'},
    {'name': 'AI Basics', 'level': 'Beginner'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Programs')),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: programs.length,
        itemBuilder: (context, index) {
          final program = programs[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: ListTile(
              title: Text(program['name']!),
              subtitle: Text('Level: ${program['level']}'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ProgramDetailScreen(programName: program['name']!),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
