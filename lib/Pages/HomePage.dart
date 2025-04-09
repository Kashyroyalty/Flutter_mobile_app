import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_banking_system/Pages/HelpAndSupportPage.dart';
import 'package:online_banking_system/Pages/LoginPage.dart';
import 'package:online_banking_system/Pages/NotificationPage.dart';
import 'package:online_banking_system/Pages/ProfilePage.dart';
import 'package:online_banking_system/Pages/SettingPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/AccountContract.dart';
import '../Models/ApiService.dart';
import '../Models/CardContract.dart';
import '../Models/TransactionContract.dart';
import 'ProfileProvider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();
  int? clientId;
  String? clientName;

  // Account related fields
  List<String> accounts = [];
  String? selectedAccount;
  double accountBalance = 0.0;
  bool _showBalance = false;

  // Card related fields
  List<String> cards = [];
  String? selectedCard;
  double cardBalance = 0.0;
  bool _showCardBalance = false;

  bool _isLoading = true;
  List<TransactionContract> _transactions = [];
  DateTime? _startDate;
  DateTime? _endDate;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
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
      await fetchClientData();
      await fetchTransactions();
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
      // Fetch basic client data
      var clientData = await apiService.fetchClientData(clientId!.toString());

      // Fetch cards in parallel
      List<CardContract> cardContracts = await apiService.fetchClientCards(clientId!);

      // Fetch accounts in parallel
      List<AccountContract> accountContracts = await apiService.fetchClientAccounts(clientId!);

      setState(() {
        // Set client basic details
        clientName = clientData["firstName"];

        // Process card data
        cards = cardContracts.map((card) => card.cardContractId.toString()).toList();
        selectedCard = cards.isNotEmpty ? cards[0] : null;

        // Check if cards data exists in clientData before accessing
        if (selectedCard != null && clientData.containsKey("cards") && clientData["cards"] != null) {
          var cardData = clientData["cards"][selectedCard];
          cardBalance = cardData != null ? (cardData as num).toDouble() : 0.0;
        } else {
          cardBalance = 0.0;
        }

        // Process account data
        accounts = accountContracts.map((account) => account.accountContractId.toString()).toList();
        selectedAccount = accounts.isNotEmpty ? accounts[0] : null;

        // Check if accounts data exists in clientData before accessing
        if (selectedAccount != null && clientData.containsKey("accounts") && clientData["accounts"] != null) {
          var accountData = clientData["accounts"][selectedAccount];
          accountBalance = accountData != null ? (accountData as num).toDouble() : 0.0;
        } else {
          accountBalance = 0.0;
        }
      });
    } catch (e) {
      print("Error fetching client details: $e");
    }
  }

  Future<void> fetchTransactions() async {
    if (clientId == null) return;
    try {
      // This should fetch a list of transactions for the client
      // NOTE: The API method needs to be adjusted to return a list
      TransactionContract transaction = await apiService.fetchTransactionContract(clientId!.toString());

      // For now, if we only get one transaction, wrap it in a list
      setState(() {
        _transactions = [transaction]; // Temporary solution
      });
    } catch (e) {
      print("Error fetching transactions: $e");
      setState(() {
        _transactions = []; // Initialize to empty list on error
      });
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  List<TransactionContract> getFilteredTransactions() {
    if (_transactions.isEmpty) {
      return [];
    }

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
          const SnackBar(content: Text('Navigating to Cards page')),
        );
        break;
      case 'transfers':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigating to Transfers page')),
        );
        break;
      case 'payments':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigating to Payments page')),
        );
        break;
      case 'settings':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigating to Settings page')),
        );
        break;
      case 'help':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigating to Help & Support page')),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F5F5),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.lightBlue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Consumer<ProfileProvider>(
                        builder: (context, profileProvider, child) {
                          return CircleAvatar(
                            radius: 30, // Adjust size if needed
                            backgroundImage: profileProvider.profileImage != null
                                ? FileImage(profileProvider.profileImage!)
                                : const AssetImage('assets/default_profile.jpg') as ImageProvider,
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      Expanded(  // Prevent text overflow
                        child: Text(
                          clientName ?? 'User Name',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'user@email.com',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
                leading: const Icon(Icons.person, size: 18),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                }
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help and Support'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpAndSupportPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Logout', style: TextStyle(color: Colors.red)),
                onTap: () async {
                  // Call logout method from ApiService
                  await ApiService.logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Header with menu icon, greeting and notification
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Added menu icon here
                  Expanded(
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.menu),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                        const SizedBox(width: 15),
                        Expanded(  // Add Expanded here to prevent overflow
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_getGreeting()}, ${clientName ?? "User"}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Text(
                                'Welcome to Dashen Bank',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
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
                        icon: const Icon(Icons.notifications_outlined),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NotificationsPage()),
                          );
                        },
                      ),
                      IconButton(
                        icon: Consumer<ProfileProvider>(
                          builder: (context, profileProvider, child) {
                            return CircleAvatar(
                              radius: 14,
                              backgroundImage: profileProvider.profileImage != null
                                  ? FileImage(profileProvider.profileImage!)
                                  : const AssetImage('assets/default_profile.jpg') as ImageProvider,
                            );
                          },
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

            // Use Expanded to make the remaining content scrollable
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Account Balance container
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Account Balance',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        accounts.isEmpty
                            ? const Text('No accounts found')
                            : DropdownButton<String>(
                          value: selectedAccount,
                          hint: const Text('Select an account'),
                          isExpanded: true,
                          items: accounts.map((String account) {
                            return DropdownMenuItem<String>(
                              value: account,
                              child: Text('Account $account'),
                            );
                          }).toList(),
                          onChanged: (newAccount) async {
                            if (newAccount != null && clientId != null) {
                              setState(() {
                                selectedAccount = newAccount;
                                accountBalance = apiService.getAccountBalance(clientId.toString(), newAccount);
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _showBalance ? '\$${accountBalance.toStringAsFixed(2)}' : '••••••',
                              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                      ],
                    ),
                  ),

                  // Card Balance container
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Card Balance',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        cards.isEmpty
                            ? const Text('No cards found')
                            : DropdownButton<String>(
                          value: selectedCard,
                          hint: const Text('Select a card'),
                          isExpanded: true,
                          items: cards.map((String card) {
                            return DropdownMenuItem<String>(
                              value: card,
                              child: Text('Card $card'),
                            );
                          }).toList(),
                          onChanged: (newCard) async {
                            if (newCard != null && clientId != null) {
                              setState(() {
                                selectedCard = newCard;
                                cardBalance = apiService.getCardBalance(clientId.toString(), newCard);
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _showCardBalance ? '\$${cardBalance.toStringAsFixed(2)}' : '••••••',
                              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                      ],
                    ),
                  ),

                  // Transactions section header
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
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
                              icon: const Icon(Icons.calendar_today, size: 14),
                              label: Text(
                                _startDate == null
                                    ? 'Filter'
                                    : '${DateFormat('MMM dd').format(_startDate!)} - ${DateFormat('MMM dd').format(_endDate!)}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // View all transactions logic
                              },
                              child: const Text('See all'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Transaction list
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    // Using a constrained height for the transaction list
                    constraints: const BoxConstraints(minHeight: 100, maxHeight: 300),
                    child: getFilteredTransactions().isEmpty
                        ? const Center(child: Text('No transactions available'))
                        : ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true, // Important to work inside ListView
                      physics: const ClampingScrollPhysics(), // Prevents scroll conflicts
                      itemCount: getFilteredTransactions().length,
                      itemBuilder: (context, index) {
                        final transaction = getFilteredTransactions()[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            child: const Icon(
                              Icons.shopping_bag,
                              color: Colors.black,
                            ),
                          ),
                          title: Text(
                            transaction.transactionDescription ?? 'Transaction',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            DateFormat('MMMM dd, hh:mm a').format(transaction.date),
                            style: const TextStyle(
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
                                  margin: const EdgeInsets.only(top: 5),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '+${transaction.count.toStringAsFixed(2)}',
                                    style: const TextStyle(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}