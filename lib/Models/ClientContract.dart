import 'dart:convert';

import 'CardContract.dart';

class Client {
  final DateTime additionalDate01;
  final DateTime additionalDate02;
  final ClientBaseAddressData clientBaseAddressData;
  final ClientCompanyData clientCompanyData;
  final ClientContactData clientContactData;
  final ClientIdentificationData clientIdentificationData;
  final ClientPersonalData clientPersonalData;
  final DateTime clientExpiryDate;
  final EmbossedData embossedData;
  final DateTime amendmentDate;
  final int amendmentOfficerId;
  final String amendmentOfficerName;
  final int clientId;
  final String clientNumber;
  final String clientType;
  final DateTime dateOpen;
  final String orderDepartment;
  final String serviceGroupCode;

  Client({
    required this.additionalDate01,
    required this.additionalDate02,
    required this.clientBaseAddressData,
    required this.clientCompanyData,
    required this.clientContactData,
    required this.clientIdentificationData,
    required this.clientPersonalData,
    required this.clientExpiryDate,
    required this.embossedData,
    required this.amendmentDate,
    required this.amendmentOfficerId,
    required this.amendmentOfficerName,
    required this.clientId,
    required this.clientNumber,
    required this.clientType,
    required this.dateOpen,
    required this.orderDepartment,
    required this.serviceGroupCode,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      additionalDate01: DateTime.parse(json['additionalDate01']),
      additionalDate02: DateTime.parse(json['additionalDate02']),
      clientBaseAddressData: ClientBaseAddressData.fromJson(json['clientBaseAddressData']),
      clientCompanyData: ClientCompanyData.fromJson(json['clientCompanyData']),
      clientContactData: ClientContactData.fromJson(json['clientContactData']),
      clientIdentificationData: ClientIdentificationData.fromJson(json['clientIdentificationData']),
      clientPersonalData: ClientPersonalData.fromJson(json['clientPersonalData']),
      clientExpiryDate: DateTime.parse(json['clientExpiryDate']),
      embossedData: EmbossedData.fromJson(json['embossedData']),
      amendmentDate: DateTime.parse(json['amendmentDate']),
      amendmentOfficerId: json['amendmentOfficerId'],
      amendmentOfficerName: json['amendmentOfficerName'],
      clientId: json['clientId'],
      clientNumber: json['clientNumber'],
      clientType: json['clientType'],
      dateOpen: DateTime.parse(json['dateOpen']),
      orderDepartment: json['orderDepartment'],
      serviceGroupCode: json['serviceGroupCode'],
    );
  }
}

class ClientIdentificationData {
  static fromJson(json) {}
}

class ClientPersonalData {
  static fromJson(json) {}
}

class ClientContactData {
  static fromJson(json) {}
}

class ClientBaseAddressData {
  final String addressLine1;
  final String addressLine2;
  final String addressLine3;
  final String addressLine4;
  final String city;
  final String country;
  final String postalCode;
  final String state;

  ClientBaseAddressData({
    required this.addressLine1,
    required this.addressLine2,
    required this.addressLine3,
    required this.addressLine4,
    required this.city,
    required this.country,
    required this.postalCode,
    required this.state,
  });

  factory ClientBaseAddressData.fromJson(Map<String, dynamic> json) {
    return ClientBaseAddressData(
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      addressLine3: json['addressLine3'],
      addressLine4: json['addressLine4'],
      city: json['city'],
      country: json['country'],
      postalCode: json['postalCode'],
      state: json['state'],
    );
  }
}

// Define other classes similarly: ClientCompanyData, ClientContactData, 
// ClientIdentificationData, ClientPersonalData, and EmbossedData.

// Example for one more class:
class ClientCompanyData {
  final String companyDepartment;
  final String companyName;
  final String companyTradeName;
  final String position;

  ClientCompanyData({
    required this.companyDepartment,
    required this.companyName,
    required this.companyTradeName,
    required this.position,
  });

  factory ClientCompanyData.fromJson(Map<String, dynamic> json) {
    return ClientCompanyData(
      companyDepartment: json['companyDepartment'],
      companyName: json['companyName'],
      companyTradeName: json['companyTradeName'],
      position: json['position'],
    );
  }
}
