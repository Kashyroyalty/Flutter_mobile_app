class Client {
  final String clientIdentifier;
  final String clientIdentifierType;

  Client({
    required this.clientIdentifier,
    required this.clientIdentifierType,
  });

  // Convert a JSON map into a Client instance
  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
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
