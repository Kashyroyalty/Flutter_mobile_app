import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_banking_system/Models/ApiService.dart';
import 'package:online_banking_system/Pages/Card%20contract%20form%20page.dart';
import 'CardContractformPage.dart';  // Import the CardContractformPage to navigate

class AddAccountPage extends StatefulWidget {
  @override
  _AddAccountPageState createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  late ApiService apiService;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _bankBranchController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  String _selectedCurrency = 'USD';
  String _selectedTitle = 'Mr.';

  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'KES', 'TZS', 'UGX'];
  final List<String> _titles = ['Mr.', 'Mrs.', 'Ms.', 'Dr.', 'Prof.'];

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final accountData = {
        'title': _selectedTitle,
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'accountNumber': _accountNumberController.text,
        'bankBranch': _bankBranchController.text,
        'currency': _selectedCurrency,
      };

      // Print the account data to the terminal
      print("Account Data:");
      accountData.forEach((key, value) {
        print("$key: $value");
      });

      // Here you would call your API service to create the account
      // apiService.createAccountContract(accountData);

      // Return to previous screen
      Navigator.pop(context);
    }
  }

  void _navigateToCardForm() {
    if (_formKey.currentState!.validate()) {
      // Navigate to CardContractformPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CardContractformPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Account'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Personal Information
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Information',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedTitle,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person_pin),
                          ),
                          items: _titles.map((title) => DropdownMenuItem(
                            value: title,
                            child: Text(title),
                          )).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedTitle = value!;
                            });
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) => value!.isEmpty ? 'Please enter first name' : null,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (value) => value!.isEmpty ? 'Please enter last name' : null,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Account Information
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account Information',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _accountNumberController,
                          decoration: InputDecoration(
                            labelText: 'Account Number',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.account_balance),
                          ),
                          validator: (value) => value!.isEmpty ? 'Please enter account number' : null,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _bankBranchController,
                          decoration: InputDecoration(
                            labelText: 'Bank Branch',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.account_balance_wallet),
                          ),
                          validator: (value) => value!.isEmpty ? 'Please enter bank branch' : null,
                        ),
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedCurrency,
                          decoration: InputDecoration(
                            labelText: 'Currency',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.currency_exchange),
                          ),
                          items: _currencies.map((currency) => DropdownMenuItem(
                            value: currency,
                            child: Text(currency),
                          )).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCurrency = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child:ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white, // Add this line for bright white text
                        ),
                        child: Text(
                          'Finish',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _navigateToCardForm,
                        icon: Icon(Icons.add_card),
                        label: Text(
                          'Add Card',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white, // Add this line for bright white text
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    _bankBranchController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}