class AccountContract {
  final AccountContractBalances accountContractBalances;
  final int accountContractId;
  final String accountContractLevel;
  final String accountContractName;
  final String accountContractNumber;
  final AccountContractOwner accountContractOwner;
  final AccountContractStatusData accountContractStatusData;
  final String accountContractSubtype;
  final String additionalParameters;
  final String amendmentDate;
  final int amendmentOfficerId;
  final String amendmentOfficerName;
  final int billingAccountContractId;
  final String billingAccountContractNumber;
  final String branchCode;
  final String branchName;
  final String cbsNumber;
  final double balance;
  final String currency;
  final String currencyNumericCode;
  final String dateClose;
  final String dateOpen;
  final String dueDate;
  final String lastBillingDate;
  final String leaf;
  final int liabilityAccountContractId;
  final String liabilityAccountContractNumber;
  final String liabilityCategory;
  final String mainProductCode;
  final String nextBillingDate;
  final int parentAccountContractId;
  final String parentAccountContractNumber;
  final String parentProductCode;
  final String pastDueDate;
  final int pastDueDays;
  final String productCode;
  final String productName;
  final String serviceGroupCode;
  final String serviceGroupName;
  final int topAccountContractId;
  final String topAccountContractNumber;

  AccountContract({
    required this.accountContractBalances,
    required this.accountContractId,
    required this.accountContractLevel,
    required this.accountContractName,
    required this.accountContractNumber,
    required this.accountContractOwner,
    required this.balance,
    required this.accountContractStatusData,
    required this.accountContractSubtype,
    required this.additionalParameters,
    required this.amendmentDate,
    required this.amendmentOfficerId,
    required this.amendmentOfficerName,
    required this.billingAccountContractId,
    required this.billingAccountContractNumber,
    required this.branchCode,
    required this.branchName,
    required this.cbsNumber,
    required this.currency,
    required this.currencyNumericCode,
    required this.dateClose,
    required this.dateOpen,
    required this.dueDate,
    required this.lastBillingDate,
    required this.leaf,
    required this.liabilityAccountContractId,
    required this.liabilityAccountContractNumber,
    required this.liabilityCategory,
    required this.mainProductCode,
    required this.nextBillingDate,
    required this.parentAccountContractId,
    required this.parentAccountContractNumber,
    required this.parentProductCode,
    required this.pastDueDate,
    required this.pastDueDays,
    required this.productCode,
    required this.productName,
    required this.serviceGroupCode,
    required this.serviceGroupName,
    required this.topAccountContractId,
    required this.topAccountContractNumber,
  });

  factory AccountContract.fromJson(Map<String, dynamic> json) {
    return AccountContract(
      accountContractBalances: AccountContractBalances.fromJson(json['accountContractBalances']),
      accountContractId: json['accountContractId'],
      accountContractLevel: json['accountContractLevel'],
      accountContractName: json['accountContractName'],
      accountContractNumber: json['accountContractNumber'],
      accountContractOwner: AccountContractOwner.fromJson(json['accountContractOwner']),
      accountContractStatusData: AccountContractStatusData.fromJson(json['accountContractStatusData']),
      accountContractSubtype: json['accountContractSubtype'],
      additionalParameters: json['additionalParameters'],
      amendmentDate: json['amendmentDate'],
      amendmentOfficerId: json['amendmentOfficerId'],
      amendmentOfficerName: json['amendmentOfficerName'],
      billingAccountContractId: json['billingAccountContractId'],
      billingAccountContractNumber: json['billingAccountContractNumber'],
      branchCode: json['branchCode'],
      balance: (json['balance'] ?? 0).toDouble(),
      branchName: json['branchName'],
      cbsNumber: json['cbsNumber'],
      currency: json['currency'],
      currencyNumericCode: json['currencyNumericCode'],
      dateClose: json['dateClose'],
      dateOpen: json['dateOpen'],
      dueDate: json['dueDate'],
      lastBillingDate: json['lastBillingDate'],
      leaf: json['leaf'],
      liabilityAccountContractId: json['liabilityAccountContractId'],
      liabilityAccountContractNumber: json['liabilityAccountContractNumber'],
      liabilityCategory: json['liabilityCategory'],
      mainProductCode: json['mainProductCode'],
      nextBillingDate: json['nextBillingDate'],
      parentAccountContractId: json['parentAccountContractId'],
      parentAccountContractNumber: json['parentAccountContractNumber'],
      parentProductCode: json['parentProductCode'],
      pastDueDate: json['pastDueDate'],
      pastDueDays: json['pastDueDays'],
      productCode: json['productCode'],
      productName: json['productName'],
      serviceGroupCode: json['serviceGroupCode'],
      serviceGroupName: json['serviceGroupName'],
      topAccountContractId: json['topAccountContractId'],
      topAccountContractNumber: json['topAccountContractNumber'],
    );
  }
}

class AccountContractStatusData {
  final String statusCode;
  final String statusName;
  final String externalStatusCode;
  final String externalStatusName;

  AccountContractStatusData({
    required this.statusCode,
    required this.statusName,
    required this.externalStatusCode,
    required this.externalStatusName,
  });

  factory AccountContractStatusData.fromJson(Map<String, dynamic> json) {
    return AccountContractStatusData(
      statusCode: json['statusCode'],
      statusName: json['statusName'],
      externalStatusCode: json['externalStatusCode'],
      externalStatusName: json['externalStatusName'],
    );
  }
}


class AccountContractBalances {
  final double additionalLimit;
  final double available;
  final double balance;
  final double blockedAmount;
  final double creditLimit;
  final double pastDue;
  final double totalDue;

  AccountContractBalances({
    required this.additionalLimit,
    required this.available,
    required this.balance,
    required this.blockedAmount,
    required this.creditLimit,
    required this.pastDue,
    required this.totalDue,
  });

  factory AccountContractBalances.fromJson(Map<String, dynamic> json) {
    return AccountContractBalances(
      additionalLimit: json['additionalLimit'],
      available: json['available'],
      balance: json['balance'],
      blockedAmount: json['blockedAmount'],
      creditLimit: json['creditLimit'],
      pastDue: json['pastDue'],
      totalDue: json['totalDue'],
    );
  }
}

class AccountContractOwner {
  final int accountContractOwnerId;
  final String accountContractOwnerNumber;
  final String accountContractOwnerName;

  AccountContractOwner({
    required this.accountContractOwnerId,
    required this.accountContractOwnerNumber,
    required this.accountContractOwnerName,
  });

  factory AccountContractOwner.fromJson(Map<String, dynamic> json) {
    return AccountContractOwner(
      accountContractOwnerId: json['accountContractOwnerId'],
      accountContractOwnerNumber: json['accountContractOwnerNumber'],
      accountContractOwnerName: json['accountContractOwnerName'],
    );
  }
}
