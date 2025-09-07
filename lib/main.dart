import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screen/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  // Clear the onboarding flag when the app starts fresh
  await prefs.remove('ON_BOARDING');
  
  final showOnboarding = prefs.getBool('ON_BOARDING') ?? true;

  runApp(MyApp(showOnboarding: showOnboarding));
}

class MyApp extends StatelessWidget {
  final bool showOnboarding;
  
  const MyApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Galleria_APP',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFFFD700),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const OnboardingScreen(),
    );
  }
}