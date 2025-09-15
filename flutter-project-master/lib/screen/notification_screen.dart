import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              decoration: BoxDecoration(
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFFD700).withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Activity Feed',
                        style: TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF1C1C1E),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFFFFD700),
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.filter_list, color: Color(0xFFFFD700)),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFFFD700),
                    ),
                    labelColor: Colors.black,
                    unselectedLabelColor: Color(0xFFFFD700),
                    tabs: const [
                      Tab(text: 'All'),
                      Tab(text: 'Goals'),
                      Tab(text: 'Achievements'),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // All Notifications Tab
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _HighlightCard(
                        title: "Milestone Achieved! 🏆",
                        subtitle: "You've reached 1 million total steps!",
                        value: "1,000,000",
                        unit: "steps",
                        gradient: [Color(0xFFFFD700), Color(0xFFDAA520)],
                      ),
                      const SizedBox(height: 20),
                      _NotificationGroup(
                        title: "Today",
                        notifications: const [
                          _NotificationTile(
                            icon: Icons.directions_walk,
                            title: "Daily Goal Progress",
                            subtitle: "85% of your daily goal completed",
                            time: "Just now",
                            progress: 0.85,
                          ),
                          _NotificationTile(
                            icon: Icons.local_fire_department,
                            title: "Calories Burned",
                            subtitle: "You've burned 350 calories today",
                            time: "2h ago",
                            showBadge: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _NotificationGroup(
                        title: "Yesterday",
                        notifications: const [
                          _NotificationTile(
                            icon: Icons.emoji_events,
                            title: "New Achievement",
                            subtitle: "Early Bird: Complete 1000 steps before 8 AM",
                            time: "1d ago",
                            isAchievement: true,
                          ),
                          _NotificationTile(
                            icon: Icons.groups,
                            title: "Community Challenge",
                            subtitle: "You're in top 10% this week!",
                            time: "1d ago",
                            showBadge: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Goals Tab
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: const [
                      _GoalCard(
                        icon: Icons.directions_walk,
                        title: "Daily Steps",
                        current: 8547,
                        target: 10000,
                        unit: "steps",
                      ),
                      SizedBox(height: 16),
                      _GoalCard(
                        icon: Icons.straighten,
                        title: "Distance",
                        current: 5.2,
                        target: 6.0,
                        unit: "km",
                      ),
                      SizedBox(height: 16),
                      _GoalCard(
                        icon: Icons.local_fire_department,
                        title: "Calories",
                        current: 350,
                        target: 500,
                        unit: "kcal",
                      ),
                    ],
                  ),
                  // Achievements Tab
                  GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return _AchievementCard(
                        icon: [
                          Icons.emoji_events,
                          Icons.flash_on,
                          Icons.favorite,
                          Icons.timer,
                          Icons.landscape,
                          Icons.star,
                        ][index],
                        title: [
                          "Step Master",
                          "Speed Demon",
                          "Health Guru",
                          "Early Bird",
                          "Explorer",
                          "All-Star",
                        ][index],
                        progress: [1.0, 0.8, 0.6, 1.0, 0.4, 0.9][index],
                        isUnlocked: [true, true, false, true, false, true][index],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final bool isAchievement;
  final double? progress;
  final bool showBadge;

  const _NotificationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    this.isAchievement = false,
    this.progress,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isAchievement ? const Color(0xFFFFD700) : const Color(0xFFFFD700).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isAchievement ? const Color(0xFFFFD700) : const Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isAchievement ? Colors.black : const Color(0xFFFFD700),
                size: 24,
              ),
            ),
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showBadge)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFFD700),
                  ),
                ),
              ],
            ),
          ),
          if (progress != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[800],
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
              ),
            ),
        ],
      ),
    );
  }
}

class _NotificationGroup extends StatelessWidget {
  final String title;
  final List<Widget> notifications;

  const _NotificationGroup({
    required this.title,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...notifications,
      ],
    );
  }
}

class _HighlightCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final String unit;
  final List<Color> gradient;

  const _HighlightCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.unit,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  unit,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
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

class _GoalCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final num current;
  final num target;
  final String unit;

  const _GoalCard({
    required this.icon,
    required this.title,
    required this.current,
    required this.target,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final progress = current / target;
    
    return Card(
      color: const Color(0xFF1C1C1E),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: const Color(0xFFFFD700),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress.clamp(0, 1).toDouble(),
              backgroundColor: Colors.grey[800],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$current $unit',
                  style: const TextStyle(
                    color: Color(0xFFFFD700),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Target: $target $unit',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
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

class _AchievementCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final double progress;
  final bool isUnlocked;

  const _AchievementCard({
    required this.icon,
    required this.title,
    required this.progress,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1C1C1E),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isUnlocked ? const Color(0xFFFFD700) : Colors.grey[800],
              ),
              child: Icon(
                icon,
                size: 32,
                color: isUnlocked ? Colors.black : Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: isUnlocked ? Colors.white : Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            if (!isUnlocked) ...[
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[800],
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
              ),
              const SizedBox(height: 8),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}