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

enum CardMenuOptions {
  changeStatus,
  pinAttempts,
  clientIdentifier
}

class CardPage extends StatefulWidget {
  final Map<String, String> cardData;

  const CardPage({Key? key, required this.cardData}) : super(key: key);

  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  CardContract? cardData;
  int _selectedCardIndex = 0;
  List<CardContract> _cards = [];
  bool _isLoading = true;
  bool _hasError = false;
  bool _isHidden = true;
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await fetchCards();
    if (widget.cardData.isNotEmpty) {
      _addNewCard(widget.cardData);
    }
  }

  void _addNewCard(Map<String, String> cardData) {
    try {
      CardContract newCard = CardContract.fromMap(cardData);
      setState(() {
        _cards.add(newCard);
        _selectedCardIndex = _cards.length - 1;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding new card: $e'))
      );
    }
  }

  Future<void> fetchCards() async {
    try {
      CardContract contract = await apiService.fetchCardContract("2507355660");
      setState(() {
        _cards.add(contract);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching cards: $e'))
      );
    }
  }

  void _handleMenuOption(CardMenuOptions option, CardContract card) async {
    switch (option) {
      case CardMenuOptions.changeStatus:
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CardContractStatusPage()
          ),
        );
        fetchCards(); // Refresh cards after status change
        break;
      case CardMenuOptions.pinAttempts:
        try {
          await apiService.updateCardPinAttempts(card.cardContractNumber);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('PIN attempts reset successfully'))
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error resetting PIN attempts: $e'))
          );
        }
        break;
      case CardMenuOptions.clientIdentifier:
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => clientidentifierpage()
          ),
        );
        break;
    }
  }

  Widget _buildCardWithMenu(CardContract card, int index) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: Stack(
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
      ),
    );
  }

  Widget _buildCardDetails(CardContract card) {
    final formatBalance = (double balance) => balance.toStringAsFixed(2);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBlurContainer('Account Number: ${card.cbsNumber}', _isHidden),
          _buildBlurContainer('Available Balance: ${formatBalance(card.availableBalance)} ${card.currency}', _isHidden),
          _buildBlurContainer('Card Status: ${card.cardContractStatusData.externalStatusName}', _isHidden),
          _buildBlurContainer('Card Expiry Date: ${card.cardExpiryDate}', _isHidden),
          _buildBlurContainer('Product Name: ${card.productName}', _isHidden),
          _buildBlurContainer('Cardholder: ${card.embossedData.firstName} ${card.embossedData.lastName}', _isHidden),
          _buildBlurContainer('Credit Limit: ${formatBalance(card.creditLimit.toDouble())} ${card.currency}', _isHidden),
        ],
      ),
    );
  }

  Widget _buildBlurContainer(String text, bool isHidden) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('My Cards'),
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
      body: RefreshIndicator(
        onRefresh: fetchCards,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _hasError
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Failed to load cards"),
                  ElevatedButton(
                    onPressed: fetchCards,
                    child: Text("Try Again"),
                  ),
                ],
              ),
            )
                : _cards.isEmpty
                ? Center(child: Text("No cards available"))
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      _cards.length,
                          (index) => _buildCardWithMenu(_cards[index], index),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Card Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(_isHidden ? Icons.visibility_off : Icons.visibility),
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
                    onPressed: () async {
                      final result = await Navigator.push<Map<String, String>>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CardContractformPage(),
                        ),
                      );

                      if (result != null) {
                        _addNewCard(result);
                      }
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
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}