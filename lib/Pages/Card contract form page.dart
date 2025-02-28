import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_banking_system/Models/ApiService.dart';

class CardContractformPage extends StatefulWidget {
  @override
  _CardContractFormPageState createState() => _CardContractFormPageState();
}

class _CardContractFormPageState extends State<CardContractformPage> {
  late ApiService apiService;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _bankBranchController = TextEditingController();

  String _selectedCurrency = 'USD';
  String _selectedProduct = 'CREDIT';
  String _selectedCardType = 'Physical';

  final List<String> _products = ['CREDIT', 'DEBIT', 'PREPAID'];
  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'KES', 'TZS', 'UGX'];
  final List<String> _cardTypes = ['Physical', 'Virtual'];

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
  }

  void _showSuccessNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('New card has been added successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final cardData = {
        'accountNumber': _accountNumberController.text,
        'bankBranch': _bankBranchController.text,
        'cardType': _selectedCardType,
        'product': _selectedProduct,
        'currency': _selectedCurrency,
      };

      // Print the card data to the terminal
      print("Card Contract Data:");
      cardData.forEach((key, value) {
        print("$key: $value");
      });

      apiService.createCardContract(cardData);

      // Show success notification
      _showSuccessNotification();

      // Clear form fields for a new entry
      _clearFormFields();
    }
  }

  // Helper method to clear all form fields after submission
  void _clearFormFields() {
    _accountNumberController.clear();
    _bankBranchController.clear();
    setState(() {
      _selectedProduct = 'CREDIT';
      _selectedCurrency = 'USD';
      _selectedCardType = 'Physical';
    });
  }

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
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedCardType,
                          decoration: InputDecoration(
                            labelText: 'Card Type',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.credit_card),
                          ),
                          items: _cardTypes.map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          )).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCardType = value!;
                            });
                          },
                          validator: (value) => value == null ? 'Please select a card type' : null,
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
                  onPressed: _submitForm,
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
    super.dispose();
  }
}