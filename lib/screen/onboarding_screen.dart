import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  void onDone(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ON_BOARDING', false);

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUpScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<PageViewModel> pages = [
      PageViewModel(
        title: '🚶‍♂️ Welcome to Your Walking Journey',
        body: 'Start your daily walking routine and track every step towards a healthier lifestyle.',
        footer: Container(
          margin: const EdgeInsets.only(top: 24),
          height: 45,
          width: 150,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD700),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Let's Walk!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        image: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[900],
          ),
          child: const Icon(
            Icons.directions_walk,
            size: 120,
            color: Color(0xFFFFD700),
          ),
        ),
        decoration: PageDecoration(
          titleTextStyle: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyTextStyle: TextStyle(
            fontSize: 16,
            color: Colors.grey[400],
            height: 1.5,
          ),
          imagePadding: const EdgeInsets.only(top: 60, bottom: 30),
          pageColor: Colors.black,
          bodyPadding: const EdgeInsets.symmetric(horizontal: 20),
          titlePadding: const EdgeInsets.only(top: 20, bottom: 10),
          bodyAlignment: Alignment.center,
          imageAlignment: Alignment.center,
        ),
      ),
      PageViewModel(
        title: '📊 Track Every Step',
        body: 'Monitor your daily steps, distance covered, and calories burned with our advanced tracking.',
        footer: Container(
          margin: const EdgeInsets.only(top: 24),
          height: 45,
          width: 150,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD700),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Continue",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        image: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[900],
          ),
          child: const Icon(
            Icons.run_circle,
            size: 120,
            color: Color(0xFFFFD700),
          ),
        ),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyTextStyle: TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
          imagePadding: EdgeInsets.only(top: 40),
          pageColor: Colors.black,
        ),
      ),
      PageViewModel(
        title: '🏆 Achieve Your Goals',
        body: 'Set daily step goals, join walking challenges, and earn achievements with every milestone.',
        footer: Container(
          margin: const EdgeInsets.only(top: 24),
          height: 45,
          width: 150,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD700),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Get Started",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        image: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[900],
          ),
          child: const Icon(
            Icons.trending_up,
            size: 120,
            color: Color(0xFFFFD700),
          ),
        ),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyTextStyle: TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
          imagePadding: EdgeInsets.only(top: 40),
          pageColor: Colors.black,
        ),
      ),
    ];

    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFD700),
          onPrimary: Colors.black,
          surface: Colors.black,
          onSurface: Colors.white,
        ),
      ),
      child: Scaffold(
        body: IntroductionScreen(
          globalBackgroundColor: Colors.black,
          pages: pages,
          dotsDecorator: const DotsDecorator(
            size: Size(10, 10),
            color: Colors.white54,
            activeSize: Size(15, 15),
            activeColor: Color(0xFFFFD700),
            spacing: EdgeInsets.all(5),
          ),
          showDoneButton: true,
          done: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Done',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          showSkipButton: true,
          skip: Text(
            'Skip',
            style: TextStyle(
              color: Colors.grey[400],
              fontWeight: FontWeight.w500,
            ),
          ),
          showNextButton: true,
          next: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFFFD700),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward,
              size: 20,
              color: Colors.black,
            ),
          ),
          onDone: () => onDone(context),
          curve: Curves.easeOutCubic,
          animationDuration: 400,
          skipOrBackFlex: 0,
          nextFlex: 0,
          controlsMargin: const EdgeInsets.all(16),
          controlsPadding: const EdgeInsets.all(12),
          bodyPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        ),
      ),
    );
  }
}
