import 'package:flutter/material.dart';
import '../used/signup.dart';

class OnboardingScreen03 extends StatelessWidget {
  const OnboardingScreen03({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: size.height * 0.08,
            left: size.width * 0,
            child: Image.asset(
              'assets/images/login/backgroud/onboarding-03/Group 177.png',
              width: size.width * 1,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            bottom: size.height * 0.3,
            left: 20,
            right: 20,
            child: Text(
              'Create a trip and get offers',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            bottom: size.height * 0.2,
            left: 20,
            right: 20,
            child: Text(
              'Fellow4U helps you save time and get offers from hundred local guides that suit your trip.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00CEA6),
                    elevation: 5,
                    shadowColor: const Color(0xFF00CEA6).withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "GET STARTED",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
