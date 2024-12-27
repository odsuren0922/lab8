import 'package:flutter/material.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Шилжүүлэг хийх"),
        backgroundColor: const Color(0xFF178582),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Явуулах хүний нэр
            const Text(
              "Хүлээн авагчийн нэр",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                hintText: "Жишээ: Бат Эрдэнэ",
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            // Үнийн дүн
            const Text(
              "ҮНИЙН ДҮН",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                hintText: "\$ 0.00",
                prefixIcon: const Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 32),
            // Шилжүүлэг баталгаажуулах товч
            ElevatedButton.icon(
              onPressed: () {
                final String name = _nameController.text;
                final String amount = _amountController.text;

                if (name.isEmpty || amount.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Бүх талбарыг бөглөнө үү!"),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                      Text("$name-д \$ $amount шилжүүлэг амжилттай боллоо."),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.send),
              label: const Text("Шилжүүлэг хийх"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF178582),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF3F4F6), // Фоны өнгө
    );
  }
}
