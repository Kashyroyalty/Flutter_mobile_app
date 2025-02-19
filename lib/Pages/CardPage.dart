import 'package:flutter/material.dart';
import 'package:online_banking_system/Constants/Colors.dart';
import 'package:online_banking_system/Models/ApiService.dart';
import 'package:online_banking_system/Models/CardContract.dart';
import 'package:online_banking_system/Pages/Card%20contract%20form%20page.dart';
import 'package:online_banking_system/Pages/CardContractStatusPage.dart';
import 'package:online_banking_system/Pages/ClientIdentifierPage.dart';
import 'package:online_banking_system/Pages/NotificationPage.dart';
import 'package:online_banking_system/Pages/PINAttemptsCounter.dart';
import 'package:online_banking_system/Pages/ProfilePage.dart';
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
  final Map<String, String> cardData; // Data passed from the form page

  CardPage({required this.cardData});

  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  CardContract? cardData;
  int _selectedCardIndex = 0;
  List<CardContract> _cards = [];  // Ensure List<CardContract> type for cards
  bool _isLoading = true;
  bool _hasError = false;
  bool _isHidden = true;
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    fetchCards();  // Call fetchCards on initialization
  }

  Future<void> fetchCards() async {
    try {
      CardContract contract = await apiService.fetchCardContract("2507355660");
      setState(() {
        _cards.add(contract);  // Add fetched card contract to the list
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching card contract: $e");
      setState(() {
        _isLoading = false;
        _hasError = true;  // Indicate error when fetch fails
      });
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('My Cards'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {
              // Navigate to NotificationPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
          ),
          IconButton(
            icon: CircleAvatar(
              radius: 14,
              child: Icon(Icons.person, size: 18), // Replacing image with a person icon
            ),
            onPressed: () {
              // Navigate to ProfilePage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CardContractformPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Add new card",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
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
