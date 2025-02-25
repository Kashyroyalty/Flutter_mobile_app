import 'package:flutter/material.dart';
import 'package:online_banking_system/Models/ApiService.dart';
import 'package:online_banking_system/Pages/LoginPage.dart';
import 'dart:ui';
import '../Models/CardContract.dart';
import '../Models/AccountContract.dart'; // Assuming you have an AccountContract model
import '../Models/TransactionContract.dart'; // Assuming you have a TransactionContract model
import '../widgets/CardDesign.dart';
import 'ProfilePage.dart';
import 'SettingPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _cards = [];
  List<AccountContract> accountData = []; // Ensure this is initialized properly
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

      print("Fetched accounts: $fetchedAccounts"); // Debugging statement

      setState(() {
        accountData = account as List<AccountContract>;
        if (accountData.isNotEmpty) {
          _selectedAccount = accountData.first; // Set a default account
        }
      });

      print("Selected Account: $_selectedAccount"); // Debugging statement

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
        // Assuming transaction has an accountName or accountId property
        return transaction.accountName == _selectedAccount; // Adjust this condition based on your model
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
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: accountData.isEmpty
                      ? Center(child: CircularProgressIndicator()) // Show a loader if no data

                      : DropdownButtonFormField<AccountContract>(
                    decoration: InputDecoration(
                      labelText: 'Select Account',
                      border: InputBorder.none,
                    ),
                    value: _selectedAccount,
                    items: accountData.map((account) {
                      return DropdownMenuItem<AccountContract>(
                        value: account, // Store entire account object
                        child: Text(account.accountContractName ?? 'Unnamed Account'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAccount = value;
                      });
                    },
                    isExpanded: true,
                  ),
                ),
                SizedBox(height: 20),
                if (_selectedAccount != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Available Balance'),
                      _buildObscuredAmount(
                        '\$${_selectedAccount!.balance}', // Ensure this property exists
                      ),
                      IconButton(
                        icon: Icon(_obscureBalance ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscureBalance = !_obscureBalance;
                          });
                        },
                      ),
                    ],
                  ),
                ],

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
                        transaction.amount!.startsWith('-')
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: transaction.amount!.startsWith('-')
                            ? Colors.red
                            : Colors.green,
                      ),
                      title: Text(transaction.description!),
                      subtitle: Text(transaction.date!),
                      trailing: _buildObscuredAmount(
                        transaction.amount!,

                        style: TextStyle(

                          color: transaction.amount!.startsWith('-')

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
      );
    }
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