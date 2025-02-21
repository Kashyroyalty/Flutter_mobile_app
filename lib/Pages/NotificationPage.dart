import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:online_banking_system/Models/TransactionContract.dart';
import 'dart:convert';
import 'package:online_banking_system/Pages/SettingPage.dart';

import '../Models/ApiService.dart';
import '../Models/NotificationContract.dart';

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

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      title: json['title'] ?? 'Unknown',
      message: json['message'] ?? '',
      time: json['time'] ?? '',
      date: json['date'] ?? '',
    );
  }
}

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  NotificationContract? notificationContract;
  TransactionContract? transactionContract;
  bool _showUnreadOnly = false;
  bool _isLoading = true;
  bool _hasError = false;

  List<NotificationItem> bankAlerts = [];
  List<NotificationItem> transactions = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchTransactionContract();
    fetchNotificationContracts();
  }

  Future<void> fetchNotificationContracts() async {
    try {
      var notificationContract = await ApiService().fetchNotificationContracts("338302830");
      setState(() {
        notificationContract = notificationContract;

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> fetchTransactionContract() async {
    try {
       transactionContract = await ApiService().fetchTransactionContract("5176632120");
      setState(() {
        transactionContract = transactionContract;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
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
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'You have ${(bankAlerts.length + transactions.length)} unread messages',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
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
                  onPressed: () {},
                  child: Text('Mark all as read', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNotificationsList([...bankAlerts, ...transactions]),
                _buildNotificationsList(bankAlerts),
                _buildNotificationsList(transactions),
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
            decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
            child: Icon(Icons.notifications_outlined, color: Colors.red),
          ),
          title: Text(notification.title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification.message),
              Text('${notification.time} • ${notification.date}', style: TextStyle(color: Colors.grey)),
            ],
          ),
          trailing: IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        );
      },
    );
  }
}

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
