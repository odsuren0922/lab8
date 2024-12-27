import 'package:flutter/material.dart';
import 'package:project_1/screens/transfer_screen.dart';
import 'screens/add_expense.dart';
import 'screens/connect_wallet.dart';
import './screens/splash_screen.dart';
import './screens/onboarding_screen.dart';
import './screens/login_screen.dart';
import './screens/signup_screen.dart';
import './screens/home_screen.dart';
import 'screens/wallet_screen.dart';
import './screens/chart_screen.dart';
import './screens/profile_screen.dart';
import './screens/main_navigation_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp()); // Your app's root widget
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/mainnavigation': (context) => const MainNavigationScreen(),
        '/homescreen': (context) => const HomeScreen(),
        '/walletscreen': (context) => const WalletScreen(),
        '/chartscreen': (context) => const ChartScreen(),
        '/profilescreen': (context) => const ProfileScreen(),
        '/addexpensescreen': (context) => const ExpenseScreen(),
        '/ConnectWalletScreen': (context) => const ConnectWallet(),
        '/transferScreen' : (context) => const TransferScreen(),
      },
    );
  }
}
