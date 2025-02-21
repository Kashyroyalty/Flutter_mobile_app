import 'dart:ffi';

class CardContract {
  final int? accountContractId;
  final String? accountContractNumber;
  final String? amendmentDate;
  final int? amendmentOfficerId;
  final String? amendmentOfficerName;
  final double? availableBalance;
  final double? blockedAmount;
  final String? cardExpiryDate;
  final int? cardContractId;
  final String? cardContractName;
  final String? cardContractNumber;
  final CardContractStatusData? cardContractStatusData;
  final int? cardholderId;
  final String? cbsNumber;
  final double? creditLimit;
  final String? currency;
  final String? dateOpen;
  final EmbossedData embossedData;
  final int? maxPinAttempts;
  final String? parentProductCode;
  final int? pinAttemptsCounter;
  final String? productCode;
  final String? productName;
  final String? sequenceNumber;
  final String? encryptedCardContractNumber;

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
    return CardContract(
      accountContractId: (json['accountContractId'] ?? 0.0),
      accountContractNumber: json['accountContractNumber'] as String ?? '',
      amendmentDate: json['amendmentDate'] as String ?? '',
      amendmentOfficerId: (json['amendmentOfficerId'] ?? 0.0),
      amendmentOfficerName: json['amendmentOfficerName'] as String ?? '',
      availableBalance: (json['availableBalance'] as num?)?.toDouble(),
      blockedAmount: (json['blockedAmount']as num?)?.toDouble(),
      cardExpiryDate: json['cardExpiryDate'] as String ?? '',
      cardContractId: (json['cardContractId'] ?? 0.0),
      cardContractName: json['cardContractName'] as String? ?? '',
      cardContractNumber: json['cardContractNumber'] as String? ?? '',
      cardContractStatusData: json.containsKey('cardContractStatusData') && json['cardContractStatusData'] != null
          ? CardContractStatusData.fromJson(json['cardContractStatusData'] as Map<String, dynamic>)
          : CardContractStatusData.defaultData(), // Safe default object
      cardholderId: (json['cardholderId']?? 0.0),
      cbsNumber: json['cbsNumber'] as String? ?? '',
      creditLimit: (json['creditLimit'] as num?)?.toDouble(),
      currency: json['currency'] as String? ?? '',
      dateOpen: json['dateOpen']  as String?? '',
      embossedData: json.containsKey('embossedData') && json['embossedData'] != null
          ? EmbossedData.fromJson(json['embossedData'] as Map<String, dynamic>)
          : EmbossedData.defaultData(), // Safe default object
      maxPinAttempts: (json['maxPinAttempts']?? 0.0),
      parentProductCode: json['parentProductCode'] as String? ?? '',
      pinAttemptsCounter: (json['pinAttemptsCounter'] ?? 0.0),
      productCode: json['productCode'] as String? ?? '',
      productName: json['productName'] as String? ?? '',
      sequenceNumber: json['sequenceNumber'] as String? ?? '',
      encryptedCardContractNumber: json['encryptedCardContractNumber'] as String? ?? '',
    );
  }

  static fromMap(Map<String, String> cardData) {
    // Implement logic as needed
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
      externalStatusCode: json['externalStatusCode'] as String? ?? '',
      externalStatusName: json['externalStatusName'] as String? ?? '',
      statusCode: json['statusCode'] as String? ?? '',
      statusName: json['statusName'] as String? ?? '',
      productionStatus: json['productionStatus'] as String? ?? '',
    );
  }

  // Default constructor to avoid null issues
  factory CardContractStatusData.defaultData() {
    return CardContractStatusData(
      externalStatusCode: '',
      externalStatusName: '',
      statusCode: '',
      statusName: '',
      productionStatus: '',
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
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
    );
  }

  // Default constructor to avoid null issues
  factory EmbossedData.defaultData() {
    return EmbossedData(
      firstName: '',
      lastName: '',
    );
  }
}