import 'package:flutter/material.dart';
import 'package:online_banking_system/Constants/Colors.dart';
import 'package:online_banking_system/Pages/ProfilePage.dart';
import 'package:online_banking_system/Pages/SettingPage.dart';

import '../Models/AccountContract.dart';
import '../Models/ApiService.dart';
import 'NotificationPage.dart';


class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final ApiService _apiService = ApiService();
  AccountContract? accountData;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    fetchAccountData();
  }

  Future<void> fetchAccountData() async {
    try {
      final account = await ApiService().fetchAccountContract("5176632120");
      setState(() {
        accountData = account;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('My Accounts'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {
              // Navigate to NotificationPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
          ),
          IconButton(
            icon: CircleAvatar(
              radius: 14,
              child: Icon(Icons.person, size: 18), // Replacing image with a person icon
            ),
            onPressed: () {
              // Navigate to ProfilePage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),

        ],
      ),
      body: CustomScrollView(
        slivers: [  // Added the missing slivers parameter
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _isLoading
                      ? CircularProgressIndicator() // Show a loader while fetching
                      : _TotalBalanceCard(
                    balance: accountData?.balance ?? 0.0,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'My Cards',
                    style: Theme.of(context).textTheme.titleLarge,
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
                  cardNumber: '**** 5473',
                  balance: 15895.00,
                  cardType: 'Visa',
                  color: Colors.indigoAccent,
                  onTap: () => _navigateToAccountDetails(context),
                ),
                _AccountCard(
                  cardNumber: '**** 0180',
                  balance: 11200.00,
                  cardType: 'Visa',
                  color: Colors.purple,
                  onTap: () => _navigateToAccountDetails(context),
                ),
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
      bottomNavigationBar: _BottomActionBar(),
    );
  }
  void _navigateToAccountDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AccountDetailsPage()),
    );
  }
}

class _TotalBalanceCard extends StatelessWidget {

  final double balance;
  const _TotalBalanceCard({required this.balance});

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
            'Total Balance',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 8),
          Text(
            '\$${balance.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _BalanceChangeIndicator(
                label: 'Income',
                amount: '+\$2,450.00',
                icon: Icons.arrow_upward,
                positive: true,
              ),
              _BalanceChangeIndicator(
                label: 'Expenses',
                amount: '-\$1,280.00',
                icon: Icons.arrow_downward,
                positive: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceChangeIndicator extends StatelessWidget {
  final String label;
  final String amount;
  final IconData icon;
  final bool positive;

  const _BalanceChangeIndicator({
    required this.label,
    required this.amount,
    required this.icon,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: positive ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              amount,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
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

class _BottomActionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Theme.of(context).primaryColor),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Account Details'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Transactions'),
              Tab(text: 'Statements'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _AccountOverviewTab(),
            _TransactionsTab(),
            _StatementsTab(),
          ],
        ),
      ),
    );
  }
}

class _AccountOverviewTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _DetailCard(
          title: 'Card Details',
          content: Column(
            children: [
              _DetailRow('Card Number', '**** **** **** 5473'),
              _DetailRow('Card Type', 'Visa Platinum'),
              _DetailRow('Expiry Date', '12/25'),
              _DetailRow('Card Holder', 'John Doe'),
            ],
          ),
        ),
        SizedBox(height: 16),
        _DetailCard(
          title: 'Account Summary',
          content: Column(
            children: [
              _DetailRow('Available Balance', '\$15,895.00'),
              _DetailRow('Current Balance', '\$16,245.00'),
              _DetailRow('Payment Due', '\$350.00'),
              _DetailRow('Due Date', 'Feb 15, 2025'),
            ],
          ),
        ),
      ],
    );
  }
}

class _TransactionsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(16),
      itemCount: 10,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Icon(
              index % 2 == 0 ? Icons.shopping_bag : Icons.fastfood,
              color: Colors.grey[800],
            ),
          ),
          title: Text(
            index % 2 == 0 ? 'Shopping Mall' : 'Restaurant',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('Jan ${30 - index}, 2025'),
          trailing: Text(
            '-\$${(index + 1) * 25}.00',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}

class _StatementsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: 12,
      itemBuilder: (context, index) {
        final month = DateTime.now().subtract(Duration(days: 30 * index));
        return Card(
          margin: EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(Icons.description_outlined),
            title: Text(
              '${_getMonthName(month.month)} ${month.year} Statement',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Icon(Icons.download_outlined),
            onTap: () {},
          ),
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}

class _DetailCard extends StatelessWidget {
  final String title;
  final Widget content;

  const _DetailCard({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[600]),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}