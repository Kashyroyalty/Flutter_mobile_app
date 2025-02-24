import 'package:flutter/material.dart';
import 'dart:math';
import 'package:online_banking_system/Constants/Colors.dart';
import 'package:online_banking_system/Models/CardContract.dart';
import 'package:online_banking_system/Models/ApiService.dart';
import 'package:online_banking_system/Pages/CardContractStatusPage.dart';
import 'package:online_banking_system/Pages/CardPage.dart';
import 'package:online_banking_system/Pages/ClientIdentifierPage.dart';
import 'package:online_banking_system/Pages/PINAttemptsCounter.dart';
import 'package:online_banking_system/pages/SettingPage.dart';

enum CardMenuOptions {
  changeStatus,
  pinAttempts,
  viewDetails,
  clientIdentifier,
  resetPin,
  blockCard  // Added new enum value
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
          MaterialPageRoute(builder: (context) => CardContractStatusPage()),
        );
        break;

      case CardMenuOptions.viewDetails:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CardPage(cardData: widget.card as Map<String,String>), // Replace with actual details page
          ),
        );
        break;

      case CardMenuOptions.pinAttempts:
        try {
          final response = await apiService.updateCardPinAttempts(widget.card.cbsNumber ?? "");
          if (response.body.toLowerCase() == "ok") {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('PIN Attempts Reset Successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to reset PIN attempts.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error resetting PIN attempts.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
        break;

      case CardMenuOptions.clientIdentifier:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClientIdentifier()),
        );
        break;

      case CardMenuOptions.resetPin:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PinResetPage()), // Ensure it's correctly imported
        );
        try {
          final response = await apiService.resetCardPin(widget.card.cbsNumber ?? "");
          if (response.body.toLowerCase() == "ok") {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('PIN Reset Successful'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to reset PIN.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error resetting PIN.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
        break;

      default:
        throw UnimplementedError("Unhandled case: $option");
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
                    Text('Client identifier'),
                  ],
                ),
              ),
              PopupMenuItem(  // Added new menu item
                value: CardMenuOptions.resetPin,
                child: Row(
                  children: [
                    Icon(Icons.lock_reset, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Reset PIN'),
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