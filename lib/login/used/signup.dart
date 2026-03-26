import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import "signin.dart";
import '../explore/explore.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// Traveler - Guide
                        Row(
                          children: [
                            Radio<String>(
                              value: "Traveler",
                              // ignore: deprecated_member_use
                              groupValue: selectedRole,
                              activeColor: const Color(0xFF00CEA6),
                              // ignore: deprecated_member_use
                              onChanged: (value) {
                                setState(() {
                                  selectedRole = value!;
                                });
                              },
                            ),
                            const Text("Traveler"),

                            const SizedBox(width: 20),

                            Radio<String>(
                              value: "Guide",
                              // ignore: deprecated_member_use
                              groupValue: selectedRole,
                              activeColor: const Color(0xFF00CEA6),
                              // ignore: deprecated_member_use
                              onChanged: (value) {
                                setState(() {
                                  selectedRole = value!;
                                });
                              },
                            ),
                            const Text("Guide"),
                          ],
                        ),

                        const SizedBox(height: 20),

                        /// First - Last Name
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text("First Name"),
                                  TextField(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text("Last Name"),
                                  TextField(),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        const Text("Country"),
                        const TextField(),

                        const SizedBox(height: 20),

                        const Text("Email"),
                        const TextField(),

                        const SizedBox(height: 20),

                        const Text("Password"),
                        const TextField(),
                        const Text(
                          "Password has more than 6 letters",
                          style: TextStyle(),
                        ),

                        const SizedBox(height: 30),

                        const Text("Confirm Password"),
                        const TextField(),

                        const SizedBox(height: 20),

                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              children: [
                                const TextSpan(
                                  text: "By Signing Up, you agree to our ",
                                ),
                                TextSpan(
                                  text: "Terms & Conditions",
                                  style: const TextStyle(
                                    color: Color(0xFF00CEA6), // màu xanh
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00CEA6),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Explore(),
                                ),
                              );
                            },
                            child: const Text("SIGN UP"),
                          ),
                        ),

                        const SizedBox(height: 30),

                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              children: [
                                const TextSpan(
                                  text: "Already have an account? ",
                                ),
                                TextSpan(
                                  text: "Sign In",
                                  style: const TextStyle(
                                    color: Color(0xFF00CEA6), // màu xanh
                                    fontWeight: FontWeight.w500,
                                  ),

                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const SignIn(),
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
