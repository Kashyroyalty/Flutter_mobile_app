import 'package:flutter/material.dart';
import 'package:online_banking_system/Pages/ProfilePage.dart';
import 'package:online_banking_system/widgets/AccountDetails.dart';
import '../Models/AccountContract.dart';
import '../Models/ApiService.dart';
import 'NotificationPage.dart';
import 'AccountDetailsPage.dart';
import 'AddAccountPage.dart'; // Import the new page

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  AccountContract? accountData;
  bool _isLoading = true;
  bool _isBalanceHidden = true;

  get card => null;

  @override
  void initState() {
    super.initState();
    fetchAccountData();
  }

  Future<void> fetchAccountData() async {
    try {
      print("Fetching account data...");
      final account = await ApiService().fetchAccountContract("5176632120");
      print("Account Data Fetched: ${account.accountContractName}");

      setState(() {
        accountData = account;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching account data: $e");
      setState(() {
        _isLoading = false;
      });
    }
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
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _isLoading
                      ? CircularProgressIndicator()
                      : _TotalBalanceCard(
                    accountName: (accountData?.accountContractName.isNotEmpty ?? false)
                        ? accountData!.accountContractName
                        : "No Account Name",
                    balance: accountData?.balance ?? 0.0,
                    isBalanceHidden: _isBalanceHidden,
                    onToggleBalance: () {
                      setState(() {
                        _isBalanceHidden = !_isBalanceHidden;
                      });
                    },
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Cards',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      ElevatedButton.icon(
                        icon: Icon(Icons.add),
                        label: Text("Add Account"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _navigateToAddAccount(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _AccountCard(
                  cardNumber: '**** 8832',
                  balance: 8846.00,
                  cardType: 'Mastercard',
                  color: Colors.teal,
                  onTap: () => _navigateToAccountDetails(context),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
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
}

class _TotalBalanceCard extends StatelessWidget {
  final String accountName;
  final double balance;
  final bool isBalanceHidden;
  final VoidCallback onToggleBalance;

  const _TotalBalanceCard({
    required this.accountName,
    required this.balance,
    required this.isBalanceHidden,
    required this.onToggleBalance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo, Colors.indigoAccent],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            accountName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Total Balance',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isBalanceHidden ? '••••••' : '\$${balance.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: Icon(
                  isBalanceHidden ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white70,
                ),
                onPressed: onToggleBalance,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  final String cardNumber;
  final double balance;
  final String cardType;
  final Color color;
  final VoidCallback onTap;

  const _AccountCard({
    required this.cardNumber,
    required this.balance,
    required this.cardType,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.credit_card, color: color),
                      SizedBox(width: 8),
                      Text(
                        cardType,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    cardNumber,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                '\$${balance.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Available Balance',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}