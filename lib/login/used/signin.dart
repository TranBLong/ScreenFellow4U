import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'signup.dart';
import 'forgotpassword.dart';
import '../explore/explore.dart';
import '../../api_service.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String selectedRole = "Traveler";
  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _handleSignIn() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please enter email and password"),
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

    final result = await ApiService.loginUser(
      email: emailController.text,
      password: passwordController.text,
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
    emailController.dispose();
    passwordController.dispose();
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
                          "Sign In",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Text(
                          "Welcome back, My boy",
                          style: TextStyle(
                            fontSize: 22,
                            color: Color.fromARGB(255, 0, 206, 166),
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text("Email"),
                        TextField(controller: emailController),

                        const SizedBox(height: 20),

                        const Text("Password"),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Forgotpassword(),
                              ),
                            );
                          },
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 206, 166),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                0,
                                238,
                                190,
                              ),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: isLoading ? null : _handleSignIn,
                            child: isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text("SIGN IN"),
                          ),
                        ),

                        const SizedBox(height: 60),
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              children: [
                                TextSpan(text: "or sign in with"),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/login/used/signin/Group 9.png',
                                width: 40,
                              ),
                              const SizedBox(width: 20),
                              Image.asset(
                                'assets/images/login/used/signin/Group 8.png',
                                width: 40,
                              ),
                              const SizedBox(width: 20),
                              Image.asset(
                                'assets/images/login/used/signin/Group 10.png',
                                width: 40,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 60),

                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              children: [
                                const TextSpan(text: "Don’t have an account? "),
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
