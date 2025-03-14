import 'package:flutter/material.dart';
import 'package:online_banking_system/Models/CardContract.dart';
import 'package:online_banking_system/Models/ApiService.dart';

class UpdateCardDetails extends StatefulWidget {
  final CardContract card;

  const UpdateCardDetails({Key? key, required this.card}) : super(key: key);

  @override
  _UpdateCardDetailsPageState createState() => _UpdateCardDetailsPageState();
}

class _UpdateCardDetailsPageState extends State<UpdateCardDetails> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _creditLimitController;
  late TextEditingController _cardHolderNameController;
  late ApiService apiService;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();

    // Initialize controllers with existing values
    _creditLimitController =
        TextEditingController(text: widget.card.creditLimit?.toString() ?? "0");
    _cardHolderNameController = TextEditingController(
        text:
        "${widget.card.embossedData?.firstName ?? ""} ${widget.card.embossedData?.lastName ?? ""}");
  }

  @override
  void dispose() {
    _creditLimitController.dispose();
    _cardHolderNameController.dispose();
    super.dispose();
  }

  Future<void> updateCardContract() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic> updatedDetails = {
        "cardContractId": widget.card.cardContractId,
        "creditLimit": double.tryParse(_creditLimitController.text) ?? 0,
        "cardHolderName": _cardHolderNameController.text,
      };

      // Send update request to API
      await apiService.updateCardContract(
          widget.card.cardContractId.toString(), // First argument (contract ID)
          updatedDetails // Second argument (updated details map)
      );

      // Update UI state to reflect the changes
      setState(() {
        widget.card.creditLimit = double.tryParse(_creditLimitController.text) ?? 0;
        widget.card.embossedData?.firstName = _cardHolderNameController.text.split(" ").first;
        widget.card.embossedData?.lastName = _cardHolderNameController.text.split(" ").length > 1
            ? _cardHolderNameController.text.split(" ").last
            : "";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Card details updated successfully')),
      );

      // Return updated details to previous screen
      Navigator.pop(context, widget.card);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating card details: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Card Details")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Credit Limit"),
              TextFormField(
                controller: _creditLimitController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter credit limit",
                ),
                validator: (value) =>
                value!.isEmpty ? "Enter credit limit" : null,
              ),
              SizedBox(height: 16),

              Text("Cardholder Name"),
              TextFormField(
                controller: _cardHolderNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter cardholder name",
                ),
                validator: (value) =>
                value!.isEmpty ? "Enter cardholder name" : null,
              ),
              SizedBox(height: 16),

              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: updateCardContract,
                child: Text("Update Details"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
