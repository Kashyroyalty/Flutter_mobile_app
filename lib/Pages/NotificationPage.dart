import 'package:flutter/material.dart';

// Notification Item Model
class NotificationItem {
  final String title;
  final String message;
  final String time;
  final String date;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.date,
  });
}

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showUnreadOnly = false;

  // Sample notification data
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: 'Mobile Money',
      message: '99.00 KES was successfully sent',
      time: '10:10 am',
      date: '26/01/2025',
    ),
    NotificationItem(
      title: 'Mobile Money',
      message: '99.00 KES was successfully sent',
      time: '10:10 am',
      date: '26/01/2025',
    ),
    NotificationItem(
      title: 'Mobile Money',
      message: '100.00 KES was successfully sent',
      time: '10:10 am',
      date: '26/01/2025',
    ),
    NotificationItem(
      title: 'Mobile Money',
      message: '100.00 KES was successfully sent',
      time: '10:10 am',
      date: '26/01/2025',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Notifications'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            color: Colors.red,
            onPressed: () {
              // Handle settings tap
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications history',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'You have ${notifications.length} unread messages',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Bank account alerts'),
              Tab(text: 'Transactions'),
            ],
            labelColor: Colors.red,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.red,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Switch(
                      value: _showUnreadOnly,
                      onChanged: (value) {
                        setState(() {
                          _showUnreadOnly = value;
                        });
                      },
                      activeColor: Colors.red,
                    ),
                    Text('Unread only'),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // Handle mark all as read
                  },
                  child: Text(
                    'Mark all as read',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // All notifications tab
                _buildNotificationsList(notifications),
                // Bank account alerts tab
                _buildNotificationsList(notifications),
                // Transactions tab
                _buildNotificationsList(notifications),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(List<NotificationItem> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final notification = items[index];
        return ListTile(
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.notifications_outlined, color: Colors.red),
          ),
          title: Text(
            notification.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification.message),
              Text(
                '${notification.time} • ${notification.date}',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Handle more options
            },
          ),
        );
      },
    );
  }
}

// Add this to your main app bar to navigate to the notifications page
class NotificationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.notifications),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationsPage()),
        );
      },
    );
  }
}