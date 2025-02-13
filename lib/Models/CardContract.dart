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

  factory CardContract.fromJson(Map<String,dynamic> json){
    return CardContract(
      accountContractId: json['accountContractId'],
      accountContractNumber: json['accountContractNumber'],
      amendmentDate: json['amendmentDate'],
      amendmentOfficerId: json['amendmentOfficerId'],
      amendmentOfficerName: json['amendmentOfficerName'],
      availableBalance: json['availableBalance'].toDouble(),
      blockedAmount: json['blockedAmount'].toDouble(),
      cardExpiryDate: json['cardExpiryDate'],
      cardContractId: json['cardContractId'],
      cardContractName: json['cardContractName'],
      cardContractNumber: json['cardContractNumber'],
      cardContractStatusData: CardContractStatusData.fromJson(json['cardContractStatusData']),
      cardholderId: json['cardholderId'],
      cbsNumber: json['cbsNumber'],
      creditLimit: json['creditLimit'],
      currency: json['currency'],
      dateOpen: json['dateOpen'],
      embossedData: EmbossedData.fromJson(json['embossedData']),
      maxPinAttempts: json['maxPinAttempts'],
      parentProductCode: json['parentProductCode'],
      pinAttemptsCounter: json['pinAttemptsCounter'],
      productCode: json['productCode'],
      productName: json['productName'],
      sequenceNumber: json['sequenceNumber'],
      encryptedCardContractNumber: json['encryptedCardContractNumber'],
    );
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