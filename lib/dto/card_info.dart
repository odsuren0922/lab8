import 'package:cloud_firestore/cloud_firestore.dart';

class CardInfo {
  final String id;
  final String cardNumber;
  final String cardHolderName;
  final String expirationDate;
  final String cvv;
  final String? zipCode;

  CardInfo({
    this.id = '',
    required this.cardNumber,
    required this.cardHolderName,
    required this.expirationDate,
    required this.cvv,
    this.zipCode,
  });

  factory CardInfo.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CardInfo(
      id: doc.id,
      cardNumber: data['cardNumber'],
      cardHolderName: data['cardHolderName'],
      expirationDate: data['expirationDate'],
      cvv: data['cvv'],
      zipCode: data['zipCode'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'expirationDate': expirationDate,
      'cvv': cvv,
      'zipCode': zipCode,
    };
  }
}
