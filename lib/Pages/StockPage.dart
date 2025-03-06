import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:online_banking_system/Pages/NotificationPage.dart';

import '../Models/AccountContract.dart';
import '../Models/ApiService.dart';
import '../Models/CardContract.dart';
import '../Models/TransactionContract.dart';
import '../widgets/CardExpense.dart';
import 'ProfilePage.dart';

enum TransactionCategory {
  transfer(icon: Icons.swap_horiz),
  shopping(icon: Icons.shopping_bag),
  food(icon: Icons.restaurant),
  topUp(icon: Icons.account_balance_wallet);

  final IconData icon;
  const TransactionCategory({required this.icon});
}


class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  bool isExpensesTab = true;
  double currentBalance = 0.0;
  AccountContract? accountData;
  bool _isLoading = true;
  bool _hasError = false;
  List<CardContract> _cards = [];
  int _selectedCardIndex = -1;
  List<Transaction> transactions = [];

  String errorMessage = '';


  CardContract? get cardData => _selectedCardIndex >= 0 ? _cards[_selectedCardIndex] : null;
  double get cardBalance => cardData?.availableBalance ?? 0.0;


  @override
  void initState() {
    super.initState();
    fetchClientCards(

    );
  }
  Future<void> fetchTransactions(String cardId) async {
    try {
      TransactionContract contract = await ApiService().fetchTransactionContract(cardId);
      setState(() {
        transactions = contract.transactions.map((t) => Transaction(
          id: t.transactionId,
          title: t.transactionType,
          amount: t.transactionAmount,
          date: DateTime.parse(t.transactionDate),
          category: TransactionCategory.values.firstWhere(
                (c) => c.toString().split('.').last == t.transactionDescription,
            orElse: () => TransactionCategory.transfer,
          ),
        )).toList();
      });
    } catch (e) {
      print("Error fetching transactions: $e");
    }
  }

  Future<void> fetchClientCards() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      int? clientId = await ApiService().getClientId();
      if (clientId == null) {
        throw Exception("Client ID not found");
      }

      List<CardContract> fetchedCards = await ApiService().fetchClientCards(clientId);
      if (fetchedCards.isNotEmpty) {
        setState(() {
          _cards = fetchedCards;
          _selectedCardIndex = 0;
        });
        await fetchTransactions(fetchedCards[0].cardContractId as String);
      }
    } catch (e) {
      print("Error fetching cards or transactions: $e");
      setState(() => _hasError = true);
    } finally {
      setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Statistics'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
          ),
          IconButton(
            icon: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, size: 18, color: Colors.grey[700]),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardWidget(
            cardData: cardData,
            cardBalance: cardBalance,
            monthlyExpenses: _calculateTotalExpenses(),
          ),
          SizedBox(height: 24),
          _buildDateRange(),
          SizedBox(height: 24),
          _buildTabs(),
          SizedBox(height: 24),
          _buildExpenseChart(),
          SizedBox(height: 24),
          _buildTransactionsList(),
        ],
      ),
    );
  }




  Widget _buildDateRange() {
    DateTime now = DateTime.now();
    DateTime firstDay = DateTime(now.year, now.month, 1);
    DateTime lastDay = DateTime(now.year, now.month + 1, 0);

    String formattedDateRange =
        '${DateFormat('d MMM').format(firstDay)} - ${DateFormat('d MMM y').format(lastDay)}';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today, size: 20, color: Colors.blue),
          SizedBox(width: 12),
          Text(
            formattedDateRange,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isExpensesTab = true),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: isExpensesTab ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Expenses',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isExpensesTab ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isExpensesTab = false),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: !isExpensesTab ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Top Up',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: !isExpensesTab ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseChart() {
    return Container(
      height: 280,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expenses Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Text(
                'Expenses Chart Here',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    final filteredTransactions = isExpensesTab
        ? transactions.where((t) => t.amount < 0).toList()
        : transactions.where((t) => t.amount > 0).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isExpensesTab ? 'Recent Expenses' : 'Recent Top Up',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        ...filteredTransactions.map((transaction) => _buildTransactionCard(transaction)),
      ],
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: transaction.amount > 0 ? Colors.green[50] : Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              transaction.category.icon,
              color: transaction.amount > 0 ? Colors.green : Colors.blue,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  DateFormat('dd MMM yyyy').format(transaction.date),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${transaction.amount > 0 ? '+' : ''}\$${transaction.amount.abs().toStringAsFixed(2)}',
            style: TextStyle(
              color: transaction.amount > 0 ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTotalExpenses() {
    return transactions
        .where((t) => t.amount < 0)
        .fold(0, (sum, transaction) => sum + transaction.amount.abs());
  }
}

extension on List<AccountContract> {
  get accountContractName => accountContractName;
}

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionCategory category;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });
}