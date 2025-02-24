import 'package:flutter/material.dart';

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