import 'package:flutter/material.dart';
import 'package:online_banking_system/Models/ApiService.dart';
import 'package:online_banking_system/Pages/LoginPage.dart';
import 'dart:ui';
import '../Models/CardContract.dart';
import '../Models/AccountContract.dart';
import '../Models/TransactionContract.dart';
import '../widgets/CardDesign.dart';
import 'ProfilePage.dart';
import 'SettingPage.dart';
import 'package:intl/intl.dart';

// Import the TransactionCategory enum from StatisticsPage
enum TransactionCategory {
  transfer(icon: Icons.swap_horiz),
  shopping(icon: Icons.shopping_bag),
  food(icon: Icons.restaurant),
  topUp(icon: Icons.account_balance_wallet);

  final IconData icon;
  const TransactionCategory({required this.icon});
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _cards = [];
  List<AccountContract> accountData = [];
  AccountContract? _selectedAccount;
  bool _obscureBalance = true;
  List<dynamic> _transactions = [];
  late ApiService apiService;

  get account => account;

  Future<void> fetchCards() async {
    try {
      CardContract contract = await apiService.fetchCardContract("2507355660");
      setState(() {
        _cards.add(contract);
      });
    } catch (e) {
      print("Error fetching card contract: $e");
    }
  }

  void fetchAccounts() async {
    try {
      AccountContract fetchedAccounts = (await apiService.fetchAccountContracts("5176632120")) as AccountContract;

      print("Fetched accounts: $fetchedAccounts");

      setState(() {
        accountData = account as List<AccountContract>;
        if (accountData.isNotEmpty) {
          _selectedAccount = accountData.first;
        }
      });

      print("Selected Account: $_selectedAccount");

    } catch (e) {
      print("Error fetching accounts: $e");
    }
  }

  Future<void> fetchTransactions() async {
    try {
      TransactionContract contract = await apiService.fetchTransactionContract("5176632120");
      setState(() {
        _transactions.add(contract);
      });
    } catch (e) {
      print("Error fetching card contract: $e");
    }
  }

  List getFilteredTransactions() {
    if (_selectedAccount == null) return [];
    return _transactions.where((transaction) {
      return transaction.accountName == _selectedAccount;
    }).toList();
  }

  // Helper method to display obscured amount
  Widget _buildObscuredAmount(String amount, {TextStyle? style}) {
    return _obscureBalance
        ? Text(
      '•' * amount.length,
      style: style ?? TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    )
        : Text(
      amount,
      style: style ?? TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  // Top Up Dialog function from StatisticsPage
  void _showTopUpDialog() {
    TextEditingController amountController = TextEditingController();
    double currentBalance = _selectedAccount?.balance != null ?
    double.tryParse(_selectedAccount!.balance.toString()) ?? 0.0 : 0.0;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Top Up Account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Current Balance: \$${currentBalance.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      double amount = double.tryParse(amountController.text) ?? 0;
                      if (amount > 0 && _selectedAccount != null) {
                        setState(() {
                          // Update balance in the selected account
                          double updatedBalance = currentBalance + amount;
                          _selectedAccount!.balance = updatedBalance;

                          // Add the transaction
                          _transactions.insert(
                            0,
                            Transaction(
                              id: DateTime.now().toString(),
                              title: 'Top Up',
                              amount: amount,
                              date: DateTime.now(),
                              category: TransactionCategory.topUp,
                              accountName: _selectedAccount,
                              description: 'Account Top Up',
                            ),
                          );
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Successfully topped up \$${amount.toStringAsFixed(2)}'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else if (_selectedAccount == null) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select an account first'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text('Top Up'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    fetchCards();
    fetchAccounts();
    fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Online Banking System'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("John Doe"),
              accountEmail: Text("johndoe@example.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/profile.jpg"),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Logout"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _cards.map((card) => CardDesign(card: card)).toList(),
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Recent Transactions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: getFilteredTransactions().length,
                itemBuilder: (context, index) {
                  final transaction = getFilteredTransactions()[index];
                  return ListTile(
                    leading: Icon(
                      transaction.amount?.toString().startsWith('-') ?? false
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color: transaction.amount?.toString().startsWith('-') ?? false
                          ? Colors.red
                          : Colors.green,
                    ),
                    title: Text(transaction.description ?? ''),
                    subtitle: Text(transaction.date?.toString() ?? ''),
                    trailing: _buildObscuredAmount(
                      transaction.amount?.toString() ?? '',
                      style: TextStyle(
                        color: transaction.amount?.toString().startsWith('-') ?? false
                            ? Colors.red
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      // Add the Floating Action Button for Top Up from StatisticsPage
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showTopUpDialog,
        icon: Icon(Icons.add),
        label: Text('Top Up'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

// Add the Transaction class for compatibility with the top up functionality
class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionCategory category;
  final dynamic accountName; // To match with _selectedAccount
  final String? description;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.accountName,
    this.description,
  });
}

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('John Doe'),
            accountEmail: Text('johndoe@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.blue),
            ),
          ),
          ListTile(
            title: Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}