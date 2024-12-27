import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  Future<void> loginUser(String email, String password) async {
    try {
      setState(() {
        _isLoading = true;
      });

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("User logged in: ${userCredential.user?.email}");
      Navigator.pushReplacementNamed(context, '/mainnavigation');
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.code} - ${e.message}");
      _showError('Login failed: ${e.message}');
    } catch (e) {
      print("General Error: $e");
      _showError('Login failed: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
              'assets/images/home_back.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 100,
            left: 50,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Тавтай морилно уу!',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: 250,
            left: 70,
            child: Image.asset(
              "assets/images/login.png",
              height: 170,
              fit: BoxFit.fitWidth,
            ),
          ),
          // Login Form
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 32, bottom: 60, right: 32, top: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Email TextField
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Имэйлээ оруулна уу?',
                        labelStyle: TextStyle(color: Colors.blueGrey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            borderSide: BorderSide.none),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Имэйлээ оруулна уу'; // Email required
                        }
                        if (!value.contains('@')) {
                          return 'Буруу имэйл'; // Invalid email
                        }
                        return null;
                      },
                      onSaved: (value) => _email = value!,
                    ),
                    const SizedBox(height: 15),

                    // Password TextField
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Нууц үгээ оруулаарай',
                        labelStyle: TextStyle(color: Colors.blueGrey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            borderSide: BorderSide.none),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Нууц үгээ оруулна уу'; // Password required
                        }
                        return null;
                      },
                      onSaved: (value) => _password = value!,
                    ),
                    const SizedBox(height: 20),

                    // Login Button
                    _isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3E7C78),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  loginUser(_email, _password);
                                }
                              },
                              child: const Text(
                                'НЭВТРЭХ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 15),

                    // Sign Up Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'Бүртгүүлэх',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 16),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: const Text(
                            'Бүртгүүлэх',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
