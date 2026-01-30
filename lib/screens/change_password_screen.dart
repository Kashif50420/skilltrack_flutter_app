import 'package:flutter/material.dart';
import '../constants/constants.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Update your password to keep your account secure.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 32),

              // Current Password
              const Text(
                'Current Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _currentPasswordController,
                obscureText: _obscureCurrentPassword,
                decoration: InputDecoration(
                  hintText: 'Enter your current password',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureCurrentPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureCurrentPassword = !_obscureCurrentPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter current password';
                  }
                  if (value.length < AppConstants.minPasswordLength) {
                    return 'Password must be at least ${AppConstants.minPasswordLength} characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // New Password
              const Text(
                'New Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureNewPassword,
                decoration: InputDecoration(
                  hintText: 'Enter new password',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNewPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter new password';
                  }
                  if (value.length < AppConstants.minPasswordLength) {
                    return 'Password must be at least ${AppConstants.minPasswordLength} characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 8),
              _buildPasswordRequirements(),

              const SizedBox(height: 24),

              // Confirm Password
              const Text(
                'Confirm New Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  hintText: 'Re-enter new password',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_reset),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 40),

              // Update Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _changePassword,
                        child: const Text('Update Password'),
                      ),
              ),

              const SizedBox(height: 16),

              // Forgot Password
              Center(
                child: TextButton(
                  onPressed: _forgotPassword,
                  child: const Text('Forgot Password?'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordRequirements() {
    final password = _newPasswordController.text;

    final requirements = [
      {
        'text': 'At least ${AppConstants.minPasswordLength} characters',
        'met': password.length >= AppConstants.minPasswordLength,
      },
      {
        'text': 'Contains uppercase letter',
        'met': password.contains(RegExp(r'[A-Z]')),
      },
      {
        'text': 'Contains lowercase letter',
        'met': password.contains(RegExp(r'[a-z]')),
      },
      {
        'text': 'Contains number',
        'met': password.contains(RegExp(r'[0-9]')),
      },
      {
        'text': 'Contains special character',
        'met': password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password must contain:',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        ...requirements.map((req) {
          return Row(
            children: [
              Icon(
                req['met'] ? Icons.check_circle : Icons.circle,
                size: 12,
                color: req['met'] ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                req['text'],
                style: TextStyle(
                  fontSize: 11,
                  color: req['met'] ? Colors.green : Colors.grey,
                ),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate API call - in real app, call your backend
    await Future.delayed(const Duration(seconds: 2));

    // Check if new password is same as old
    if (_currentPasswordController.text == _newPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New password must be different from current password'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _isLoading = false);
      return;
    }

    // Success
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password updated successfully'),
        backgroundColor: Colors.green,
      ),
    );

    // Clear fields
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();

    setState(() => _isLoading = false);
  }

  void _forgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Forgot Password'),
        content: const Text(
          'Please contact support at support@silktrack.com '
          'to reset your password.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
