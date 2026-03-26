import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'signup.dart';

class Sendemail extends StatefulWidget {
  const Sendemail({super.key});

  @override
  State<Sendemail> createState() => _SendemailState();
}

class _SendemailState extends State<Sendemail> {
  String selectedRole = "Traveler";
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF4CE8C5),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              top: size.height * 0.025,
              left: size.width * -0.1,
              child: Image.asset(
                'assets/images/login/used/signup/Group 3.png',
                width: size.width * 0.5,
              ),
            ),
            Positioned(
              top: size.height * 0.15,
              right: size.width * 0.22,
              child: Image.asset(
                'assets/images/login/used/signup/Vector 1.png',
                width: size.width * 0.5,
              ),
            ),
            Positioned(
              top: size.height * 0.12,
              right: size.width * 0.15,
              child: Image.asset(
                'assets/images/login/used/signup/Vector 6.png',
                width: size.width * 0.5,
              ),
            ),
            Positioned(
              top: size.height * 0.025,
              right: size.width * -0.1,
              child: Image.asset(
                'assets/images/login/used/signup/Vector.png',
                width: size.width * 0.5,
              ),
            ),

            /// Main Content
            Column(
              children: [
                SizedBox(height: size.height * 0.15),
                ClipPath(
                  clipper: WhiteTopCurveClipper(),
                  child: Container(
                    width: size.width,
                    constraints: BoxConstraints(
                      minHeight: size.height - (size.height * 0.15),
                    ),
                    padding: const EdgeInsets.all(20),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 80),

                        const Text(
                          "Check Email",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Please check your email for the instructions \n on how to reset your password.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 112, 112, 112),
                          ),
                        ),

                        const SizedBox(height: 40),

                        Positioned(
                          top: size.height * 0.025,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Image.asset(
                              'assets/images/login/used/envelope.png',
                            ),
                          ),
                        ),

                        const SizedBox(height: 80),

                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              children: [
                                const TextSpan(text: "Back to "),
                                TextSpan(
                                  text: "Sign Up",
                                  style: const TextStyle(
                                    color: Color(0xFF00CEA6), // màu xanh
                                    fontWeight: FontWeight.w500,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const SignUp(),
                                        ),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WhiteTopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, 80);

    path.quadraticBezierTo(
      size.width / 2,
      0, // điểm điều khiển (càng nhỏ càng cong nhiều)
      size.width,
      80,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
