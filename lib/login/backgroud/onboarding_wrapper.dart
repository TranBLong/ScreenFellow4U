import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'onboarding-01.dart';
import 'onboarding-02.dart';
import 'onboarding-03.dart';

class OnboardingWrapper extends StatefulWidget {
  const OnboardingWrapper({super.key});

  @override
  State<OnboardingWrapper> createState() => _OnboardingWrapperState();
}

class _OnboardingWrapperState extends State<OnboardingWrapper> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: const [
              OnboardingScreen01(),
              OnboardingScreen02(),
              OnboardingScreen03(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.75),
            child: SmoothPageIndicator(
              controller: _controller,
              count: 3,
              effect: const ExpandingDotsEffect(
                activeDotColor: Color(0xFF00CEA6),
                dotColor: Colors.grey,
                dotHeight: 10,
                dotWidth: 10,
                spacing: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
