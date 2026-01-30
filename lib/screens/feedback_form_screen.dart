import 'package:flutter/material.dart';
import '../services/data_service.dart';

class FeedbackFormScreen extends StatefulWidget {
  const FeedbackFormScreen({super.key});

  @override
  State<FeedbackFormScreen> createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends State<FeedbackFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _feedbackController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback Form'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNameField(),
              const SizedBox(height: 20),
              _buildEmailField(),
              const SizedBox(height: 20),
              _buildFeedbackField(),
              const SizedBox(height: 30),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Name',
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(),
        hintText: 'Enter your full name',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your name';
        }
        if (value.length < 2) {
          return 'Name must be at least 2 characters';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(),
        hintText: 'Enter your email address',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }

        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
        if (!emailRegex.hasMatch(value)) {
          return 'Please enter a valid email address';
        }

        return null;
      },
    );
  }

  Widget _buildFeedbackField() {
    return TextFormField(
      controller: _feedbackController,
      decoration: const InputDecoration(
        labelText: 'Feedback',
        prefixIcon: Icon(Icons.feedback),
        border: OutlineInputBorder(),
        hintText: 'Please share your feedback, suggestions, or issues...',
        alignLabelWithHint: true,
      ),
      maxLines: 5,
      minLines: 3,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your feedback';
        }
        if (value.length < 10) {
          return 'Feedback must be at least 10 characters';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: _isSubmitting
          ? const Center(child: CircularProgressIndicator())
          : ElevatedButton(
              onPressed: _submitFeedback,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Submit Feedback',
                style: TextStyle(fontSize: 16),
              ),
            ),
    );
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final success = await DataService.sendFeedback(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        feedback: _feedbackController.text.trim(),
      );

      if (success) {
        _showSuccessMessage();
        _clearForm();
      } else {
        _showErrorMessage('Failed to submit feedback. Please try again.');
      }
    } catch (e) {
      _showErrorMessage('Error: ${e.toString()}');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feedback submitted successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _feedbackController.clear();
  }
}
