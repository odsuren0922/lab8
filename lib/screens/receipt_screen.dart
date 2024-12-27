import 'package:flutter/material.dart';
import '../dto/transaction.dart'; // Transaction model import

class ReceiptScreen extends StatelessWidget {
  final Transactions transaction;

  const ReceiptScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    // Generate the transaction date and ID if needed
    final String transactionDate = DateTime.now().toString();
    final String transactionId = transaction.id.toString();

    // Calculate the expense (10% fee)
    final double fee = transaction.amount * 0.1;
    final double total = transaction.amount + fee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/other_back.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transaction Successful',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Payment Method
            // _buildDetailRow('Payment Method:',
            //     transaction.isCardSelecte ? 'Card' : 'Bank'),
            // const SizedBox(height: 8),

            // Transaction ID
            _buildDetailRow('Transaction ID:', transactionId),
            const SizedBox(height: 8),

            // Date of transaction
            _buildDetailRow('Date:', transactionDate),
            const SizedBox(height: 8),

            // Amount
            _buildDetailRow(
                'Amount:', '\$${transaction.amount.toStringAsFixed(2)}'),
            const SizedBox(height: 8),

            // Expense (Fee)
            _buildDetailRow(
                'Expense (10% Fee):', '\$${fee.toStringAsFixed(2)}'),
            const SizedBox(height: 8),

            // Total
            _buildDetailRow('Total:', '\$${total.toStringAsFixed(2)}'),
            const SizedBox(height: 20),

            // QR Code for Transaction ID
            Center(
              child: Image.asset(
                'assets/images/qr.png', // Replace with your image path
                width: 200, // Set the width of the image
                height: 200, // Set the height of the image
                fit: BoxFit
                    .cover, // You can adjust how the image fits within the box
              ),
            ),

            const SizedBox(height: 20),

            // Return Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/mainnavigation'); // Pop to the previous screen
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Return to Home',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create transaction detail rows
  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
