import 'package:flutter/material.dart';
import '../firebase/firebase_service.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  bool _isSaving = false;
  String _selectedCategory = 'YouTube'; // Default selection
  DateTime _selectedDate = DateTime.now();

  Future<void> _saveExpense() async {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final description = _descriptionController.text.trim();
    final date = _selectedDate;

    if (amount <= 0 || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid details')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await FirebaseService.addExpense(
        category: _selectedCategory,
        amount: amount,
        description: description,
        date: date,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense saved successfully')),
      );

      // Clear inputs after saving
      _amountController.clear();
      _descriptionController.clear();
      _dateController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save expense: $e')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text =
            "${picked.toLocal()}".split(' ')[0]; // Display date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        backgroundColor: Colors.transparent, // Make the AppBar transparent
        elevation: 0, // Remove shadow (elevation)
        iconTheme: const IconThemeData(color: Colors.white), // Icon color
        titleTextStyle:
            const TextStyle(color: Colors.white), // Title text color
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/other_back.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Image for background (not covering AppBar this time)
          Positioned(
            top: 0,
            left: -10,
            right: 0,
            child: Image.asset(
              'assets/images/other_back.png',
              fit: BoxFit.cover,
              height: 150,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 170.0), // Adjust padding
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Enter Expense Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Dropdown for Category
                        DropdownButton<String>(
                          value: _selectedCategory,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCategory = newValue!;
                            });
                          },
                          items: <String>['YouTube', 'Spotify', 'Others']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Icon(
                                    value == 'YouTube'
                                        ? Icons.video_library
                                        : value == 'Spotify'
                                            ? Icons.music_note
                                            : Icons.more_horiz,
                                    color: Colors.teal,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(value),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        // Amount Field
                        TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Description Field
                        TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Date Picker Field
                        TextField(
                          controller: _dateController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Date',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: () => _selectDate(context),
                        ),
                        const SizedBox(height: 16),
                        // Save Button
                        ElevatedButton(
                          onPressed: _isSaving ? null : _saveExpense,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 24.0),
                          ),
                          child: _isSaving
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Save Expense',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}
