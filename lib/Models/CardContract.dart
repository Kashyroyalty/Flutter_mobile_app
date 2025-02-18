import 'package:http/http.dart' as http;

class CardContract{
  final int accountContractId;
  final String accountContractNumber;
  final String amendmentDate;
  final int amendmentOfficerId;
  final String amendmentOfficerName;
  final double availableBalance;
  final double blockedAmount;
  final String cardExpiryDate;
  final int cardContractId;
  final String cardContractName;
  final String cardContractNumber;
  final CardContractStatusData cardContractStatusData;
  final int cardholderId;
  final String cbsNumber;
  final int creditLimit;
  final String currency;
  final String dateOpen;
  final EmbossedData embossedData;
  final int maxPinAttempts;
  final String parentProductCode;
  final int pinAttemptsCounter;
  final String productCode;
  final String productName;
  final String sequenceNumber;
  final String encryptedCardContractNumber;

  CardContract({
    required this.accountContractId,
    required this.accountContractNumber,
    required this.amendmentDate,
    required this.amendmentOfficerId,
    required this.amendmentOfficerName,
    required this.availableBalance,
    required this.blockedAmount,
    required this.cardExpiryDate,
    required this.cardContractId,
    required this.cardContractName,
    required this.cardContractNumber,
    required this.cardContractStatusData,
    required this.cardholderId,
    required this.cbsNumber,
    required this.creditLimit,
    required this.currency,
    required this.dateOpen,
    required this.embossedData,
    required this.maxPinAttempts,
    required this.parentProductCode,
    required this.pinAttemptsCounter,
    required this.productCode,
    required this.productName,
    required this.sequenceNumber,
    required this.encryptedCardContractNumber,
  });

  factory CardContract.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'accountContractId': num accountContractId,
      'accountContractNumber': String accountContractNumber,
      'amendmentDate': String amendmentDate,
      'amendmentOfficerId': num amendmentOfficerId,
      'amendmentOfficerName': String amendmentOfficerName,
      'availableBalance': num availableBalance,
      'blockedAmount': num blockedAmount,
      'cardExpiryDate': String cardExpiryDate,
      'cardContractId': num cardContractId,
      'cardContractName': String cardContractName,
      'cardContractNumber': String cardContractNumber,
      'cardContractStatusData': Map<String, dynamic> cardContractStatusData,
      'cardholderId': num cardholderId,
      'cbsNumber': String cbsNumber,
      'creditLimit': num creditLimit,
      'currency': String currency,
      'dateOpen': String dateOpen,
      'embossedData': Map<String, dynamic> embossedData,
      'maxPinAttempts': num maxPinAttempts,
      'parentProductCode': String parentProductCode,
      'pinAttemptsCounter': num pinAttemptsCounter,
      'productCode': String productCode,
      'productName': String productName,
      'sequenceNumber': String sequenceNumber,
      'encryptedCardContractNumber': String encryptedCardContractNumber,
      } => CardContract(
        accountContractId: accountContractId.toInt(),
        accountContractNumber: accountContractNumber,
        amendmentDate: amendmentDate,
        amendmentOfficerId: amendmentOfficerId.toInt(),
        amendmentOfficerName: amendmentOfficerName,
        availableBalance: availableBalance.toDouble(),
        blockedAmount: blockedAmount.toDouble(),
        cardExpiryDate: cardExpiryDate,
        cardContractId: cardContractId.toInt(),
        cardContractName: cardContractName,
        cardContractNumber: cardContractNumber,
        cardContractStatusData: CardContractStatusData.fromJson(cardContractStatusData),
        cardholderId: cardholderId.toInt(),
        cbsNumber: cbsNumber,
        creditLimit: creditLimit.toInt(),
        currency: currency,
        dateOpen: dateOpen,
        embossedData: EmbossedData.fromJson(embossedData),
        maxPinAttempts: maxPinAttempts.toInt(),
        parentProductCode: parentProductCode,
        pinAttemptsCounter: pinAttemptsCounter.toInt(),
        productCode: productCode,
        productName: productName,
        sequenceNumber: sequenceNumber,
        encryptedCardContractNumber: encryptedCardContractNumber,
      ),
      _ => throw const FormatException('Failed to load CardContract.'),
    };
  }


}

class CardContractStatusData {
  final String externalStatusCode;
  final String externalStatusName;
  final String statusCode;
  final String statusName;
  final String productionStatus;

  CardContractStatusData({
    required this.externalStatusCode,
    required this.externalStatusName,
    required this.statusCode,
    required this.statusName,
    required this.productionStatus,
  });

  factory CardContractStatusData.fromJson(Map<String, dynamic> json) {
    return CardContractStatusData(
      externalStatusCode: json['externalStatusCode'],
      externalStatusName: json['externalStatusName'],
      statusCode: json['statusCode'],
      statusName: json['statusName'],
      productionStatus: json['productionStatus'],
    );
  }
}

class EmbossedData {
  final String firstName;
  final String lastName;

  EmbossedData({
    required this.firstName,
    required this.lastName,
  });

  factory EmbossedData.fromJson(Map<String, dynamic> json) {
    return EmbossedData(
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}