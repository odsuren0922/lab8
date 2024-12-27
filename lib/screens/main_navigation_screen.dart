import 'package:flutter/material.dart';
import './home_screen.dart';
import './chart_screen.dart';
import 'wallet_screen.dart';
import './profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ChartScreen(),
    const WalletScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? null // No AppBar for the Home screen
          : AppBar(
              title: Text(
                _getScreenTitle(),
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.teal,
              iconTheme: const IconThemeData(color: Colors.white),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0; // Navigate back to Home
                  });
                },
              ),
            ),
      body: _screens[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addexpensescreen');
              },
              backgroundColor: const Color(0xFF3E7C78),
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Chart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  String _getScreenTitle() {
    switch (_selectedIndex) {
      case 1:
        return 'Chart';
      case 2:
        return 'Wallet';
      case 3:
        return 'Profile';
      case 4:
        return 'Connect Wallet';
      case 5:
        return 'Add Expense';
      default:
        return '';
    }
  }
}
