import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/constants.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How do I enroll in a program?',
      'answer': 'Browse programs from the Programs section, select a program, '
          'click "Enroll Now", fill the enrollment form, and submit.',
    },
    {
      'question': 'How can I track my progress?',
      'answer':
          'Go to "My Programs" to see all enrolled courses with progress bars. '
              'You can also view detailed analytics in the Progress Tracking screen.',
    },
    {
      'question': 'How do I download my certificate?',
      'answer': 'After completing a course, go to the course details page and '
          'click "Download Certificate". Certificates are also available in the Certificates section.',
    },
    {
      'question': 'Can I get a refund?',
      'answer': 'Refunds are available within 7 days of enrollment if no more than '
          '20% of the course content has been accessed. Contact support for refund requests.',
    },
    {
      'question': 'How do I reset my password?',
      'answer':
          'Go to Settings > Change Password. If you forgot your password, '
              'contact support at support@silktrack.com.',
    },
    {
      'question': 'Are courses available offline?',
      'answer': 'Yes, you can download course materials for offline access. '
          'Enable "Download over Wi-Fi Only" in settings to save data.',
    },
  ];

  final TextEditingController _supportMessageController =
      TextEditingController();
  bool _isSendingMessage = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Help & Support'),
          backgroundColor: AppConstants.primaryColor,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'FAQs'),
              Tab(text: 'Contact'),
              Tab(text: 'Resources'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // FAQs Tab
            _buildFAQsTab(),

            // Contact Tab
            _buildContactTab(),

            // Resources Tab
            _buildResourcesTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQsTab() {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.all(AppConstants.defaultPadding),
          child: Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ..._faqs.map((faq) {
          return _buildFAQItem(faq);
        }).toList(),
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.all(AppConstants.defaultPadding),
          child: Text(
            'Still have questions?',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding),
          child: ElevatedButton(
            onPressed: () {
              DefaultTabController.of(context).animateTo(1);
            },
            child: const Text('Contact Support'),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildFAQItem(Map<String, dynamic> faq) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: 4,
      ),
      child: ExpansionTile(
        title: Text(
          faq['question'],
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(faq['answer']),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        children: [
          // Contact Info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Contact Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildContactOption(
                    icon: Icons.email,
                    title: 'Email',
                    subtitle: AppConstants.contactEmail,
                    onTap: () => _sendEmail(),
                  ),
                  _buildContactOption(
                    icon: Icons.phone,
                    title: 'Phone',
                    subtitle: '+92 300 1234567',
                    onTap: () => _makePhoneCall(),
                  ),
                  _buildContactOption(
                    icon: Icons.location_on,
                    title: 'Address',
                    subtitle: '123 Learning Street, Tech City, Pakistan',
                    onTap: () => _openMap(),
                  ),
                  _buildContactOption(
                    icon: Icons.access_time,
                    title: 'Support Hours',
                    subtitle: 'Mon-Fri: 9AM-6PM\nSat: 10AM-4PM',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Support Form
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Send us a Message',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Describe your issue or question in detail:',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _supportMessageController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'Enter your message here...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _isSendingMessage
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _sendSupportMessage,
                            child: const Text('Send Message'),
                          ),
                        ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Quick Actions
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildQuickActionButton(
                icon: Icons.bug_report,
                label: 'Report Bug',
                onTap: _reportBug,
              ),
              _buildQuickActionButton(
                icon: Icons.lightbulb,
                label: 'Suggest Feature',
                onTap: _suggestFeature,
              ),
              _buildQuickActionButton(
                icon: Icons.feedback,
                label: 'Give Feedback',
                onTap: _giveFeedback,
              ),
              _buildQuickActionButton(
                icon: Icons.live_help,
                label: 'Live Chat',
                onTap: _startLiveChat,
              ),
            ],
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppConstants.primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 120,
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Icon(icon, size: 30, color: AppConstants.primaryColor),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResourcesTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      children: [
        const Text(
          'Helpful Resources',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildResourceCard(
          title: 'User Guide',
          description: 'Complete guide to using Silk Track',
          icon: Icons.menu_book,
          onTap: () => _openUserGuide(),
        ),
        _buildResourceCard(
          title: 'Video Tutorials',
          description: 'Step-by-step video guides',
          icon: Icons.video_library,
          onTap: () => _openVideoTutorials(),
        ),
        _buildResourceCard(
          title: 'Community Forum',
          description: 'Connect with other learners',
          icon: Icons.forum,
          onTap: () => _openCommunityForum(),
        ),
        _buildResourceCard(
          title: 'System Status',
          description: 'Check app and server status',
          icon: Icons.cloud,
          onTap: () => _checkSystemStatus(),
        ),
        _buildResourceCard(
          title: 'Release Notes',
          description: 'Latest updates and features',
          icon: Icons.update,
          onTap: () => _viewReleaseNotes(),
        ),
        _buildResourceCard(
          title: 'Privacy Policy',
          description: 'How we protect your data',
          icon: Icons.privacy_tip,
          onTap: () => _openPrivacyPolicy(),
        ),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
        const Text(
          'Download App Resources',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildDownloadResource(
          title: 'Course Syllabus Template',
          format: 'PDF',
          size: '2.4 MB',
        ),
        _buildDownloadResource(
          title: 'Learning Roadmap',
          format: 'PDF',
          size: '1.8 MB',
        ),
        _buildDownloadResource(
          title: 'Study Planner',
          format: 'Excel',
          size: '850 KB',
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildResourceCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppConstants.primaryColor, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(description),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDownloadResource({
    required String title,
    required String format,
    required String size,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text('$format • $size'),
        trailing: IconButton(
          icon: const Icon(Icons.download),
          onPressed: () {
            // Implement download
          },
        ),
      ),
    );
  }

  // Contact Methods
  Future<void> _sendEmail() async {
    final url = Uri.parse('mailto:${AppConstants.contactEmail}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _makePhoneCall() async {
    final url = Uri.parse('tel:+923001234567');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _openMap() async {
    final url = Uri.parse('https://maps.google.com/?q=Tech+City+Pakistan');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _sendSupportMessage() async {
    if (_supportMessageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a message'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSendingMessage = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isSendingMessage = false);
    _supportMessageController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Message sent successfully. We\'ll respond within 24 hours.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _reportBug() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Bug'),
        content: const Text('Describe the bug you encountered:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _supportMessageController.text = 'Bug Report: ';
              DefaultTabController.of(context).animateTo(1);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _suggestFeature() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Suggest Feature'),
        content: const Text('Share your idea for a new feature:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _supportMessageController.text = 'Feature Request: ';
              DefaultTabController.of(context).animateTo(1);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _giveFeedback() {
    // Navigate to feedback screen
  }

  void _startLiveChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Live Chat'),
        content: const Text('Live chat is available during support hours.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _openUserGuide() {
    // Open user guide
  }

  void _openVideoTutorials() {
    // Open video tutorials
  }

  void _openCommunityForum() {
    final url = Uri.parse('${AppConstants.websiteUrl}/forum');
    _launchUrl(url);
  }

  void _checkSystemStatus() {
    final url = Uri.parse('${AppConstants.websiteUrl}/status');
    _launchUrl(url);
  }

  void _viewReleaseNotes() {
    // Open release notes
  }

  void _openPrivacyPolicy() {
    final url = Uri.parse(AppConstants.privacyPolicyUrl);
    _launchUrl(url);
  }

  Future<void> _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
