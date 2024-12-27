import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Transactions {
  final String id; // Document ID field
  final String label;
  final double amount;
  final String category;
  final DateTime date;
  final IconData icon;
  final String type;

  Transactions({
    required this.id, // Add ID to the constructor
    required this.label,
    required this.amount,
    required this.category,
    required this.date,
    required this.icon,
    required this.type,
  });

  // Adjusted fromMap function to handle missing fields safely
  factory Transactions.fromMap(Map<String, dynamic> data, String id) {
    return Transactions(
      id: id, // Pass ID to the constructor
      label: data['label'] ?? 'No label',
      amount: data['amount']?.toDouble() ?? 0.0,
      category: data['category'] ?? 'Unknown',
      date: (data['date'] as Timestamp).toDate(),
      icon: Icons.monetization_on,
      type: data['type'] ?? 'Unknown',
    );
  }
}
