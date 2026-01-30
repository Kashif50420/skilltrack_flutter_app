import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/constants.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'New Course Available',
      'message': 'Machine Learning Fundamentals course is now available.',
      'type': 'course',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      'read': false,
      'icon': Icons.school,
      'color': Colors.blue,
    },
    {
      'id': '2',
      'title': 'Assignment Due',
      'message': 'Flutter Module 3 assignment is due tomorrow.',
      'type': 'assignment',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'read': false,
      'icon': Icons.assignment,
      'color': Colors.green,
    },
    {
      'id': '3',
      'title': 'Webinar Reminder',
      'message': 'Join our expert session on Flutter at 3 PM today.',
      'type': 'event',
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'read': true,
      'icon': Icons.event,
      'color': Colors.orange,
    },
    {
      'id': '4',
      'title': 'Certificate Ready',
      'message': 'Your certificate for "Web Development" is ready to download.',
      'type': 'certificate',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'read': true,
      'icon': Icons.verified,
      'color': Colors.purple,
    },
    {
      'id': '5',
      'title': 'System Update',
      'message': 'New app update available with improved features.',
      'type': 'system',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'read': true,
      'icon': Icons.system_update,
      'color': Colors.red,
    },
    {
      'id': '6',
      'title': 'Course Progress',
      'message': 'You have completed 75% of "Mobile Development" course.',
      'type': 'progress',
      'timestamp': DateTime.now().subtract(const Duration(days: 3)),
      'read': true,
      'icon': Icons.trending_up,
      'color': Colors.teal,
    },
  ];

  bool _showOnlyUnread = false;

  @override
  Widget build(BuildContext context) {
    final filteredNotifications = _showOnlyUnread
        ? _notifications.where((n) => !n['read']).toList()
        : _notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppConstants.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            onPressed: _markAllAsRead,
            tooltip: 'Mark all as read',
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _clearAllNotifications,
            tooltip: 'Clear all',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chip
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Unread Only'),
                  selected: _showOnlyUnread,
                  onSelected: (selected) {
                    setState(() => _showOnlyUnread = selected);
                  },
                ),
                const Spacer(),
                Text(
                  '${_notifications.where((n) => !n['read']).length} unread',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          // Notifications List
          Expanded(
            child: filteredNotifications.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No notifications',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = filteredNotifications[index];
                      return _buildNotificationCard(notification);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isUnread = !notification['read'];

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: 4,
      ),
      color: isUnread ? Colors.blue.shade50 : null,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: notification['color'].withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            notification['icon'],
            color: notification['color'],
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification['title'],
                style: TextStyle(
                  fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isUnread)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification['message']),
            const SizedBox(height: 4),
            Text(
              _formatTimeAgo(notification['timestamp']),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleNotificationAction(value, notification),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'mark_read',
              child: Row(
                children: [
                  Icon(Icons.mark_email_read, size: 18),
                  SizedBox(width: 8),
                  Text('Mark as read'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        onTap: () => _handleNotificationTap(notification),
      ),
    );
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, yyyy').format(timestamp);
    }
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    // Mark as read on tap
    setState(() {
      notification['read'] = true;
    });

    // Navigate based on notification type
    switch (notification['type']) {
      case 'course':
        // Navigate to course detail
        break;
      case 'assignment':
        // Navigate to assignment
        break;
      case 'certificate':
        // Navigate to certificate screen
        break;
      // Add other cases as needed
    }
  }

  void _handleNotificationAction(
      String action, Map<String, dynamic> notification) {
    switch (action) {
      case 'mark_read':
        setState(() => notification['read'] = true);
        break;
      case 'delete':
        _deleteNotification(notification['id']);
        break;
    }
  }

  void _deleteNotification(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Notification'),
        content:
            const Text('Are you sure you want to delete this notification?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _notifications.removeWhere((n) => n['id'] == id);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _markAllAsRead() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark all as read'),
        content: const Text('Mark all notifications as read?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                for (var notification in _notifications) {
                  notification['read'] = true;
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Mark All'),
          ),
        ],
      ),
    );
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All'),
        content: const Text(
            'Clear all notifications? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _notifications.clear());
              Navigator.pop(context);
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
