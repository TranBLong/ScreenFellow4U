import 'package:flutter/material.dart';
import '../used/signin.dart';

class OnboardingScreen01 extends StatelessWidget {
  const OnboardingScreen01({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: size.height * 0.085,
            left: size.width * 0.1,
            child: Image.asset(
              'assets/images/login/backgroud/onboarding-01/Vector 7.png',
              width: size.width * 0.98,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: size.height * 0.25,
            left: size.width * 0.5,
            child: Image.asset(
              'assets/images/login/backgroud/onboarding-01/Group 107.png',
            ),
          ),
          Positioned(
            top: size.height * 0.25,
            right: size.width * 0.5,
            child: Image.asset(
              'assets/images/login/backgroud/onboarding-01/Group 108.png',
            ),
          ),
          Positioned(
            top: size.height * 0.15,
            left: size.width * 0.2,
            child: Image.asset(
              'assets/images/login/backgroud/onboarding-01/Vector 5.png',
            ),
          ),
          Positioned(
            bottom: size.height * 0.28,
            left: 20,
            right: 20,
            child: Text(
              'Find a local guide easily ',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            bottom: size.height * 0.18,
            left: 20,
            right: 20,
            child: Text(
              'With Fellow4U, you can find a local guide for you trip easily and explore as the way you want.',
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
                  MaterialPageRoute(builder: (context) => SignIn()),
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
