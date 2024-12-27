import 'package:flutter/material.dart';
import '../firebase/firebase_service.dart'; // Firebase service to fetch saved card data
import '../dto/card_info.dart'; // Model for CardInfo

class ConnectWallet extends StatefulWidget {
  const ConnectWallet({super.key});

  @override
  _ConnectWalletState createState() => _ConnectWalletState();
}

class _ConnectWalletState extends State<ConnectWallet>
    with SingleTickerProviderStateMixin {
      
  int _selectedAccountIndex = 0; // Сонгогдсон индексийг хадгалах
  late TabController _tabController;
  CardInfo? _savedCard; // Variable to store fetched card data
  bool _isLoading = true; // Loading indicator
  bool _amIsLoading = false;

  // TextEditingControllers for the form fields
  final _cardHolderNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cvcController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _zipController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchSavedCard();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cardHolderNameController.dispose();
    _cardNumberController.dispose();
    _cvcController.dispose();
    _expiryDateController.dispose();
    _zipController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // Function to save card info to Firebase
  Future<void> _saveCardInfo() async {
    
    final amount = double.tryParse(_amountController.text);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid amount")),
      );
      return;
    }

    setState(() {
      _amIsLoading = true;
    });

    final cardInfo = CardInfo(
      cardNumber: _cardNumberController.text,
      cardHolderName: _cardHolderNameController.text,
      expirationDate: _expiryDateController.text,
      cvv: _cvcController.text,
      zipCode: _zipController.text,
    );

    if (_savedCard != null) {
      await FirebaseService.updateCardInfo(cardInfo, _savedCard!.id);
    } else {
      await FirebaseService.saveCardInfo(cardInfo);
    }
  try {
      await FirebaseService.addIncomeTransaction(
          amount, 'Added money to wallet');
      await FirebaseService.addMoney(amount);

      ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Card saved and money added successfully")));
      Navigator.pop(context);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding money: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchSavedCard() async {
    try {
      final cards = await FirebaseService.fetchAllCards();
      if (cards.isNotEmpty) {
        final latestCard = cards.last;
        setState(() {
          _savedCard = latestCard;
          _isLoading = false;
          _cardHolderNameController.text = latestCard.cardHolderName;
          _cardNumberController.text = latestCard.cardNumber;
          _cvcController.text = latestCard.cvv;
          _expiryDateController.text = latestCard.expirationDate;
          _zipController.text = latestCard.zipCode ?? "";
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error fetching card: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Түрийвч цэнэглэх",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Картууд"),
            Tab(text: "Аккаунт"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_savedCard != null)
                  _buildSavedCardUI()
                else
                  _buildPlaceholderCard(),
                const SizedBox(height: 16),
                const Text("Картын мэдээлэл нэмэх",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildTextField(_cardHolderNameController, "КАРТ ДЭЭРХ НЭР"),
                _buildTextField(_cardNumberController, "КАРТЫН ДУГААР",
                    isNumeric: true),
                _buildTextField(_cvcController, "CVC", isNumeric: true),
                _buildRowOfTextFields(),
                const SizedBox(height: 16),
                _buildTextField(_amountController, "ЦЭНЭГЛЭХ ДҮН",
                    isNumeric: true),
                const SizedBox(width: 12),
                _buildSaveButton("КАРТЫГ ХАДГАЛАХ", _saveCardInfo),
                const SizedBox(width: 12),
              ]
            ),
          ),
          _buildAccountTab(),
        ],
      ),
    );
  }

  // Widget for a reusable text field
  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumeric = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
    );
  }

  // Widget to create a row of expiry date and zip text fields
  Widget _buildRowOfTextFields() {
    return Row(
      children: [
        Expanded(
            child: _buildTextField(
                _expiryDateController, "ДУУСАХ ХУГАЦАА YYYY/MM")),
        const SizedBox(width: 16),
        Expanded(
            child: _buildTextField(_zipController, "ZIP", isNumeric: true)),
      ],
    );
  }

  // Save button with customizable text and color
  Widget _buildSaveButton(String text, VoidCallback onPressed,
      {Color backgroundColor = Colors.teal}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      child:
          Text(text, style: const TextStyle(fontSize: 14, color: Colors.white)),
    );
  }

  // Widget to show saved card details
  Widget _buildSavedCardUI() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Colors.teal[100],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Хадгалсан карт:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Нэр: ${_savedCard!.cardHolderName}",
                style: const TextStyle(fontSize: 14)),
            Text(
                "Картын дугаар: **** **** **** ${_savedCard!.cardNumber.substring(_savedCard!.cardNumber.length - 4)}",
                style: const TextStyle(fontSize: 14)),
            Text("Дуусах хугацаа: ${_savedCard!.expirationDate}",
                style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  // Widget to show placeholder if no card is saved
  Widget _buildPlaceholderCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Colors.grey[200],
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Хадгалсан карт байхгүй байна",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54)),
            SizedBox(height: 8),
            Text("Нэр: ---",
                style: TextStyle(fontSize: 14, color: Colors.black38)),
            Text("Картын дугаар: **** **** **** ----",
                style: TextStyle(fontSize: 14, color: Colors.black38)),
            Text("Дуусах хугацаа: ----/----",
                style: TextStyle(fontSize: 14, color: Colors.black38)),
          ],
        ),
      ),
    );
  }

  // Account Tab UI
  Widget _buildAccountTab() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.account_balance, color: Colors.teal),
            title: Text("Bank Link"),
            subtitle: Text("Connect your bank account to deposit & fund"),
            trailing: Icon(Icons.check_circle, color: Colors.green),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.attach_money, color: Colors.teal),
            title: Text("Microdeposits"),
            subtitle: Text("Connect bank in 5-7 days"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment, color: Colors.teal),
            title: Text("Paypal"),
            subtitle: Text("Connect your Paypal account"),
          ),
        ],
      ),
    );
  }
}
