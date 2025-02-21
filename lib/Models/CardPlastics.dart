class CardPlastics {
  final int cardContractId;
  final String cardContractNumber;
  final String cardExpiryDate;
  final String chipScheme;
  final String companyName;
  final String effectiveDate;
  final String embossedName;
  final String orderSource;
  final String orderTarget;
  final String personalizationFileName;
  final int plasticId;
  final String productionCode;
  final String productionDate;
  final String productionEvent;
  final String productionReason;
  final String productionType;
  final String sequenceNumber;
  final String status;

  CardPlastics({
    required this.cardContractId,
    required this.cardContractNumber,
    required this.cardExpiryDate,
    required this.chipScheme,
    required this.companyName,
    required this.effectiveDate,
    required this.embossedName,
    required this.orderSource,
    required this.orderTarget,
    required this.personalizationFileName,
    required this.plasticId,
    required this.productionCode,
    required this.productionDate,
    required this.productionEvent,
    required this.productionReason,
    required this.productionType,
    required this.sequenceNumber,
    required this.status,
  });

  factory CardPlastics.fromJson(Map<String, dynamic> json) {
    return CardPlastics(
      cardContractId: json['cardContractId'],
      cardContractNumber: json['cardContractNumber'],
      cardExpiryDate: json['cardExpiryDate'],
      chipScheme: json['chipScheme'],
      companyName: json['companyName'],
      effectiveDate: json['effectiveDate'],
      embossedName: json['embossedName'],
      orderSource: json['orderSource'],
      orderTarget: json['orderTarget'],
      personalizationFileName: json['personalizationFileName'],
      plasticId: json['plasticId'],
      productionCode: json['productionCode'],
      productionDate: json['productionDate'],
      productionEvent: json['productionEvent'],
      productionReason: json['productionReason'],
      productionType: json['productionType'],
      sequenceNumber: json['sequenceNumber'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cardContractId': cardContractId,
      'cardContractNumber': cardContractNumber,
      'cardExpiryDate': cardExpiryDate,
      'chipScheme': chipScheme,
      'companyName': companyName,
      'effectiveDate': effectiveDate,
      'embossedName': embossedName,
      'orderSource': orderSource,
      'orderTarget': orderTarget,
      'personalizationFileName': personalizationFileName,
      'plasticId': plasticId,
      'productionCode': productionCode,
      'productionDate': productionDate,
      'productionEvent': productionEvent,
      'productionReason': productionReason,
      'productionType': productionType,
      'sequenceNumber': sequenceNumber,
      'status': status,
    };
  }
}

class EncryptedCardData {
  final String encryptedCardContractNumber;
  final String encryptedPinBlock;
  final String encryptedZpk;

  EncryptedCardData({
    required this.encryptedCardContractNumber,
    required this.encryptedPinBlock,
    required this.encryptedZpk,
  });

  factory EncryptedCardData.fromJson(Map<String, dynamic> json) {
    return EncryptedCardData(
      encryptedCardContractNumber: json['encryptedCardContractNumber'],
      encryptedPinBlock: json['encryptedPinBlock'],
      encryptedZpk: json['encryptedZpk'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'encryptedCardContractNumber': encryptedCardContractNumber,
      'encryptedPinBlock': encryptedPinBlock,
      'encryptedZpk': encryptedZpk,
    };
  }
}

class CardVerification {
  final String cardVerificationCode;
  final String encryptedCardVerificationCode;

  CardVerification({
    required this.cardVerificationCode,
    required this.encryptedCardVerificationCode,
  });

  factory CardVerification.fromJson(Map<String, dynamic> json) {
    return CardVerification(
      cardVerificationCode: json['cardVerificationCode'],
      encryptedCardVerificationCode: json['encryptedCardVerificationCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cardVerificationCode': cardVerificationCode,
      'encryptedCardVerificationCode': encryptedCardVerificationCode,
    };
  }
}
