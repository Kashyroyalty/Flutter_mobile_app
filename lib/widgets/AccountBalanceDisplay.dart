import 'package:flutter/material.dart';

class AccountBalanceDisplay extends StatefulWidget {
  final Map<String, double> accounts; // Account names and balances

  const AccountBalanceDisplay({Key? key, required this.accounts}) : super(key: key);

  @override
  _AccountBalanceDisplayState createState() => _AccountBalanceDisplayState();
}

class _AccountBalanceDisplayState extends State<AccountBalanceDisplay> {
  String? _selectedAccount;
  bool _isBalanceVisible = true;

  @override
  void initState() {
    super.initState();
    _selectedAccount = widget.accounts.keys.first; // Default to the first account
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Dropdown for selecting account
        DropdownButton<String>(
          value: _selectedAccount,
          onChanged: (String? newValue) {
            setState(() {
              _selectedAccount = newValue;
            });
          },
          items: widget.accounts.keys.map<DropdownMenuItem<String>>((String account) {
            return DropdownMenuItem<String>(
              value: account,
              child: Text(account, style: TextStyle(fontSize: 18)),
            );
          }).toList(),
        ),
        SizedBox(height: 20),

        // Account balance label
        Text(
          'Account Balance',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),

        // Show/Hide balance
        GestureDetector(
          onTap: () {
            setState(() {
              _isBalanceVisible = !_isBalanceVisible;
            });
          },
          child: Text(
            _isBalanceVisible
                ? '\$${widget.accounts[_selectedAccount]!.toStringAsFixed(2)}'
                : '******',
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        SizedBox(height: 10),

        // Toggle button for showing/hiding balance
        ElevatedButton(
          onPressed: () {
            setState(() {
              _isBalanceVisible = !_isBalanceVisible;
            });
          },
          child: Text(_isBalanceVisible ? 'Hide Balance' : 'Show Balance'),
        ),
      ],
    );
  }
}
