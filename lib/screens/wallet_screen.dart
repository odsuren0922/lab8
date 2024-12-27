import 'package:flutter/material.dart';
import 'package:project_1/screens/add_expense.dart';
import 'package:project_1/screens/pay_screen.dart';
import 'package:project_1/screens/transfer_screen.dart';
import '../firebase/firebase_service.dart';
import '../dto/transaction.dart';
import 'connect_wallet.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String? profileName;
  double totalBalance = 0.0;
  double totalIncome = 0.0;
  double totalOutcome = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  void _fetchTransactions() async {
    try {
      final fetchedTransactions = await FirebaseService.getTransactions();
      double income = 0.0;
      double outcome = 0.0;

      // Calculate income and outcome
      for (var transaction in fetchedTransactions) {
        if (transaction.category == 'Income') {
          income += transaction.amount;
        } else {
          outcome += transaction.amount.abs();
        }
      }

      setState(() {
        totalIncome = income;
        totalOutcome = outcome;
        totalBalance = income - outcome;
      });
    } catch (error) {
      print('Error fetching transactions: $error');
      setState(() {
        totalBalance = 0.0;
        totalIncome = 0.0;
        totalOutcome = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            // Balance Section
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.teal,
              child: Column(
                children: [
                  const Text(
                    'Нийт үлдэгдэл',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '\$${totalBalance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _actionButton(Icons.add, 'Нэмэх', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ConnectWallet(),
                          ),
                        );
                      }),
                      _actionButton(Icons.compare_arrows, 'Төлөх', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ExpenseScreen(),
                          ),
                        );
                      }),
                      _actionButton(Icons.send, 'Илгээх', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TransferScreen(),
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),

            // Tabs Section
            Container(
              color: Colors.grey[200],
              child: const TabBar(
                indicatorColor: Colors.teal,
                labelColor: Colors.teal,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: 'Гүйлгээнүүд'),
                  Tab(text: 'Хүлээгдэж буй гүйлгээ'),
                ],
              ),
            ),

            // Transactions Section
            Expanded(
              child: TabBarView(
                children: [
                  _transactionsList(),
                  _pendingTransactionsList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            child: Icon(
              icon,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }

  Widget _transactionsList() {
    return FutureBuilder<List<Transactions>>(
      future: FirebaseService.getTransactions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No transactions"));
        }

        final transactions = snapshot.data!;
        transactions.sort((a, b) => b.date.compareTo(a.date));

        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: Icon(transaction.icon, color: Colors.teal),
              ),
              title: Text(transaction.category),
              subtitle: Text(DateFormat('yyyy-MM-dd').format(transaction.date)),
              trailing: Text(
                '\$${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color:
                      transaction.type == 'outcome' ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _pendingTransactionsList() {
    return FutureBuilder<List<Transactions>>(
      future: FirebaseService.getPendingTransactions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No pending transactions"));
        }

        final transactions = snapshot.data!;

        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: Icon(transaction.icon, color: Colors.teal),
              ),
              title: Text(transaction.category),
              subtitle: Text(DateFormat('yyyy-MM-dd').format(transaction.date)),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PayScreen(transaction: transaction),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text('Төлөх'),
              ),
            );
          },
        );
      },
    );
  }
}
