import 'package:flutter/material.dart';
import 'package:silk_track/models/program_model.dart';

class ProgramCard extends StatelessWidget {
  final Program program;
  final VoidCallback? onTap;

  const ProgramCard({
    super.key,
    required this.program,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Program Image/Icon
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.school,
                    size: 50,
                    color: Colors.blue[300],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Program Title
              Text(
                program.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              // Provider
              Text(
                program.provider,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              // Rating and Duration
              Row(
                children: [
                  Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    program.rating.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 12),
                  ),
                  const Spacer(),
                  Icon(Icons.timer, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${program.duration} wks',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Difficulty Chip
              Align(
                alignment: Alignment.centerRight,
                child: Chip(
                  label: Text(
                    program.difficulty,
                    style: const TextStyle(fontSize: 10),
                  ),
                  backgroundColor: _getDifficultyColor(program.difficulty),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green[100]!;
      case 'intermediate':
        return Colors.amber[100]!;
      case 'advanced':
        return Colors.red[100]!;
      default:
        return Colors.grey[100]!;
    }
  }
}
