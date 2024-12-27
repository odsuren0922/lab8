import 'package:flutter/material.dart';
import 'package:project_1/firebase/firebase_service.dart';
import 'package:project_1/dto/transaction.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? profileName;
  double totalBalance = 0.0;
  double totalIncome = 0.0;
  double totalOutcome = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
    _fetchTransactions();
  }

  void _fetchProfile() async {
    try {
      final profileData = await FirebaseService.getProfile();
      setState(() {
        profileName = profileData['fullName'] ?? 'Unknown';
      });
    } catch (error) {
      print('Error fetching profile data: $error');
      setState(() {
        profileName = 'Unknown';
      });
    }
  }

  void _fetchTransactions() async {
    try {
      final fetchedTransactions = await FirebaseService.getTransactions();
      double income = 0.0;
      double outcome = 0.0;

      // Calculate income and outcome
      for (var transaction in fetchedTransactions) {
        if (transaction.type == 'income' ) {
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
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: -10,
            right: 0,
            child: Image.asset(
              'assets/images/other_back.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 50,
            left: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Өдрийн мэнд!',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  profileName ?? 'Loading...',
                  style: const TextStyle(color: Colors.white, fontSize: 28),
                ),
              ],
            ),
          ),
          Positioned(
            top: 160,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF3E7C78),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Нийт үлдэгдэл ^",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '\$${totalBalance.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Орлого',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            '\$${totalIncome.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Зарлага',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            '\$${totalOutcome.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            height: 480,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 32,
                bottom: 60,
                right: 32,
                top: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'Гүйлгээний Түүх',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          //
                        },
                        child: const Text(
                          'Бүгдийг харах',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: _transactionsList()),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
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
      transactions.sort((a, b) => b.date.compareTo(a.date)); // Sort by date desc

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
                color: transaction.type == 'outcome' ? Colors.red : Colors.green,
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
