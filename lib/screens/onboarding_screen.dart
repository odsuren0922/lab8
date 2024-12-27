import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 0, // Align image to the top of the screen
            left: -10, // Align image to the left of the screen
            right: 0, // Align image to the right of the screen
            child: Image.asset(
              'assets/images/onboard_background.png', // Path to your image
              fit: BoxFit
                  .cover, // Ensures the image covers the top area but maintains aspect ratio
            ),
          ),
          Positioned(
            top: 130,
            left: 0,
            child: Image.asset(
              "assets/images/person.png",
              height: 490,
              fit: BoxFit.fitWidth,
            ),
          ),

          Positioned(
            bottom: 50, // Position the form towards the bottom of the screen
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 32, bottom: 10, right: 32, top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        "Ухаалаг Зарцуулж Илүү Хэмнэе",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3E7C78),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3E7C78),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 100,
                        shadowColor: Colors.black.withOpacity(1),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(100), // Rounded corners
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'ЭХЛЭХ',
                        style: TextStyle(
                          fontSize: 18, // Custom font size for the text
                          fontWeight: FontWeight.bold, // Bold text
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
                        'Хэрэглэгчийн Эрх Бий Юу?',
                        style: TextStyle(color: Colors.blueGrey, fontSize: 12),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text(
                          'Нэвтрэх',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
