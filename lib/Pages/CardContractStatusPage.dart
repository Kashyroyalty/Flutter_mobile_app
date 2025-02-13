import 'package:flutter/material.dart';

class CardContractStatusPage extends StatefulWidget {
  const CardContractStatusPage({Key? key}) : super(key: key);

  @override
  _CardContractStatusPageState createState() => _CardContractStatusPageState();
}

class _CardContractStatusPageState extends State<CardContractStatusPage> {
  String _selectedStatus = 'Pending';
  final _formKey = GlobalKey<FormState>();
  final _contractNumberController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isLoading = false;

  final List<String> _statusOptions = [
    'Pending',
    'Active',
    'Suspended',
    'Cancelled',
    'Expired'
  ];

  // Simulated contract data
  final Map<String, dynamic> _contractData = {
    'contractNumber': 'CNT-2025-001',
    'customerName': 'John Doe',
    'currentStatus': 'Pending',
    'lastUpdated': '2025-02-12',
  };

  void _updateStatus() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Update the contract data
      setState(() {
        _contractData['currentStatus'] = _selectedStatus;
        _contractData['lastUpdated'] = DateTime.now().toString().split(' ')[0];
        _isLoading = false;
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contract status updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Contract Status'),
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Contract Information Card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contract Details',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow('Contract Number:', _contractData['contractNumber']),
                        _buildInfoRow('Customer Name:', _contractData['customerName']),
                        _buildInfoRow('Current Status:', _contractData['currentStatus']),
                        _buildInfoRow('Last Updated:', _contractData['lastUpdated']),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Status Update Form
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Update Status',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedStatus,
                          decoration: const InputDecoration(
                            labelText: 'New Status',
                            border: OutlineInputBorder(),
                          ),
                          items: _statusOptions.map((String status) {
                            return DropdownMenuItem<String>(
                              value: status,
                              child: Text(status),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedStatus = newValue!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _noteController,
                          decoration: const InputDecoration(
                            labelText: 'Note',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a note';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _updateStatus,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                              'Update Status',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _contractNumberController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}