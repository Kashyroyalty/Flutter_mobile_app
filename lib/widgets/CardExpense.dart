import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Models/CardContract.dart';

class CardWidget extends StatefulWidget {
  final CardContract? cardData;
  final double cardBalance;
  final double monthlyExpenses;

  CardWidget({
    required this.cardData,
    required this.cardBalance,
    required this.monthlyExpenses,
  });

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  bool _isBalanceHidden = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[700]!, Colors.blue[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Name or Placeholder
          Text(
            widget.cardData != null
                ? widget.cardData!.cardContractName
                : 'Card Name',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),

          // Card Balance with Masking Feature
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isBalanceHidden ? '******' : '\$${widget.cardBalance.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(
                  _isBalanceHidden ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white.withOpacity(0.8),
                ),
                onPressed: () {
                  setState(() {
                    _isBalanceHidden = !_isBalanceHidden;
                  });
                },
              ),
            ],
          ),

          SizedBox(height: 24),

          // Monthly Expenses Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monthly Expenses',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '\$${widget.monthlyExpenses.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
