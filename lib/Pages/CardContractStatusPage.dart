import 'package:flutter/material.dart';
import 'package:online_banking_system/Models/ApiService.dart';
import 'package:http/http.dart' as http;
import '../Models/CardContract.dart';
import 'package:intl/intl.dart';

class CardContractStatusPage extends StatefulWidget {
  const CardContractStatusPage({Key? key}) : super(key: key);

  @override
  _CardContractStatusPageState createState() => _CardContractStatusPageState();
}

class _CardContractStatusPageState extends State<CardContractStatusPage> {
  late ApiService apiService;
  String _selectedStatusCode = '00';
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  bool _isLoading = false;
  bool _isFetching = true;
  String? _errorMessage;
  late CardContract _contractData;
  String _currentStatus = 'N/A';
  String _lastUpdated = 'N/A';

  final List<Map<String, String>> _statusOptions = [
    {'code': '00', 'description': 'Card is ready'},
    {'code': '04', 'description': 'Blocked by bank'},
    {'code': '05', 'description': 'Temporarily blocked by user'},
    {'code': '14', 'description': 'Card permanently closed'},
    {'code': '41', 'description': 'Card reported lost'},
    {'code': '43', 'description': 'Card reported stolen'},
  ];

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    _fetchContractData();
  }

  Future<void> _fetchContractData() async {
    try {
      CardContract contract = await apiService.fetchCardContract("2507355660");
      setState(() {
        _contractData = contract;
        _currentStatus = contract.cardContractStatusData?.statusName ?? 'N/A';
        _lastUpdated = contract.cardContractStatusData?.statusCode ?? 'N/A';
        _isFetching = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Error fetching card contract: $e";
        _isFetching = false;
      });
    }
  }

  void _updateStatus() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));

      String newStatus = _statusOptions
          .firstWhere((status) => status['code'] == _selectedStatusCode)['description']!;
      String statusCode = _selectedStatusCode;
      String reason = _noteController.text;
      String updatedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      setState(() {
        _currentStatus = newStatus;
        _lastUpdated = updatedDate;
        _isLoading = false;
      });

      print("Updated Status: $_currentStatus");
      print("Note: $reason");

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
      body: _isFetching
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!, style: TextStyle(color: Colors.red)))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildContractInfoCard(),
              const SizedBox(height: 24),
              _buildStatusUpdateForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContractInfoCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contract Details', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildInfoRow('Contract Number:', _contractData.cardContractNumber ?? 'N/A'),
            _buildInfoRow('Customer Name:', _contractData.cardContractName ?? 'N/A'),
            _buildInfoRow('Current Status:', _currentStatus),
            _buildInfoRow('Last Updated:', _lastUpdated),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusUpdateForm() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Update Status', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedStatusCode,
              decoration: const InputDecoration(
                labelText: 'New Status',
                border: OutlineInputBorder(),
              ),
              items: _statusOptions.map((status) {
                return DropdownMenuItem<String>(
                  value: status['code'],
                  child: Text(status['description']!),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() => _selectedStatusCode = newValue!);
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
              validator: (value) => value == null || value.isEmpty ? 'Please enter a note' : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Update Status', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
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
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}
