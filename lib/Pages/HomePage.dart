import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_banking_system/Pages/LoginPage.dart';
import 'package:online_banking_system/Pages/NotificationPage.dart';
import 'package:online_banking_system/Pages/ProfilePage.dart';
import 'package:online_banking_system/Pages/SettingPage.dart';
import '../Models/ApiService.dart';
import '../Models/TransactionContract.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ApiService apiService;
  int? clientId;
  String? clientName;
  List<String> accounts = [];
  String? selectedAccount;
  double? accountBalance;
  bool _showBalance = false;

  List<String> cards = [];
  String? selectedCard;
  double? cardBalance;
  bool _showCardBalance = false;

  bool _isLoading = true;
  bool _isBalanceHidden = true;

  List<TransactionContract> _transactions = [];
  DateTime? _startDate;
  DateTime? _endDate;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
    void initState() {
      super.initState();
        apiService = ApiService();
          fetchClientId();
  }

  Future<void> fetchClientId() async {
    try {
      int? fetchedClientId = await apiService.getClientId();

      if (fetchedClientId == null) {
        throw Exception("Client ID not found");
      }

      setState(() {
        clientId = fetchedClientId;
        _isLoading = false;
      });

      print("Client ID successfully retrieved: $clientId");

      // Call fetchClientData after setting clientId
      fetchClientData();
    } catch (e) {
      print("Error fetching client ID: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }



  Future<void> fetchClientData() async {
    if (clientId == null) return;
    try {
      var clientData = await apiService.fetchClientData(clientId!.toString());

      setState(() {
        clientName = clientData["firstName"];
        accounts = List<String>.from(clientData["accounts"].keys);
        selectedAccount = accounts.isNotEmpty ? accounts[0] : null;
        accountBalance = selectedAccount != null ? clientData["accounts"][selectedAccount] : 0.0;

        cards = List<String>.from(clientData["cards"].keys);
        selectedCard = cards.isNotEmpty ? cards[0] : null;
        cardBalance = selectedCard != null ? clientData["cards"][selectedCard] : 0.0;
      });
    } catch (e) {
      print("Error fetching client details: $e");
    }
  }



  Future<void> fetchTransactionContract() async {
    if (clientId == null) return;
    try {
      List<TransactionContract> fetchedTransactions =
      (await apiService.fetchTransactionContract(clientId!.toString())) as List<TransactionContract>;
      setState(() {
        _transactions = fetchedTransactions;
      });
    } catch (e) {
      print("Error fetching transactions: $e");
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  List<TransactionContract> getFilteredTransactions() {
    return _transactions.where((transaction) {
      if (_startDate != null && transaction.date.isBefore(_startDate!)) {
        return false;
      }
      if (_endDate != null && transaction.date.isAfter(_endDate!)) {
        return false;
      }
      return true;
    }).toList();
  }

  void _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }
  void _navigateTo(String route) {
    // Close the drawer first
    Navigator.pop(context);

    // Handle navigation logic
    switch (route) {
      case 'home':
      // Already on home page
        break;
      case 'cards':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigating to Cards page')),
        );
        break;
      case 'transfers':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigating to Transfers page')),
        );
        break;
      case 'payments':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigating to Payments page')),
        );
        break;
      case 'settings':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigating to Settings page')),
        );
        break;
      case 'help':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigating to Help & Support page')),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFF5F5F5),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightBlue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'User Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
                leading: Icon(Icons.person, size: 18),
                title: Text('Profile'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                }
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.help_outline),
              title: Text('Help & Support'),
              onTap: () => _navigateTo('help'),
            ),
            Divider(),
            ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text('Logout', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Header with menu icon, greeting and notification
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Added menu icon here
                  Expanded(
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.menu),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                        SizedBox(width: 15),
                        Expanded(  // Add Expanded here to prevent overflow
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_getGreeting()}, ${clientName ?? "User"}',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,  // Added to handle potential text overflow
                              ),
                              Text(
                                'Welcome to Dashen Bank',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,  // Added to handle potential text overflow
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
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
                ],
              ),
            ),

            // Balance container with fixed icon position
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton<String>(
                    value: selectedAccount,
                    items: accounts.map((String account) {
                      return DropdownMenuItem<String>(
                        value: account,
                        child: Text(account), // Show account name
                      );
                    }).toList(),
                    onChanged: (newAccount) {
                      setState(() {
                        selectedAccount = newAccount;
                        accountBalance = newAccount != null ? apiService.getAccountBalance(clientId! as String, newAccount) : 0.0;
                      });
                    },
                  ),

                  Text(
                    _showBalance ? '\$${accountBalance?.toStringAsFixed(2) ?? "0.00"}' : '••••••',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(_showBalance ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _showBalance = !_showBalance;
                      });
                    },
                  ),
                ],
              ),
            ),
// Your cards section
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton<String>(
                    value: selectedCard,
                    items: cards.map((String card) {
                      return DropdownMenuItem<String>(
                        value: card,
                        child: Text(card), // Show card name
                      );
                    }).toList(),
                    onChanged: (newCard) {
                      setState(() {
                        selectedCard = newCard;
                        cardBalance = newCard != null ? apiService.getCardBalance(clientId! as String, newCard) : 0.0;
                      });
                    },
                  ),

                  Text(
                    _showCardBalance ? '\$${cardBalance?.toStringAsFixed(2) ?? "0.00"}' : '••••••',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(_showCardBalance ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _showCardBalance = !_showCardBalance;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Transactions section
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transactions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () => _selectDateRange(context),
                            icon: Icon(Icons.calendar_today, size: 14),
                            label: Text(
                              _startDate == null
                                  ? 'Filter'
                                  : '${DateFormat('MMM dd').format(_startDate!)} - ${DateFormat('MMM dd').format(_endDate!)}',
                              style: TextStyle(fontSize: 12),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(horizontal: 4),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('See all'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(horizontal: 4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),

            // Transaction list
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: getFilteredTransactions().length,
                  itemBuilder: (context, index) {
                    final transaction = getFilteredTransactions()[index];
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: Icon(
                          Icons.shopping_bag,
                          color: Colors.black,
                        ),
                      ),
                      title: Text(
                        transaction.transactionDescription ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat('MMMM dd, hh:mm a').format(transaction.date),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            transaction.count < 0
                                ? '-\$${transaction.count.abs().toStringAsFixed(2)}'
                                : '+\$${transaction.count.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: transaction.count < 0 ? Colors.black : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (transaction.count > 0)
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '+${transaction.count.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}