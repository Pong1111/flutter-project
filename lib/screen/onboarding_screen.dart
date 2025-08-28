import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  void onDone(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ON_BOARDING', false);

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<PageViewModel> pages = [
      PageViewModel(
        title: 'Welcome to Your Fitness Journey',
        body: 'Track your daily steps, set goals, and achieve milestones in your fitness journey.',
        footer: SizedBox(
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
            ),
            child: const Text("Let's go!"),
          ),
        ),
        image: Image.asset('assets/images/profile_one.jpg'),
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
        title: 'Track Your Progress',
        body: 'Monitor your daily activity, view statistics, and celebrate your achievements.',
        footer: SizedBox(
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
            ),
            child: const Text("Continue"),
          ),
        ),
        image: const Icon(
          Icons.track_changes,
          size: 150,
          color: Color(0xFFFFD700),
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
        title: 'Stay Motivated',
        body: 'Get notifications, compete with friends, and unlock achievements as you progress.',
        footer: SizedBox(
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
            ),
            child: const Text("Get Started"),
          ),
        ),
        image: const Icon(
          Icons.emoji_events,
          size: 150,
          color: Color(0xFFFFD700),
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

    return Scaffold(
      backgroundColor: Colors.black,
      body: IntroductionScreen(
        pages: pages,
        dotsDecorator: const DotsDecorator(
          size: Size(10, 10),
          color: Colors.white54,
          activeSize: Size(15, 15),
          activeColor: Color(0xFFFFD700),
          spacing: EdgeInsets.all(5),
        ),
        showDoneButton: true,
        done: const Text(
          'Done',
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.w600,
          ),
        ),
        showSkipButton: true,
        skip: const Text(
          'Skip',
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        showNextButton: true,
        next: const Icon(
          Icons.arrow_forward,
          size: 20,
          color: Color(0xFFFFD700),
        ),
        onDone: () => onDone(context),
        curve: Curves.easeOutCubic,
        animationDuration: 400,
        skipOrBackFlex: 0,
        nextFlex: 0,
        controlsMargin: const EdgeInsets.all(16),
        controlsPadding: const EdgeInsets.all(12),
      ),
    );
  }
}
