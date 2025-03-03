import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Models/ApiService.dart';
import '../Models/TransactionContract.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TransactionContract> _transactions = [];
  DateTime? _startDate;
  DateTime? _endDate;
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
      List<TransactionContract> fetchedTransactions =
      (await apiService.fetchTransactionContract("5176632120")) as List<TransactionContract>;
      setState(() {
        _transactions = fetchedTransactions;
      });
    } catch (e) {
      print("Error fetching transactions: $e");
    }
  }

  List<TransactionContract> getFilteredTransactions() {
    return _transactions.where((transaction) {
      if (_startDate != null && transaction.date.isBefore(_startDate!)) {
        return false;
      }
      if (_endDate != null && transaction.date.isAfter(_endDate!)) {
        return false;
      }
      return true;
    }).toList();
  }

  void _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transactions')),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Transactions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: () => _selectDateRange(context),
                  icon: Icon(Icons.calendar_today),
                  label: Text(_startDate == null
                      ? 'Select Date Range'
                      : '${DateFormat('MMM dd').format(_startDate!)} - ${DateFormat('MMM dd').format(_endDate!)}'),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: getFilteredTransactions().length,
                itemBuilder: (context, index) {
                  final transaction = getFilteredTransactions()[index];
                  return ListTile(
                    leading: Icon(Icons.receipt_long, color: Colors.blue),
                    title: Text(transaction.transactionDescription ?? ''),
                    subtitle: Text(DateFormat.yMMMd().format(transaction.date)),
                    trailing: Text(
                      '\$${transaction.count.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: transaction.count < 0 ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: Icon(Icons.add),
        label: Text('Top Up'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
