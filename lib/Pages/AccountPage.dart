import 'package:flutter/material.dart';
import 'package:online_banking_system/Pages/ProfilePage.dart';
import 'package:online_banking_system/widgets/Accounts.dart';
import '../Models/AccountContract.dart';
import '../Models/ApiService.dart';
import '../widgets/AccountDetails.dart';
import 'NotificationPage.dart';
import 'AddAccountPage.dart';

class AccountPage extends StatefulWidget {
  final Map<String, dynamic>? accountData;

  AccountPage({this.accountData});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  AccountContract? accountData;
  bool _isLoading = true;
  bool _isBalanceHidden = false;

  // Sample data for multiple accounts
  final List<Map<String, dynamic>> accounts = [
    {
      'accountName': 'Main Account',
      'cardNumber': '**** 8832',
      'balance': 8846.00,
      'cardType': 'Mastercard',
      'color': Color(0xFF341813),
    },
    {
      'accountName': 'Savings Account',
      'cardNumber': '**** 4567',
      'balance': 12350.75,
      'cardType': 'Visa',
      'color': Color(0xFFFF3800),
    },
    {
      'accountName': 'Investment Account',
      'cardNumber': '**** 9012',
      'balance': 5250.50,
      'cardType': 'Visa',
      'color': Color(0xFF00B4D8),
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchAccountData();
    if (widget.accountData != null) {
      print("Received Account Data: ${widget.accountData}");
    }
  }

  Future<void> fetchAccountData() async {
    try {
      print("Fetching account data...");
      final account = await ApiService().fetchAccountContracts("5176632120");
      print("Account Data Fetched: ${account.accountContractName}");

      setState(() {
        accountData = account as AccountContract?;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching account data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceHidden = !_isBalanceHidden;
    });
  }

  void _navigateToAccountDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AccountDetailsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('My Accounts'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
          ),
          IconButton(
            icon: CircleAvatar(
              radius: 14,
              child: Icon(Icons.person, size: 18),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Balance visibility toggle
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Accounts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: _toggleBalanceVisibility,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isBalanceHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 18,
                          color: Colors.blue.shade700,
                        ),
                        SizedBox(width: 4),
                        Text(
                          _isBalanceHidden ? 'Show Balance' : 'Hide Balance',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Account cards - compact scrollable list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                return Accounts(
                  accountName: account['accountName'],
                  cardNumber: account['cardNumber'],
                  balance: account['balance'],
                  cardType: account['cardType'],
                  color: account['color'],
                  isBalanceHidden: _isBalanceHidden,
                  onTap: () => _navigateToAccountDetails(context),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        onPressed: () => _navigateToAddAccount(context),
      ),
    );
  }

  void _navigateToAddAccount(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddAccountPage()),
    );
  }
}

extension on List<AccountContract> {
  get accountContractName => accountContractName;
}