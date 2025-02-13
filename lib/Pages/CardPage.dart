import 'package:flutter/material.dart';
import 'package:online_banking_system/Constants/Colors.dart';
import 'package:online_banking_system/Models/ApiService.dart';
import 'package:online_banking_system/Models/CardContract.dart';
import '../../widgets/carddesign.dart';
import 'dart:ui';

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
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCardIndex = index;
                      });
                    },
                    child: CardDesign(card: _cards[index]),
                  );
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
