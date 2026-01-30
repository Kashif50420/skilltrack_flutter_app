import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/program_model.dart';
import '../providers/app_provider.dart';

class EnrollFormScreen extends StatefulWidget {
  final dynamic program;

  const EnrollFormScreen({
    super.key,
    required this.program,
  });

  @override
  State<EnrollFormScreen> createState() => _EnrollFormScreenState();
}

class _EnrollFormScreenState extends State<EnrollFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _educationController = TextEditingController();
  final _experienceController = TextEditingController();

  bool _agreeTerms = false;
  bool _isSubmitting = false;

  String get _programTitle {
    if (widget.program is Program) {
      return (widget.program as Program).title;
    } else if (widget.program is Map) {
      return (widget.program as Map)['title']?.toString() ?? 'Unknown Program';
    }
    return 'Unknown Program';
  }

  String get _programDuration {
    if (widget.program is Program) {
      return '${(widget.program as Program).duration} weeks';
    } else if (widget.program is Map) {
      return (widget.program as Map)['duration']?.toString() ?? '8 weeks';
    }
    return '8 weeks';
  }

  dynamic get _programPrice {
    if (widget.program is Program) {
      return (widget.program as Program).price ?? 99.99;
    } else if (widget.program is Map) {
      return (widget.program as Map)['price'] ?? 99.99;
    }
    return 99.99;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _educationController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  Future<void> _submitEnrollment() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the terms and conditions'),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final provider = Provider.of<AppProvider>(context, listen: false);
      
      // Get program ID
      String? programId;
      if (widget.program is Program) {
        programId = (widget.program as Program).id;
      } else if (widget.program is Map) {
        programId = (widget.program as Map)['id']?.toString();
      }

      if (programId == null) {
        throw Exception('Program ID not found');
      }

      // Enroll in program
      final result = await provider.enrollInProgram(programId);

      setState(() => _isSubmitting = false);

      if (result['success'] == true) {
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('Enrollment Successful!'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('You have successfully enrolled in:'),
                  const SizedBox(height: 8),
                  Text(
                    _programTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Confirmation email has been sent to your email address.',
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Enrollment failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enrollment Form'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgramInfo(),
              const SizedBox(height: 24),
              _buildPersonalInfoSection(),
              const SizedBox(height: 24),
              _buildTermsSection(),
              const SizedBox(height: 24),
              _buildPaymentSection(),
              const SizedBox(height: 32),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgramInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enrolling in:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _programTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.schedule, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(_programDuration),
                const SizedBox(width: 16),
                const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('\$$_programPrice'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Information',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _fullNameController,
          label: 'Full Name',
          icon: Icons.person,
          validator: (value) => value == null || value.isEmpty
              ? 'Please enter your full name'
              : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _emailController,
          label: 'Email Address',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _phoneController,
          label: 'Phone Number',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          validator: (value) => value == null || value.isEmpty
              ? 'Please enter your phone number'
              : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _educationController,
          label: 'Education Background',
          icon: Icons.school,
          hintText: 'e.g., BS Computer Science',
          validator: (value) => value == null || value.isEmpty
              ? 'Please enter your education background'
              : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _experienceController,
          label: 'Previous Experience',
          icon: Icons.work,
          hintText: 'Briefly describe your relevant experience',
          maxLines: 3,
          validator: (value) => value == null || value.isEmpty
              ? 'Please enter your experience'
              : null,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        hintText: hintText,
      ),
      validator: validator,
    );
  }

  Widget _buildTermsSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _agreeTerms,
          onChanged: (value) {
            setState(() => _agreeTerms = value ?? false);
          },
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'I agree to the Terms and Conditions',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'By checking this box, you agree to our terms of service and privacy policy.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              TextButton(
                onPressed: _showTermsDialog,
                child: const Text('View Terms and Conditions'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Information',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildPaymentRow('Course Fee:', '\$$_programPrice'),
                const SizedBox(height: 8),
                _buildPaymentRow('Tax:', '\$0.00'),
                const Divider(height: 24),
                _buildPaymentRow(
                  'Total Amount:',
                  '\$$_programPrice',
                  isTotal: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.bold,
            color: isTotal ? Colors.blue : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _submitEnrollment,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: _isSubmitting
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'Complete Enrollment',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: _isSubmitting ? null : () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ),
      ],
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms and Conditions'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                '1. Enrollment Terms\n'
                '2. Payment Terms\n'
                '3. Refund Policy\n'
                '4. Course Access\n'
                '5. Privacy Policy\n\n'
                'By enrolling in this course, you agree to all terms and conditions.',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
