class ClientSearch {
  final String clientIdentifier;
  final String clientIdentifierType;


  ClientSearch({
    required this.clientIdentifier,
    required this.clientIdentifierType,

  });

  // Convert a JSON map into a Client instance
  factory ClientSearch.fromJson(Map<String, dynamic> json) {
    return ClientSearch(
      clientIdentifier: json['clientIdentifier'],
      clientIdentifierType: json['clientIdentifierType'],

    );
  }

  // Convert a Client instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'clientIdentifier': clientIdentifier,
      'clientIdentifierType': clientIdentifierType,
    };
  }
}

class Account {
  String accountContractIdentifier;
  String accountContractIdentifierType;

  Account({
    required this.accountContractIdentifier,
    required this.accountContractIdentifierType,
  });

  Map<String, dynamic> toJson() {
    return {
      "accountContractIdentifier": accountContractIdentifier,
      "accountContractIdentifierType": accountContractIdentifierType,
    };
  }
}


