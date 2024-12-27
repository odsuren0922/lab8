import 'package:flutter/material.dart';
import 'package:project_1/screens/confirm_screen.dart'; // Ensure the correct import path
import '../dto/transaction.dart'; // Import the Transaction model

class PayScreen extends StatefulWidget {
  final Transactions transaction;

  const PayScreen({super.key, required this.transaction});

  @override
  _PayScreenState createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  bool isCardSelected = false;
  bool isBankSelected = false;

  void _navigateToConfirmScreen() {
    if (isCardSelected || isBankSelected) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmScreen(
            transaction: widget.transaction,
            isCardSelected: isCardSelected,
            isBankSelected: isBankSelected,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Details'),
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
            // Title
            Text(
              'Transaction ${widget.transaction.category} Details:',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
            const SizedBox(height: 16),

            // Amount and Fee Rows
            _buildAmountRow('Amount', widget.transaction.amount),
            const SizedBox(height: 15),
            _buildAmountRow(
              'Fee (10%)',
              widget.transaction.amount * 0.1,
              isFee: true,
            ),
            const SizedBox(height: 15),
            Divider(),
            _buildAmountRow(
              'Total',
              widget.transaction.amount + widget.transaction.amount * 0.1,
              isTotal: true,
            ),

            const SizedBox(height: 20),
            // Payment Method Section
            Text('Choose Payment Method:',
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: isCardSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      isCardSelected = value!;
                      if (isCardSelected) isBankSelected = false;
                    });
                  },
                ),
                const Text('Card'),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: isBankSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      isBankSelected = value!;
                      if (isBankSelected) isCardSelected = false;
                    });
                  },
                ),
                const Text('Bank'),
              ],
            ),

            const SizedBox(height: 20),

            // Confirm Button
            ElevatedButton(
              onPressed: _navigateToConfirmScreen,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Pay Now',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build amount rows
  Widget _buildAmountRow(String label, double amount,
      {bool isFee = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 18,
            color: isFee
                ? Colors.red
                : isTotal
                    ? Colors.green
                    : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
