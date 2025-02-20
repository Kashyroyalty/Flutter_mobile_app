class TransactionContract {
  final double count;
  final double limit;
  final double offset;
  final double total;
  final List<Transaction> transactions;

  TransactionContract({
    required this.count,
    required this.limit,
    required this.offset,
    required this.total,
    required this.transactions,
  });

  factory TransactionContract.fromJson(Map<String, dynamic> json) {
    return TransactionContract(
      count: json['count'],
      limit: json['limit'],
      offset: json['offset'],
      total: json['total'],
      transactions: (json['transactions'] as List)
          .map((item) => Transaction.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'count': count,
    'limit': limit,
    'offset': offset,
    'total': total,
    'transactions': transactions.map((t) => toJson()).toList(),
  };
}

class Transaction {
  final String accountCurrency;
  final String accountCurrencyNumericCode;
  final String arn;
  final String authorizationCode;
  final bool authorized;
  final double authorizationId;
  final double baseAmount;
  final List<CustomTransactionData> customTransactionData;
  final String customTransactionCondition;
  final String customTransactionTypeCode;
  final double feeAmount;
  final String feeDescription;
  final double financialDocumentId;
  final String fxRate;
  final double installmentChainId;
  final String installmentPlanStatus;
  final String mcc;
  final String mccDescription;
  final String merchantCountry;
  final String merchantLocation;
  final String merchantName;
  final String postingDate;
  final double responseCode;
  final String responseCodeDescription;
  final String rrn;
  final String serviceClassCode;
  final String settlementAmount;
  final String settlementCurrency;
  final String settlementCurrencyNumericCode;
  final String sourceContractCbsNumber;
  final double sourceContractId;
  final String sourceContractNumber;
  final String srn;
  final String targetContractCbsNumber;
  final double targetContractId;
  final String targetContractNumber;
  final String tokenNumberSafe;
  final double transactionAmount;
  final String transactionCurrency;
  final String transactionCurrencyNumericCode;
  final String transactionDate;
  final String transactionDescription;
  final double transactionId;
  final String transactionStatus;
  final String transactionType;
  final String transactionTypeCode;
  final String walletId;

  Transaction({
    required this.accountCurrency,
    required this.accountCurrencyNumericCode,
    required this.arn,
    required this.authorizationCode,
    required this.authorized,
    required this.authorizationId,
    required this.baseAmount,
    required this.customTransactionData,
    required this.customTransactionCondition,
    required this.customTransactionTypeCode,
    required this.feeAmount,
    required this.feeDescription,
    required this.financialDocumentId,
    required this.fxRate,
    required this.installmentChainId,
    required this.installmentPlanStatus,
    required this.mcc,
    required this.mccDescription,
    required this.merchantCountry,
    required this.merchantLocation,
    required this.merchantName,
    required this.postingDate,
    required this.responseCode,
    required this.responseCodeDescription,
    required this.rrn,
    required this.serviceClassCode,
    required this.settlementAmount,
    required this.settlementCurrency,
    required this.settlementCurrencyNumericCode,
    required this.sourceContractCbsNumber,
    required this.sourceContractId,
    required this.sourceContractNumber,
    required this.srn,
    required this.targetContractCbsNumber,
    required this.targetContractId,
    required this.targetContractNumber,
    required this.tokenNumberSafe,
    required this.transactionAmount,
    required this.transactionCurrency,
    required this.transactionCurrencyNumericCode,
    required this.transactionDate,
    required this.transactionDescription,
    required this.transactionId,
    required this.transactionStatus,
    required this.transactionType,
    required this.transactionTypeCode,
    required this.walletId,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      accountCurrency: json['accountCurrency'],
      accountCurrencyNumericCode: json['accountCurrencyNumericCode'],
      arn: json['arn'],
      authorizationCode: json['authorizationCode'],
      authorized: json['authorized'],
      authorizationId: json['authorizationId'],
      baseAmount: json['baseAmount'].toDouble(),
      customTransactionData: (json['customTransactionData'] as List)
          .map((item) => CustomTransactionData.fromJson(item))
          .toList(),
      customTransactionCondition: json['customTransactionCondition'],
      customTransactionTypeCode: json['customTransactionTypeCode'],
      feeAmount: json['feeAmount'].toDouble(),
      feeDescription: json['feeDescription'],
      financialDocumentId: json['financialDocumentId'],
      fxRate: json['fxRate'],
      installmentChainId: json['installmentChainId'],
      installmentPlanStatus: json['installmentPlanStatus'],
      mcc: json['mcc'],
      mccDescription: json['mccDescription'],
      merchantCountry: json['merchantCountry'],
      merchantLocation: json['merchantLocation'],
      merchantName: json['merchantName'],
      postingDate: json['postingDate'],
      responseCode: json['responseCode'],
      responseCodeDescription: json['responseCodeDescription'],
      rrn: json['rrn'],
      serviceClassCode: json['serviceClassCode'],
      settlementAmount: json['settlementAmount'],
      settlementCurrency: json['settlementCurrency'],
      settlementCurrencyNumericCode: json['settlementCurrencyNumericCode'],
      sourceContractCbsNumber: json['sourceContractCbsNumber'],
      sourceContractId: json['sourceContractId'],
      sourceContractNumber: json['sourceContractNumber'],
      srn: json['srn'],
      targetContractCbsNumber: json['targetContractCbsNumber'],
      targetContractId: json['targetContractId'],
      targetContractNumber: json['targetContractNumber'],
      tokenNumberSafe: json['tokenNumberSafe'],
      transactionAmount: json['transactionAmount'].toDouble(),
      transactionCurrency: json['transactionCurrency'],
      transactionCurrencyNumericCode: json['transactionCurrencyNumericCode'],
      transactionDate: json['transactionDate'],
      transactionDescription: json['transactionDescription'],
      transactionId: json['transactionId'],
      transactionStatus: json['transactionStatus'],
      transactionType: json['transactionType'],
      transactionTypeCode: json['transactionTypeCode'],
      walletId: json['walletId'],
    );
  }
}

class CustomTransactionData {
  final String tagName;
  final String tagValue;

  CustomTransactionData({required this.tagName, required this.tagValue});

  factory CustomTransactionData.fromJson(Map<String, dynamic> json) =>
      CustomTransactionData(tagName: json['tagName'], tagValue: json['tagValue']);
}
