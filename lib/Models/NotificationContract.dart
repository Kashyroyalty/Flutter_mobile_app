import 'dart:convert';

class NotificationContract {
  final String getClientFI;
  final String productCode;
  final String notificationType;
  final String clientNumber;
  final String cbsNumber;
  final String cardNumber;
  final String cardId;
  final String fields;
  final bool read;
  final bool auth;

  NotificationContract({
    required this.getClientFI,
    required this.productCode,
    required this.notificationType,
    required this.clientNumber,
    required this.cbsNumber,
    required this.cardNumber,
    required this.cardId,
    required this.fields,
    required this.read,
    required this.auth,
  });

  factory NotificationContract.fromJson(Map<String, dynamic> json) {
    return NotificationContract(
      getClientFI: json['getclientF_I'],
      productCode: json['productCode'],
      notificationType: json['notificationType'],
      clientNumber: json['clientNumber'],
      cbsNumber: json['cbsNumber'],
      cardNumber: json['cardNumber'],
      cardId: json['cardId'],
      fields: json['fields'],
      read: json['read'],
      auth: json['auth'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'getclientF_I': getClientFI,
      'productCode': productCode,
      'notificationType': notificationType,
      'clientNumber': clientNumber,
      'cbsNumber': cbsNumber,
      'cardNumber': cardNumber,
      'cardId': cardId,
      'fields': fields,
      'read': read,
      'auth': auth,
    };
  }

  static List<NotificationContract> fromJsonList(String jsonString) {
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((item) => NotificationContract.fromJson(item)).toList();
  }

  static String toJsonList(List<NotificationContract> dataList) {
    final List<Map<String, dynamic>> jsonData =
    dataList.map((item) => item.toJson()).toList();
    return json.encode(jsonData);
  }
}
