import 'package:flutter/material.dart';
import '../../constants/constants.dart';

class AdminAnalyticsScreen extends StatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📈 Analytics Dashboard'),
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Range Selector
            _buildDateRangeSection(),
            const SizedBox(height: AppConstants.largePadding),

            // Key Metrics
            _buildKeyMetricsSection(),
            const SizedBox(height: AppConstants.largePadding),

            // Enrollment Trend Chart
            _buildEnrollmentTrendSection(),
            const SizedBox(height: AppConstants.largePadding),

            // Top Programs
            _buildTopProgramsSection(),
            const SizedBox(height: AppConstants.largePadding),

            // Areas Needing Attention
            _buildAreasNeedingAttentionSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeSection() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(color: AppConstants.dividerColor),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: AppConstants.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Jan 1, 2024 - Mar 1, 2024',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down,
              color: AppConstants.primaryColor),
        ],
      ),
    );
  }

  Widget _buildKeyMetricsSection() {
    final metrics = [
      {'label': 'Total Enrollments', 'value': '245', 'change': '+12%'},
      {'label': 'Avg. Progress', 'value': '68%', 'change': '+5%'},
      {'label': 'Completion Rate', 'value': '42%', 'change': '-3%'},
      {'label': 'Revenue', 'value': '\$2,450', 'change': '+18%'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📊 Key Metrics',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: metrics.map((metric) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppConstants.dividerColor),
                borderRadius:
                    BorderRadius.circular(AppConstants.defaultBorderRadius),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    metric['label'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppConstants.textSecondary,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        metric['value'] as String,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppConstants.successColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          metric['change'] as String,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppConstants.successColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEnrollmentTrendSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📈 Enrollment Trend',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
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
              // Simple bar chart representation
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildChartBar('Jan', 0.6),
                  _buildChartBar('Feb', 0.7),
                  _buildChartBar('Mar', 0.85),
                ],
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Jan',
                      style: TextStyle(
                          fontSize: 12, color: AppConstants.textSecondary)),
                  Text('Feb',
                      style: TextStyle(
                          fontSize: 12, color: AppConstants.textSecondary)),
                  Text('Mar',
                      style: TextStyle(
                          fontSize: 12, color: AppConstants.textSecondary)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChartBar(String month, double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 40,
          height: 150 * height,
          decoration: BoxDecoration(
            color: AppConstants.primaryColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopProgramsSection() {
    final programs = [
      {'name': 'Flutter Development', 'learners': 156},
      {'name': 'Business Basics', 'learners': 89},
      {'name': 'UI/UX Design', 'learners': 112},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🏆 Top Performing Programs',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...programs.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final program = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$index',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
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
                        program['name'] as String,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${program['learners']} learners',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppConstants.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildAreasNeedingAttentionSection() {
    final areas = [
      {
        'icon': Icons.warning,
        'title': 'Low Enrollment',
        'description': 'Data Science course has only 15 enrollments',
        'color': AppConstants.warningColor,
      },
      {
        'icon': Icons.trending_down,
        'title': 'Completion Rate Dropped',
        'description': 'Completion rate decreased by 5% this month',
        'color': AppConstants.errorColor,
      },
      {
        'icon': Icons.person_outline,
        'title': 'Struggling Learners',
        'description': '23 learners struggling with Module 5',
        'color': AppConstants.warningColor,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '⚠️ Areas Needing Attention',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...areas.map((area) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: (area['color'] as Color).withOpacity(0.2)),
                borderRadius:
                    BorderRadius.circular(AppConstants.defaultBorderRadius),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (area['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      area['icon'] as IconData,
                      color: area['color'] as Color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          area['title'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          area['description'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppConstants.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
