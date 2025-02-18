import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CardContractformPage extends StatefulWidget {
  @override
  _CardContractFormPageState createState() => _CardContractFormPageState();
}

class _CardContractFormPageState extends State<CardContractformPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _bankBranchController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  String _selectedCurrency = 'USD';
  String _selectedProduct = 'CREDIT';

  final List<String> _products = ['CREDIT', 'DEBIT', 'PREPAID'];
  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'KES', 'TZS', 'UGX'];
  final List<String> _titles = ['Mr.', 'Mrs.', 'Ms.', 'Dr.', 'Prof.'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Contract Form'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Personal Information Card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _titles[0],
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
                              _titleController.text = value!;
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter first name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter last name';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Account Information Card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _accountNumberController,
                          decoration: InputDecoration(
                            labelText: 'Account Number',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.account_balance),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter account number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _bankBranchController,
                          decoration: InputDecoration(
                            labelText: 'Bank Branch',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.account_balance_wallet),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter bank branch';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Card Details
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Card Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _cardNumberController,
                          decoration: InputDecoration(
                            labelText: 'Card Number',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.credit_card),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(16),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter card number';
                            }
                            if (value.length != 16) {
                              return 'Card number must be 16 digits';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedProduct,
                          decoration: InputDecoration(
                            labelText: 'Product',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.card_membership),
                          ),
                          items: _products.map((product) => DropdownMenuItem(
                            value: product,
                            child: Text(product),
                          )).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedProduct = value!;
                            });
                          },
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
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Processing Card Contract...'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    'Submit Contract',
                    style: TextStyle(fontSize: 16),
                  ),
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
    _cardNumberController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _titleController.dispose();
    super.dispose();
  }
}