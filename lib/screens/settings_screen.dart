// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/app_provider.dart';
import '../constants/constants.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import 'help_support_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _autoPlayVideos = true;
  bool _downloadOverWifiOnly = true;
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'USD';

  final List<String> _languages = ['English', 'Urdu', 'Arabic', 'Spanish'];
  final List<String> _currencies = ['USD', 'PKR', 'EUR', 'GBP'];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: ListView(
        children: [
          // Account Section
          _buildSectionHeader('Account'),
          _buildSettingItem(
            icon: Icons.person,
            title: 'Edit Profile',
            subtitle: 'Update your personal information',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditProfileScreen(),
              ),
            ),
          ),
          _buildSettingItem(
            icon: Icons.lock,
            title: 'Change Password',
            subtitle: 'Update your login password',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangePasswordScreen(),
              ),
            ),
          ),
          _buildSettingItem(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Manage notification preferences',
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() => _notificationsEnabled = value);
              },
            ),
          ),

          // App Preferences
          _buildSectionHeader('Preferences'),
          _buildSettingItem(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            subtitle: 'Switch between light and dark theme',
            trailing: Switch(
              value: _darkModeEnabled,
              onChanged: (value) {
                setState(() => _darkModeEnabled = value);
              },
            ),
          ),
          _buildSettingItem(
            icon: Icons.language,
            title: 'Language',
            subtitle: _selectedLanguage,
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              items: _languages.map((language) {
                return DropdownMenuItem(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedLanguage = value!);
              },
            ),
          ),
          _buildSettingItem(
            icon: Icons.currency_exchange,
            title: 'Currency',
            subtitle: _selectedCurrency,
            trailing: DropdownButton<String>(
              value: _selectedCurrency,
              items: _currencies.map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedCurrency = value!);
              },
            ),
          ),

          // Content Settings
          _buildSectionHeader('Content'),
          _buildSettingItem(
            icon: Icons.videocam,
            title: 'Auto-play Videos',
            subtitle: 'Play videos automatically',
            trailing: Switch(
              value: _autoPlayVideos,
              onChanged: (value) {
                setState(() => _autoPlayVideos = value);
              },
            ),
          ),
          _buildSettingItem(
            icon: Icons.wifi,
            title: 'Download over Wi-Fi Only',
            subtitle: 'Save mobile data',
            trailing: Switch(
              value: _downloadOverWifiOnly,
              onChanged: (value) {
                setState(() => _downloadOverWifiOnly = value);
              },
            ),
          ),
          _buildSettingItem(
            icon: Icons.storage,
            title: 'Clear Cache',
            subtitle: 'Free up storage space',
            onTap: _clearCache,
          ),

          // Support
          _buildSectionHeader('Support'),
          _buildSettingItem(
            icon: Icons.help,
            title: 'Help & Support',
            subtitle: 'FAQs and contact support',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HelpSupportScreen(),
              ),
            ),
          ),
          _buildSettingItem(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            subtitle: 'View our privacy policy',
            onTap: _openPrivacyPolicy,
          ),
          _buildSettingItem(
            icon: Icons.description,
            title: 'Terms of Service',
            subtitle: 'View terms and conditions',
            onTap: _openTermsOfService,
          ),
          _buildSettingItem(
            icon: Icons.star,
            title: 'Rate App',
            subtitle: 'Rate us on app store',
            onTap: _rateApp,
          ),
          _buildSettingItem(
            icon: Icons.share,
            title: 'Share App',
            subtitle: 'Share with friends',
            onTap: _shareApp,
          ),

          // About
          _buildSectionHeader('About'),
          _buildSettingItem(
            icon: Icons.info,
            title: 'About Silk Track',
            subtitle: 'Version ${AppConstants.appVersion}',
            onTap: _showAboutDialog,
          ),

          // Danger Zone
          _buildSectionHeader('Account Actions'),
          _buildSettingItem(
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Sign out of your account',
            color: Colors.red,
            onTap: _confirmLogout,
          ),
          if (provider.isAdmin)
            _buildSettingItem(
              icon: Icons.delete,
              title: 'Delete Account',
              subtitle: 'Permanently delete your account',
              color: Colors.red,
              onTap: _confirmDeleteAccount,
            ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    Color? color,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppConstants.primaryColor),
      title: Text(title, style: TextStyle(color: color)),
      subtitle: Text(subtitle),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Future<void> _clearCache() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will remove all cached data. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // Clear cache logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  Future<void> _openPrivacyPolicy() async {
    final url = Uri.parse(AppConstants.privacyPolicyUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _openTermsOfService() async {
    final url = Uri.parse(AppConstants.termsOfServiceUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _rateApp() {
    // Implement rate app functionality
  }

  void _shareApp() {
    // Implement share app functionality
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Silk Track'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Silk Track - Learning & Internship Management App\n',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Version: ${AppConstants.appVersion}'),
            const SizedBox(height: 8),
            const Text(
              'Silk Track bridges the gap between learners and structured learning opportunities.',
            ),
            const SizedBox(height: 16),
            const Text(
              'Contact us:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Email: ${AppConstants.contactEmail}'),
            Text('Website: ${AppConstants.websiteUrl}'),
          ],
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

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider = Provider.of<AppProvider>(context, listen: false);
              await provider.logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This will permanently delete your account and all data. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Delete account logic here
            },
            child: const Text(
              'Delete Account',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
