import 'package:flutter/material.dart';
import 'package:online_banking_system/Constants/Colors.dart';
import 'package:online_banking_system/Models/ApiService.dart';
import 'package:online_banking_system/Models/CardContract.dart';
import 'package:online_banking_system/Pages/CardContractStatusPage.dart';
import 'package:online_banking_system/Pages/ClientIdentifierPage.dart';
import 'package:online_banking_system/Pages/PINAttemptsCounter.dart';
import 'package:online_banking_system/pages/SettingPage.dart';
import '../../widgets/carddesign.dart';
import 'dart:ui';

// Enum for menu items
enum CardMenuOptions {
  changeStatus,
  pinAttempts,
  clientIdentifier
}

class CardPage extends StatefulWidget {
  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  int _selectedCardIndex = 0;
  List<dynamic> _cards = [];
  bool _isLoading = true;
  bool _hasError = false;
  bool _isHidden = true;
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    fetchCards();
  }

  Future<void> fetchCards() async {
    try {
      CardContract contract = await apiService.fetchCardContract("2507355660");
      setState(() {
        _cards.add(contract);
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching card contract: $e");
    }
  }

  void _handleMenuOption(CardMenuOptions option, CardContract card) {
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

  Widget _buildCardWithMenu(CardContract card, int index) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedCardIndex = index;
            });
          },
          child: CardDesign(card: card),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: PopupMenuButton<CardMenuOptions>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: (CardMenuOptions option) => _handleMenuOption(option, card),
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
                onTap: (){
                  apiService.updateCardPinAttempts("2507355660");
                },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        title: Text(
          "My Cards",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _hasError
            ? Center(child: Text("Failed to load data. Try again."))
            : _cards.isEmpty
            ? Center(child: Text("No cards available"))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_cards.length, (index) {
                  return _buildCardWithMenu(_cards[index], index);
                }),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Card Details',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(
                      _isHidden ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isHidden = !_isHidden;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            _buildCardDetails(_cards[_selectedCardIndex]),
            SizedBox(height: 30),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildCardDetails(CardContract card) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBlurContainer('Account Number: ${card.cbsNumber}', _isHidden),
        _buildBlurContainer('Available Balance : ${card.availableBalance}', _isHidden),
        _buildBlurContainer('Card Status: ${card.cardContractStatusData.externalStatusName}', _isHidden),
        _buildBlurContainer('Card Expiry Date: ${card.cardExpiryDate}', _isHidden),
        _buildBlurContainer('Product Name: ${card.productName}', _isHidden),
      ],
    );
  }

  Widget _buildBlurContainer(String text, bool isHidden) {
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        if (isHidden)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
            ),
          ),
      ],
    );
  }
}