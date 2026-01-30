// lib/screens/certificate_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../providers/app_provider.dart';
import '../constants/constants.dart';

class CertificateScreen extends StatefulWidget {
  final String programId;
  final String programTitle;
  final double score;
  final DateTime completionDate;

  const CertificateScreen({
    super.key,
    required this.programId,
    required this.programTitle,
    this.score = 95.0,
    required this.completionDate,
  });

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isGenerating = false;
  bool _isSaved = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final userName = provider.userName ?? 'Learner';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate'),
        backgroundColor: AppConstants.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareCertificate,
            tooltip: 'Share Certificate',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _saveCertificate,
            tooltip: 'Save Certificate',
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: _printCertificate,
            tooltip: 'Print Certificate',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Certificate Preview
            Screenshot(
              controller: _screenshotController,
              child: _buildCertificateDesign(userName),
            ),

            const SizedBox(height: 24),

            // Certificate Details
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Certificate Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                          'Certificate ID', _generateCertificateId()),
                      _buildDetailRow('Issued To', userName),
                      _buildDetailRow('Program', widget.programTitle),
                      _buildDetailRow(
                          'Score', '${widget.score.toStringAsFixed(1)}%'),
                      _buildDetailRow(
                          'Date of Issue', _formatDate(widget.completionDate)),
                      _buildDetailRow(
                          'Valid Until',
                          _formatDate(widget.completionDate
                              .add(const Duration(days: 365)))),
                    ],
                  ),
                ),
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                children: [
                  if (_isGenerating)
                    const CircularProgressIndicator()
                  else if (_isSaved)
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Certificate saved successfully',
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    )
                  else
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _verifyCertificate,
                          icon: const Icon(Icons.verified),
                          label: const Text('Verify Online'),
                        ),
                        ElevatedButton.icon(
                          onPressed: _addToLinkedIn,
                          icon: const Icon(Icons.person_add),
                          label: const Text('Add to LinkedIn'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Back to Course'),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificateDesign(String userName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.gold, width: 5),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.blue.shade50,
          ],
        ),
      ),
      child: Column(
        children: [
          // Header
          const Text(
            'CERTIFICATE OF COMPLETION',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'This is to certify that',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),

          // Student Name
          const SizedBox(height: 20),
          Text(
            userName.toUpperCase(),
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              letterSpacing: 1,
            ),
          ),

          // Completion Text
          const SizedBox(height: 20),
          const Text(
            'has successfully completed the course',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),

          // Course Title
          const SizedBox(height: 20),
          Text(
            widget.programTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          // Score and Date
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text(
                    'SCORE',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.score.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(
                    'DATE OF COMPLETION',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(widget.completionDate),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Signature Section
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    height: 2,
                    width: 150,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Instructor Signature',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 60,
                    width: 60,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.school,
                          size: 40, color: Colors.blue);
                    },
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Silk Track',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    height: 2,
                    width: 150,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Director Signature',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Certificate ID
          const SizedBox(height: 30),
          const Divider(),
          const SizedBox(height: 10),
          Text(
            'Certificate ID: ${_generateCertificateId()}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Verify at: https://verify.silktrack.com',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _generateCertificateId() {
    final date = widget.completionDate;
    final id =
        'ST-${date.year}${date.month}${date.day}-${widget.programId.substring(0, 4)}-${widget.score.toInt()}';
    return id.toUpperCase();
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  Future<void> _shareCertificate() async {
    setState(() => _isGenerating = true);

    try {
      final image = await _screenshotController.capture();
      if (image == null) return;

      final directory = await getTemporaryDirectory();
      final imagePath =
          '${directory.path}/certificate_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(imagePath);
      await file.writeAsBytes(image);

      await Share.shareXFiles(
        [XFile(imagePath)],
        text: 'I just completed "${widget.programTitle}" on Silk Track! 🎓',
        subject: 'My Certificate of Completion',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sharing certificate: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  Future<void> _saveCertificate() async {
    setState(() => _isGenerating = true);

    try {
      final image = await _screenshotController.capture();
      if (image == null) return;

      final directory = await getApplicationDocumentsDirectory();
      final folderPath = '${directory.path}/SilkTrack/Certificates';
      await Directory(folderPath).create(recursive: true);

      final imagePath = '$folderPath/${_generateCertificateId()}.png';
      final file = File(imagePath);
      await file.writeAsBytes(image);

      setState(() {
        _isGenerating = false;
        _isSaved = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Certificate saved to device'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _isGenerating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving certificate: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _printCertificate() async {
    // Implement print functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Print functionality would be implemented here'),
      ),
    );
  }

  Future<void> _verifyCertificate() async {
    final url = Uri.parse(
        'https://verify.silktrack.com/certificate/${_generateCertificateId()}');
    // Use url_launcher to open URL
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Verification URL: ${url.toString()}'),
      ),
    );
  }

  Future<void> _addToLinkedIn() async {
    // Implement LinkedIn sharing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('LinkedIn integration would be implemented here'),
      ),
    );
  }
}
