import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import "signin.dart";
import '../explore/explore.dart';
import '../../api_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String selectedRole = "Traveler";
  bool isLoading = false;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> _handleSignUp() async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please fill in all required fields"),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 100,
            left: 20,
            right: 20,
          ),
        ),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Passwords do not match"),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 100,
            left: 20,
            right: 20,
          ),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    final result = await ApiService.registerUser(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      password: passwordController.text,
      role: selectedRole,
      country: countryController.text,
    );

    setState(() => isLoading = false);

    if (result['status'] == 'success') {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 100,
            left: 20,
            right: 20,
          ),
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Explore()),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 100,
            left: 20,
            right: 20,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    countryController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

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
                              groupValue: selectedRole,
                              activeColor: const Color(0xFF00CEA6),
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
                              groupValue: selectedRole,
                              activeColor: const Color(0xFF00CEA6),
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
                                children: [
                                  const Text("First Name"),
                                  TextField(controller: firstNameController),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Last Name"),
                                  TextField(controller: lastNameController),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        const Text("Country"),
                        TextField(controller: countryController),

                        const SizedBox(height: 20),

                        const Text("Email"),
                        TextField(controller: emailController),

                        const SizedBox(height: 20),

                        const Text("Password"),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                        ),
                        const Text(
                          "Password has more than 6 letters",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),

                        const SizedBox(height: 30),

                        const Text("Confirm Password"),
                        TextField(
                          controller: confirmPasswordController,
                          obscureText: true,
                        ),

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
                            onPressed: isLoading ? null : _handleSignUp,
                            child: isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text("SIGN UP"),
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
