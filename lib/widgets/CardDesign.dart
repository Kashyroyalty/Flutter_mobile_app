import 'package:flutter/material.dart';
import 'dart:math';

import 'package:online_banking_system/Constants/Colors.dart';
import 'package:online_banking_system/Models/CardContract.dart';

class CardDesign extends StatefulWidget {
  final CardContract card;

  const CardDesign({Key? key, required this.card}) : super(key: key);

  @override
  _CardDesignState createState() => _CardDesignState();
}

class _CardDesignState extends State<CardDesign> with SingleTickerProviderStateMixin {
  bool _isFlipped = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: pi).animate(_controller);
  }

  void _flipCard() {
    setState(() {
      _isFlipped = !_isFlipped;
      if (_isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          double angle = _animation.value;
          bool isBack = angle > (pi / 2);

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(angle)
              ..setEntry(3, 2, 0.001), // Perspective effect
            child: isBack ? _buildBackView() : _buildFrontView(),
          );
        },
      ),
    );
  }

  Widget _buildFrontView() {
    return Container(
      key: ValueKey('front'),
      margin: EdgeInsets.only(right: 16),
      width: 330,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue,kCardColor],
        ),
        borderRadius: BorderRadius.circular(16),

      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.card.cardContractName ?? 'Unknown Bank',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            widget.card.cardContractNumber ?? '**** **** **** ****',
            style: TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 4),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card Holder',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    widget.card.embossedData.firstName ?? 'Unknown',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expires',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    widget.card.cardExpiryDate ?? 'MM/YY',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackView() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(pi), // Flip back view
      child: Container(
        key: ValueKey('back'),
        margin: EdgeInsets.only(right: 16),
        width: 300,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              color: Colors.grey[800],
              width: double.infinity,
            ),
            SizedBox(height: 10),
            Text(
              'CVV: ${widget.card.amendmentOfficerName ?? '***'}',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 10),
            Container(
              height: 40,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.centerRight,
              child: Text(
                widget.card.cbsNumber ?? 'Signature',
                style: TextStyle(color: Colors.black, fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.card.amendmentDate ?? 'Authorized use only',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
