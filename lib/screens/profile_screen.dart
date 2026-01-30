import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../models/user_model.dart';
import '../providers/app_provider.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final String userEmail;

  const ProfileScreen({
    Key? key,
    required this.userName,
    required this.userEmail,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User _user;
  bool _isEditing = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  final _educationController = TextEditingController();
  final _experienceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _educationController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  void _initializeUser() {
    _user = User(
      id: '1',
      name: widget.userName,
      email: widget.userEmail,
      userType: 'learner',
      phone: '+92 300 1234567',
      bio:
          'I am a passionate learner interested in technology and programming.',
      education: 'Currently learning on Silk Track',
      experience: 'Beginner in programming',
      skills: ['Flutter', 'Dart', 'UI Design'],
      createdAt: DateTime.now(),
    );
  }

  void _loadUserData() {
    _nameController.text = _user.name;
    _emailController.text = _user.email;
    _phoneController.text = _user.phone ?? '';
    _bioController.text = _user.bio ?? '';
    _educationController.text = _user.education ?? '';
    _experienceController.text = _user.experience ?? '';
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name and email are required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isEditing = false;
    });

    try {
      final provider = Provider.of<AppProvider>(context, listen: false);
      
      final profileData = {
        'id': _user.id,
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'userType': _user.userType,
        'phone': _phoneController.text.trim(),
        'bio': _bioController.text.trim(),
        'education': _educationController.text.trim(),
        'experience': _experienceController.text.trim(),
        'skills': _user.skills ?? [],
      };

      final result = await provider.updateProfile(profileData);

      if (result['success'] == true) {
        setState(() {
          _user = User(
            id: _user.id,
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            userType: _user.userType,
            phone: _phoneController.text.trim(),
            bio: _bioController.text.trim(),
            education: _educationController.text.trim(),
            experience: _experienceController.text.trim(),
            skills: _user.skills ?? [],
            createdAt: _user.createdAt,
          );
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        setState(() => _isEditing = true);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to update profile'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isEditing = true);
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

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _loadUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final stats = provider.learnerStats;

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context, stats),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Profile'),
      backgroundColor: AppConstants.primaryColor,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(_isEditing ? Icons.save : Icons.edit),
          onPressed: _isEditing
              ? _saveProfile
              : () => setState(() => _isEditing = true),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, Map<String, dynamic> stats) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildProfileImage(),
          const SizedBox(height: 20),
          _buildNameField(),
          const SizedBox(height: 8),
          _buildEmailField(),
          const SizedBox(height: 24),
          _buildStatsSection(stats),
          const SizedBox(height: 24),
          _buildBioSection(),
          const SizedBox(height: 24),
          _buildContactSection(),
          const SizedBox(height: 24),
          _buildEducationSection(),
          const SizedBox(height: 24),
          _buildExperienceSection(),
          const SizedBox(height: 24),
          _buildSkillsSection(),
          const SizedBox(height: 32),
          if (_isEditing) _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: AppConstants.primaryColor,
          child: Text(
            _user.name.isNotEmpty ? _user.name[0].toUpperCase() : 'U',
            style: const TextStyle(
              fontSize: 40,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Icon(
              Icons.camera_alt,
              size: 20,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return _isEditing
        ? TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.person),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter your name'
                : null,
          )
        : Text(
            _user.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
          );
  }

  Widget _buildEmailField() {
    return _isEditing
        ? TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.email),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          )
        : Text(
            _user.email,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          );
  }

  Widget _buildStatsSection(Map<String, dynamic> stats) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              value: stats['totalCourses']?.toString() ?? '0',
              label: 'Courses',
              icon: Icons.school,
              color: Colors.blue,
            ),
            _buildStatItem(
              value:
                  '${((stats['averageProgress'] ?? 0.0) * 100).toStringAsFixed(0)}%',
              label: 'Progress',
              icon: Icons.trending_up,
              color: Colors.green,
            ),
            _buildStatItem(
              value: stats['totalHours']?.toString() ?? '0',
              label: 'Hours',
              icon: Icons.access_time,
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color.fromRGBO(color.red, color.green, color.blue, 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildBioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.info, color: Colors.blue, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Bio',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _isEditing
            ? TextFormField(
                controller: _bioController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  border: const OutlineInputBorder(),
                  hintText: 'Tell us about yourself',
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              )
            : Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _user.bio ?? 'No bio added',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.contact_phone, color: Colors.blue, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(AppConstants.defaultBorderRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildContactField(
                  icon: Icons.phone,
                  label: 'Phone',
                  value: _user.phone,
                  controller: _phoneController,
                  fieldName: 'phone',
                ),
                const SizedBox(height: 12),
                _buildContactField(
                  icon: Icons.email,
                  label: 'Email',
                  value: _user.email,
                  controller: null,
                  fieldName: 'email',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactField({
    required IconData icon,
    required String label,
    required String? value,
    required TextEditingController? controller,
    required String fieldName,
  }) {
    return _isEditing && controller != null
        ? TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
              prefixIcon: Icon(icon),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          )
        : ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon, color: Colors.blue),
            title: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            subtitle: Text(
              value ?? 'Not provided',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
  }

  Widget _buildEducationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.school, color: Colors.blue, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Education',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _isEditing
            ? TextFormField(
                controller: _educationController,
                decoration: InputDecoration(
                  labelText: 'Education',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.school),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              )
            : Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.defaultBorderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.school,
                        color: AppConstants.primaryColor,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _user.education ?? 'Not provided',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildExperienceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.work, color: Colors.blue, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Experience',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _isEditing
            ? TextFormField(
                controller: _experienceController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Experience',
                  border: const OutlineInputBorder(),
                  hintText: 'Describe your experience',
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              )
            : Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.defaultBorderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.work,
                        color: AppConstants.primaryColor,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _user.experience ?? 'Not provided',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildSkillsSection() {
    final skills = _user.skills ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.code, color: Colors.blue, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Skills',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills
              .map((skill) => Chip(
                    label: Text(skill),
                    backgroundColor: Colors.blue.withAlpha(25),
                    labelStyle: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppConstants.defaultBorderRadius),
              ),
            ),
            child: const Text(
              'Save Changes',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _cancelEditing,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppConstants.defaultBorderRadius),
              ),
              side: BorderSide(color: Colors.grey.shade400),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
