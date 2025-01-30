import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MobileMoneyPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class MobileMoneyPage extends StatelessWidget {
  final List<Map<String, dynamic>> options = [
    {
      'icon': Icons.credit_card,
      'color': Colors.black,
      'title': 'M-PESA to Credit Card',
    },
    {
      'icon': Icons.account_balance_wallet,
      'color': Colors.teal,
      'title': 'M-PESA to Account',
    },
    {
      'icon': Icons.credit_card,
      'color': Colors.blue,
      'title': 'M-PESA to Prepaid Card',
    },
    {
      'icon': Icons.account_balance,
      'color': Colors.red,
      'title': 'Airtel Money to Account',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Mobile Money to card",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: options.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                itemBuilder: (context, index) {
                  final item = options[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: item['color'].withOpacity(0.2),
                      child: Icon(
                        item['icon'],
                        color: item['color'],
                      ),
                    ),
                    title: Text(
                      item['title'],
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      // Handle tap event
                    },
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
