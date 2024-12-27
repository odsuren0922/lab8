import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../dto/card_info.dart';
import '../dto/transaction.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Sign up a user with email and password, then store additional user data in Firestore.
  static Future<void> signUpUser({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      // Create user in Firebase Auth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'fullName': fullName,
        'email': email,
        'balance': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  /// Login a user with email and password.
  static Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  /// Logout the current user.
  static Future<void> logoutUser() async {
    await _auth.signOut();
  }

  /// Get the current user's profile.
  static Future<Map<String, dynamic>?> getUserProfile() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return null;

    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(userId).get();
      return snapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  static Future<double> getUserBalance() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return 0.0;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    // Ensure the balance is returned as a double
    var balance = doc.data()?['balance'] ?? 0;
    if (balance is int) {
      balance = balance.toDouble(); // Convert if it's an int
    }

    return balance;
  }

  // Method to update the user balance
  static Future<void> updateUserBalance(double newBalance) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'balance': newBalance,
    });
  }

  static Future<void> addIncomeTransaction(
      double amount, String description) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .add({
      'amount': amount,
      'description': description,
      'date': FieldValue.serverTimestamp(),
      'createdAt': DateTime.now(),
      'category': 'Income',
      'type': 'income', // Can be either 'income' or 'outcome'
    });
  }

  static Future<void> addMoney(double amount) async {
    final currentBalance = await getUserBalance();
    final newBalance = currentBalance + amount;

    await updateUserBalance(newBalance);
  }

  // Save a new card to Firestore
  static Future<void> saveCardInfo(CardInfo cardInfo) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cards')
          .add({
        ...cardInfo.toMap(),
        'timestamp': FieldValue.serverTimestamp(), // Add timestamp for sorting
      });
    }
  }

  // Fetch all cards for the current user
  static Future<List<CardInfo>> fetchAllCards() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cards')
          .orderBy('timestamp', descending: true) // Sort by latest
          .get();

      return snapshot.docs.map((doc) {
        // final data = doc.data();
        return CardInfo.fromFirestore(doc);
      }).toList();
    }
    return [];
  }

  // Fetch the latest card for the current user
  static Future<CardInfo?> fetchLatestCard() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cards')
          .orderBy('timestamp', descending: true)
          .limit(1) // Fetch only the latest card
          .get();

      if (snapshot.docs.isNotEmpty) {
        return CardInfo.fromFirestore(snapshot.docs.first);
      }
    }
    return null;
  }

  // Update an existing card in Firestore
  static Future<void> updateCardInfo(CardInfo cardInfo, String cardId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cards')
          .doc(cardId)
          .update(cardInfo.toMap());
    }
  }

  static Future<List<Transactions>> getTransactions() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .orderBy('createdAt',
              descending: true) 
          .get();

      return snapshot.docs
          .map((doc) => Transactions.fromMap(
              doc.data() as Map<String, dynamic>, doc.id)) // Pass doc.id here
          .toList();
    }
    return [];
  }

  static Future<List<Transactions>> getPendingTransactions() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('pending_transactions')
          .get();

      // If snapshot is empty, return an empty list
      if (snapshot.docs.isEmpty) {
        return [];
      }

      // Debug: Print each document's data to understand the structure
      snapshot.docs.forEach((doc) {
        print('Transaction Data: ${doc.data()}');
      });

      // Ensure that all documents are mapped correctly to Transactions
      return snapshot.docs.map((doc) {
        // Debug: Check data before mapping
        print('Mapping Document ID: ${doc.id}, Data: ${doc.data()}');
        return Transactions.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    }
    return [];
  }

  static Future<void> confirmTransaction(
      String transactionId, double totalAmount) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      throw Exception("User not authenticated");
    }

    try {
      // Get the pending transaction document
      final pendingTransactionRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('pending_transactions')
          .doc(transactionId);

      final pendingTransactionSnapshot = await pendingTransactionRef.get();
      if (!pendingTransactionSnapshot.exists) {
        throw Exception("Transaction not found");
      }

      final pendingTransactionData = pendingTransactionSnapshot.data()!;

      // Modify the transaction data (e.g., add 'type' and adjust fields as needed)
      final updatedTransactionData = {
        ...pendingTransactionData,
        'type': 'outcome',
        'amount': totalAmount,
        'createdAt': DateTime.now(),
        'confirmedAt':
            FieldValue.serverTimestamp(), // Add confirmation timestamp
      };

      // Add the updated transaction to the transactions collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .add(updatedTransactionData);

      // Delete the document from pending transactions after moving
      await pendingTransactionRef.delete();
    } catch (e) {
      throw Exception('Failed to confirm transaction: $e');
    }
  }

  static Future<void> addExpense({
    required String category,
    required double amount,
    required String description,
    required DateTime date,
  }) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      throw Exception("User not authenticated");
    }

    try {
      // Add expense to the pending transactions collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('pending_transactions')
          .add({
        'category': category,
        'amount': amount,
        'description': description,
        'date': date,
        'createdAt': DateTime.now(),
        'type': 'pending',
      });
    } catch (e) {
      throw Exception('Failed to add expense: $e');
    }
  }

  static Future<Map<String, dynamic>> getProfile() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      throw Exception("User not authenticated");
    }

    try {
      // Fetch the user profile from Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (snapshot.exists) {
        // Return the user data as a map
        return snapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception("Profile not found");
      }
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }
}
