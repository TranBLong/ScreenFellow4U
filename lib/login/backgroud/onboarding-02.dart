import 'package:flutter/material.dart';
import '../used/signup.dart';

class OnboardingScreen02 extends StatelessWidget {
  const OnboardingScreen02({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: size.height * 0.15,
            left: size.width * 0,
            child: Image.asset(
              'assets/images/login/backgroud/onboarding-02/Vector 8.png',
              width: size.width * 1,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: size.height * 0.125,
            left: size.width * 0.05,
            child: Image.asset(
              'assets/images/login/backgroud/onboarding-02/Group 98.png',
            ),
          ),
          Positioned(
            top: size.height * 0.12,
            left: size.width * 0.42,
            child: Image.asset(
              'assets/images/login/backgroud/onboarding-02/Group 99.png',
            ),
          ),
          Positioned(
            top: size.height * 0.25,
            left: size.width * 0.35,
            child: Image.asset(
              'assets/images/login/backgroud/onboarding-02/Group 101.png',
            ),
          ),
          Positioned(
            top: size.height * 0.08,
            right: size.width * 0.25,
            child: Image.asset(
              'assets/images/login/backgroud/onboarding-02/Vector 5.png',
            ),
          ),
          Positioned(
            bottom: size.height * 0.3,
            left: 20,
            right: 20,
            child: Text(
              'Many tours around the world',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            bottom: size.height * 0.2,
            left: 20,
            right: 20,
            child: Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Positioned(
            bottom: size.height * 0.05,
            right: size.width * 0.1,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUp()),
                );
              },
              child: const Text('Skip', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
