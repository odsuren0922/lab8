import 'package:flutter/material.dart';
import 'package:project_1/firebase/firebase_service.dart';
import 'package:project_1/screens/receipt_screen.dart';
import '../dto/transaction.dart'; // Import Transaction model

class ConfirmScreen extends StatelessWidget {
  final Transactions transaction;
  final bool isCardSelected;
  final bool isBankSelected;

  const ConfirmScreen({
    super.key,
    required this.transaction,
    required this.isCardSelected,
    required this.isBankSelected,
  });

  Future<void> _confirmTransaction(BuildContext context) async {
    try {
      // Calculate the total amount (including the fee)
      double fee = transaction.amount * 0.1;
      double totalAmount = transaction.amount + fee;

      // Call the FirebaseService to confirm the transaction and generate the expense
      await FirebaseService.confirmTransaction(transaction.id, totalAmount);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction confirmed successfully')),
      );

      // Navigate to Receipt screen with the transaction details
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ReceiptScreen(transaction: transaction),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error confirming transaction: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Transaction'),
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Title Text
              Text(
                'Confirm Your ${transaction.category} Transaction',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
              ),
              const SizedBox(height: 30),

              // Transaction Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Amount:',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  Text(
                    '\$${transaction.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Fee (10%):',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  Text(
                    (transaction.amount * 0.1).toStringAsFixed(2),
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  Text(
                    (transaction.amount + transaction.amount * 0.1).toStringAsFixed(2),
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Button with cool style
              ElevatedButton(
                onPressed: () => _confirmTransaction(context),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Confirm Transaction',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
