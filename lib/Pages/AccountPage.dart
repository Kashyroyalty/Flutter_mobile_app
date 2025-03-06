import 'package:flutter/material.dart';
import 'package:online_banking_system/Constants/Colors.dart';
import 'package:online_banking_system/Models/ApiService.dart';
import 'package:online_banking_system/Models/AccountContract.dart';
import 'package:online_banking_system/Pages/ProfilePage.dart';
import 'package:online_banking_system/widgets/Accounts.dart';
import '../widgets/AccountDetails.dart';
import 'NotificationPage.dart';
import 'AddAccountPage.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List<AccountContract> _accounts = [];
  bool _isLoading = true;
  bool _isBalanceHidden = true;
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    fetchAccounts();
  }

  Future<void> fetchAccounts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      int? clientId = await apiService.getClientId();
      if (clientId == null) {
        throw Exception("Client ID not found");
      }

      List<AccountContract> fetchedAccounts = await apiService.fetchClientAccounts(clientId);

      // Ensure unique accounts and avoid duplicates
      Set<String> uniqueAccountNumbers = {};
      List<AccountContract> uniqueAccounts = [];

      for (var account in fetchedAccounts) {
        if (!uniqueAccountNumbers.contains(account.accountContractNumber)) {
          uniqueAccountNumbers.add(account.accountContractNumber);
          uniqueAccounts.add(account);
        }
      }

      setState(() {
        _accounts = uniqueAccounts;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching accounts: $e");
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

  void _navigateToAddAccount(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddAccountPage()),
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
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationsPage()),
            ),
          ),
          IconButton(
            icon: CircleAvatar(
              radius: 14,
              child: Icon(Icons.person, size: 18),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _accounts.isEmpty
          ? Center(child: Text("No accounts available"))
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Your Accounts',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                InkWell(
                  onTap: _toggleBalanceVisibility,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
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
                          color: kCardColor,
                        ),
                        SizedBox(width: 4),
                        Text(
                          _isBalanceHidden
                              ? 'Show Balance'
                              : 'Hide Balance',
                          style: TextStyle(
                            color: kCardColor,
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
          Expanded(
            child: _accounts.length == 1
                ? Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0),
              child: Accounts(
                accountName: _accounts[0].accountContractName,
                accountNumber: _accounts[0].accountContractNumber,
                balance: _accounts[0].balance,
                color: kCardColor,
                isBalanceHidden: _isBalanceHidden,
                onTap: () => _navigateToAccountDetails(context),
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _accounts.length,
              itemBuilder: (context, index) {
                final account = _accounts[index];
                return Accounts(
                  accountName: account.accountContractName,
                  accountNumber: account.accountContractNumber,
                  balance: account.balance,
                  color: kCardColor,
                  isBalanceHidden: _isBalanceHidden,
                  onTap: () =>
                      _navigateToAccountDetails(context),
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
}
