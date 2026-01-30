import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:silk_track/providers/app_provider.dart';
import 'package:silk_track/screens/admin/admin_programs_screen.dart';
import 'package:silk_track/screens/admin/admin_learners_screen.dart';
import 'package:silk_track/screens/admin/admin_analytics_screen.dart';
import 'package:silk_track/screens/admin/admin_settings_screen.dart';
import 'package:silk_track/screens/admin/admin_program_form_screen.dart';
import 'package:silk_track/screens/profile_screen.dart';
import 'package:silk_track/screens/auth/login_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  List<Widget> get _adminPages => [
    DashboardHome(
      onNavigateToPrograms: () => setState(() => _currentIndex = 1),
      onNavigateToLearners: () => setState(() => _currentIndex = 2),
    ),
    const AdminProgramsScreen(),
    const AdminLearnersScreen(),
    const AdminAnalyticsScreen(),
    const AdminSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final provider = Provider.of<AppProvider>(context, listen: false);
              await provider.logout();
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Consumer<AppProvider>(
              builder: (context, provider, _) {
                final userName = provider.userName ?? 'Admin';
                final userEmail = provider.userEmail ?? 'admin@example.com';
                final firstName = userName.split(' ').first;
                
                return DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue[800]!,
                        Colors.blue[600]!,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to profile - we'll add profile screen later
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            userName: userName,
                            userEmail: userEmail,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Text(
                            firstName.isNotEmpty 
                                ? firstName[0].toUpperCase() 
                                : 'A',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Welcome, $firstName!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          userEmail,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            _buildDrawerItem(Icons.dashboard, 'Dashboard', 0),
            _buildDrawerItem(Icons.school, 'Programs', 1),
            _buildDrawerItem(Icons.people, 'Learners', 2),
            _buildDrawerItem(Icons.timeline, 'Progress', 3),
            _buildDrawerItem(Icons.settings, 'Settings', 4),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: () async {
                final provider = Provider.of<AppProvider>(context, listen: false);
                await provider.logout();
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: _adminPages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Programs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Learners',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: _currentIndex == index,
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
        Navigator.pop(context);
      },
    );
  }
}

class DashboardHome extends StatelessWidget {
  final VoidCallback? onNavigateToPrograms;
  final VoidCallback? onNavigateToLearners;

  const DashboardHome({
    super.key,
    this.onNavigateToPrograms,
    this.onNavigateToLearners,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section with Admin Name - Clickable
          Consumer<AppProvider>(
            builder: (context, provider, _) {
              final userName = provider.userName ?? 'Admin';
              final userEmail = provider.userEmail ?? 'admin@example.com';
              final firstName = userName.split(' ').first;
              
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        userName: userName,
                        userEmail: userEmail,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue[600]!,
                        Colors.blue[800]!,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Text(
                          firstName.isNotEmpty 
                              ? firstName[0].toUpperCase() 
                              : 'A',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back, $firstName!',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Manage programs and track learner progress',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          // Stats Overview - Clickable Cards
          const Text(
            'Overview',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard(
                context,
                'Total Programs',
                '15',
                Icons.school,
                Colors.blue,
                () => onNavigateToPrograms?.call(),
              ),
              _buildStatCard(
                context,
                'Active Learners',
                '245',
                Icons.people,
                Colors.green,
                () => onNavigateToLearners?.call(),
              ),
              _buildStatCard(
                context,
                'Completion Rate',
                '78%',
                Icons.trending_up,
                Colors.amber,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminAnalyticsScreen(),
                  ),
                ),
              ),
              _buildStatCard(
                context,
                'Pending Actions',
                '5',
                Icons.notifications,
                Colors.red,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No pending actions')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Recent Activities
          const Text(
            'Recent Activities',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildActivityItem(
                    'New enrollment in Flutter Bootcamp',
                    '2 hours ago',
                  ),
                  const Divider(),
                  _buildActivityItem(
                    'John Doe completed Web Development course',
                    '5 hours ago',
                  ),
                  const Divider(),
                  _buildActivityItem(
                    'New program created: Data Science Fundamentals',
                    '1 day ago',
                  ),
                  const Divider(),
                  _buildActivityItem(
                    '3 certificates issued',
                    '2 days ago',
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2,
            children: [
              _buildActionCard(
                'Add New Program',
                Icons.add_circle,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminProgramFormScreen(),
                    ),
                  );
                },
              ),
              _buildActionCard(
                'View Learners',
                Icons.people,
                () {
                  onNavigateToLearners?.call();
                },
              ),
              _buildActionCard(
                'Generate Reports',
                Icons.assessment,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminAnalyticsScreen(),
                    ),
                  );
                },
              ),
              _buildActionCard(
                'Send Notifications',
                Icons.notification_add,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notification feature coming soon')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context, String title, String value, IconData icon, Color color, VoidCallback? onTap) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String time) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blue[100],
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.notifications, color: Colors.blue),
      ),
      title: Text(title),
      subtitle: Text(
        time,
        style: TextStyle(color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.blue),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
