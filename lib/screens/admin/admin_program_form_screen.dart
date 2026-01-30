import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/program_model.dart';
import '../../providers/app_provider.dart';

class AdminProgramFormScreen extends StatefulWidget {
  final Program? program; // null for add, existing for edit

  const AdminProgramFormScreen({super.key, this.program});

  @override
  State<AdminProgramFormScreen> createState() => _AdminProgramFormScreenState();
}

class _AdminProgramFormScreenState extends State<AdminProgramFormScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _durationController;
  late TextEditingController _levelController;
  late TextEditingController _priceController;
  late TextEditingController _instructorController;
  late TextEditingController _detailedDescController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.program?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.program?.description ?? '');
    _categoryController =
        TextEditingController(text: widget.program?.category ?? '');
    _durationController =
        TextEditingController(text: widget.program?.duration.toString() ?? '');
    _levelController = TextEditingController(text: widget.program?.level ?? widget.program?.difficulty ?? '');
    _priceController =
        TextEditingController(text: widget.program?.price.toString() ?? '');
    _instructorController =
        TextEditingController(text: widget.program?.instructor ?? '');
    _detailedDescController =
        TextEditingController(text: widget.program?.detailedDescription ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _durationController.dispose();
    _levelController.dispose();
    _priceController.dispose();
    _instructorController.dispose();
    _detailedDescController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final provider = Provider.of<AppProvider>(context, listen: false);
      
      final programData = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _categoryController.text.trim(),
        'duration': int.tryParse(_durationController.text.trim()) ?? 8,
        'level': _levelController.text.trim().isEmpty ? 'Beginner' : _levelController.text.trim(),
        'difficulty': _levelController.text.trim().isEmpty ? 'Beginner' : _levelController.text.trim(),
        'price': double.tryParse(_priceController.text.trim()) ?? 0.0,
        'instructor': _instructorController.text.trim(),
        'detailedDescription': _detailedDescController.text.trim().isEmpty 
            ? _descriptionController.text.trim() 
            : _detailedDescController.text.trim(),
        'rating': 4.5,
        'enrolledStudents': 0,
        'totalStudents': 0,
        'isActive': true,
        'skills': [],
        'modules': [],
        'provider': 'Skill Track',
        'startDate': DateTime.now().toIso8601String(),
        'endDate': DateTime.now().add(Duration(days: (int.tryParse(_durationController.text.trim()) ?? 8) * 7)).toIso8601String(),
      };

      Map<String, dynamic> result;
      if (widget.program == null) {
        result = await provider.createProgram(programData);
      } else {
        // For update, we'll use createProgram with existing ID
        programData['id'] = widget.program!.id;
        result = await provider.createProgram(programData);
      }

      setState(() => _isLoading = false);

      if (result['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.program == null 
                  ? 'Program created successfully' 
                  : 'Program updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Operation failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
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
        title: Text(widget.program == null ? 'Add Program' : 'Edit Program'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Title*', _titleController),
            const SizedBox(height: 16),
            _buildTextField('Description*', _descriptionController,
                maxLines: 3),
            const SizedBox(height: 16),
            _buildTextField('Category*', _categoryController),
            const SizedBox(height: 16),
            _buildTextField('Duration', _durationController),
            const SizedBox(height: 16),
            _buildTextField('Level', _levelController),
            const SizedBox(height: 16),
            _buildTextField('Price', _priceController,
                keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildTextField('Instructor', _instructorController),
            const SizedBox(height: 16),
            _buildTextField('Detailed Description', _detailedDescController,
                maxLines: 4),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  disabledBackgroundColor: Colors.grey,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        widget.program == null
                            ? 'Create Program'
                            : 'Update Program',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
