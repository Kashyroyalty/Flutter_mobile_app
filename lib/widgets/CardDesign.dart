import 'package:flutter/material.dart';
import 'dart:math';
import 'package:online_banking_system/Constants/Colors.dart';
import 'package:online_banking_system/Models/CardContract.dart';
import 'package:online_banking_system/Models/ApiService.dart';
import 'package:online_banking_system/Pages/CardContractStatusPage.dart';
import 'package:online_banking_system/Pages/ClientIdentifierPage.dart';

enum CardMenuOptions {
  changeStatus,
  pinAttempts,
  clientIdentifier
}

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
  late ApiService apiService;

  // Define constant card dimensions
  static const double cardWidth = 350.0;
  static const double cardMargin = 16.0;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: pi).animate(_controller);
  }

  Future<void> _handleMenuOption(CardMenuOptions option) async {
    switch (option) {
      case CardMenuOptions.changeStatus:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CardContractStatusPage()
          ),
        );
        break;
      case CardMenuOptions.pinAttempts:
        try {
          final response = await apiService.updateCardPinAttempts(widget.card.cbsNumber ?? "");
          print(response.body);
          if (response.body == "OK" || response.body.toLowerCase() == "ok") {
            // Show success notification
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'PIN Attempts Reset',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'You now have 3 PIN attempts available',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 4),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          } else {
            // Show error notification
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to reset PIN attempts. Please try again.'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                ),
              );
            }
          }
        } catch (e) {
          // Show error notification
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('An error occurred while resetting PIN attempts.'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
        break;
      case CardMenuOptions.clientIdentifier:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => clientidentifierpage()
          ),
        );
        break;
    }
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
    return Stack(
      children: [
        GestureDetector(
          onTap: _flipCard,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              double angle = _animation.value;
              bool isBack = angle > (pi / 2);

              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(angle)
                  ..setEntry(3, 2, 0.001),
                child: isBack ? _buildBackView() : _buildFrontView(),
              );
            },
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: PopupMenuButton<CardMenuOptions>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: _handleMenuOption,
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: CardMenuOptions.changeStatus,
                child: Row(
                  children: [
                    Icon(Icons.swap_horiz, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Change Card Contract Status'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: CardMenuOptions.pinAttempts,
                child: Row(
                  children: [
                    Icon(Icons.pin, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Reset PIN Attempts'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: CardMenuOptions.clientIdentifier,
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Client Identifier'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFrontView() {
    return Container(
      key: ValueKey('front'),
      margin: EdgeInsets.only(right: cardMargin),
      width: cardWidth,
      height: cardWidth * 0.63, // Standard card aspect ratio
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue, kCardColor],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
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
          Spacer(),
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
      transform: Matrix4.rotationY(pi),
      child: Container(
        key: ValueKey('back'),
        margin: EdgeInsets.only(right: cardMargin),
        width: cardWidth,
        height: cardWidth * 0.63, // Same aspect ratio as front
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, kCardColor],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Container(
              height: 40,
              color: Colors.black87,
              width: double.infinity,
            ),
            SizedBox(height: 20),
            Text(
              'CVV: ${widget.card.amendmentOfficerName ?? '***'}',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 20),
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
            Spacer(),
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