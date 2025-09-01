import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:galleria_app/screen/achievements_screen.dart';
import 'package:galleria_app/screen/profile_screen.dart';
import 'package:galleria_app/screen/notification_screen.dart';
import 'package:galleria_app/screen/route_map_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _pageIndex = 0;

  // Activity states
  bool isWalking = false;
  bool isRunning = false;
  bool hasGoal = true;
  int steps = 8547;
  double distance = 5.2;
  int dailyGoal = 10000;
  int calories = 419;
  int duration = 42;

  String _getMotivationalMessage() {
    final progress = steps / dailyGoal;
    if (progress >= 1.0) return "Amazing! You've hit your goal! 🎉";
    if (progress >= 0.8) return "Almost there! Keep going! 💪";
    if (progress >= 0.5) return "Halfway there! You're doing great! 🌟";
    if (progress >= 0.3) return "Good progress! Keep moving! 🚶";
    return "Let's start moving! Every step counts! 🎯";
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildProgressRing() {
    final progress = steps / dailyGoal;
    
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow container
        Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Color(0xFFFFD700).withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
        // Progress indicator
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: progress),
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) => SizedBox(
            width: 220,
            height: 220,
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: 15,
              backgroundColor: Colors.grey[800],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
            ),
          ),
        ),
        // Center content
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Today's Progress",
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              NumberFormat("#,###").format(steps),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
              ),
            ),
            Text(
              "of ${NumberFormat("#,###").format(dailyGoal)} steps",
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        // Achievement check
        if (progress >= 1.0)
          Positioned(
            top: 40,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFFFFD700),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, size: 16, color: Colors.black),
                  SizedBox(width: 4),
                  Text(
                    "Goal Achieved!",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActivityModeCard({
    required bool isActive,
    required String title,
    required IconData icon,
    required Color color,
    required String description,
    required Function(bool) onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? color : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Switch(
                value: isActive,
                onChanged: onToggle,
                activeColor: color,
                activeTrackColor: color.withOpacity(0.2),
              ),
            ],
          ),
          if (isActive) ...[
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHomePage() {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          // Top Bar with Profile
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(0xFFFFD700),
                          width: 2,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/images/profile_one.jpg'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Pongphathawee B.",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          DateFormat('EEEE, MMMM d').format(DateTime.now()),
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined, color: Color(0xFFFFD700)),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress Section
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildProgressRing(),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            _getMotivationalMessage(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFFFD700),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Stats Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF1C1C1E),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 16),
                          child: Text(
                            "Today's Activity",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // Stats Cards
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                icon: Icons.local_fire_department,
                                value: calories.toString(),
                                unit: "kcal",
                                label: "Calories Burned",
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _StatCard(
                                icon: Icons.straighten,
                                value: distance.toString(),
                                unit: "km",
                                label: "Distance Covered",
                                color: Color(0xFFFFD700),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _StatCard(
                                icon: Icons.timer,
                                value: duration.toString(),
                                unit: "min",
                                label: "Active Time",
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Activity Modes
                        const Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 16),
                          child: Text(
                            "Track Your Movement",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        _buildActivityModeCard(
                          isActive: isWalking,
                          title: "Walking",
                          icon: Icons.directions_walk,
                          color: Color(0xFF4CAF50),
                          description: "Track your daily steps and casual walks",
                          onToggle: (v) => setState(() => isWalking = v),
                        ),
                        const SizedBox(height: 12),
                        _buildActivityModeCard(
                          isActive: isRunning,
                          title: "Running",
                          icon: Icons.directions_run,
                          color: Color(0xFFFF7043),
                          description: "Track your running sessions and pace",
                          onToggle: (v) => setState(() => isRunning = v),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: IndexedStack(
          index: _pageIndex,
          children: [
            _buildHomePage(),
            AchievementsScreen(),
            RouteMapScreen(),
            NotificationScreen(),
            ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: RepaintBoundary(
        child: Theme(
          data: Theme.of(context).copyWith(
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          child: CurvedNavigationBar(
            backgroundColor: Colors.transparent,
            color: const Color(0xFF1C1C1E),
            animationDuration: const Duration(milliseconds: 200),
            animationCurve: Curves.easeInOut,
            index: _pageIndex,
            height: 60,
            items: const [
              Icon(Icons.home, size: 30),
              Icon(Icons.emoji_events, size: 30),
              Icon(Icons.map, size: 30),
              Icon(Icons.notifications, size: 30),
              Icon(Icons.person, size: 30),
            ],
            onTap: (index) => setState(() => _pageIndex = index),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String unit;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.unit,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            unit,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
