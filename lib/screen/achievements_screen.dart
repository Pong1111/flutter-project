import 'package:flutter/material.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> with SingleTickerProviderStateMixin {
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
      body: Column(
        children: [
          // Yellow background container that extends edge to edge
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFFFD700),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFFFD700).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Top Section with Title
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                    child: Row(
                      children: [
                        Text(
                          'Progress',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Tab Bar
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelColor: Color(0xFFFFD700),
                      unselectedLabelColor: Colors.black,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      tabs: [
                        Tab(text: 'All'),
                        Tab(text: 'Goals'),
                        Tab(text: 'Achievements'),
                      ],
                    ),
                  ),
                  SizedBox(height: 16), // Bottom padding for the yellow container
                ],
              ),
            ),
          ),
          
          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllTab(),
                _buildGoalsTab(),
                _buildAchievementsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildProgressCard(
          title: "Daily Steps",
          value: "8,547",
          total: "10,000",
          progress: 0.85,
          color: Color(0xFF4CAF50),
        ),
        _buildProgressCard(
          title: "Weekly Distance",
          value: "15.7",
          total: "20",
          unit: "km",
          progress: 0.785,
          color: Color(0xFFFFD700),
        ),
        _buildProgressCard(
          title: "Monthly Goals",
          value: "12",
          total: "15",
          progress: 0.8,
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildGoalsTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildGoalCard(
          icon: Icons.directions_walk,
          title: "Daily Steps Goal",
          subtitle: "10,000 steps",
          progress: 0.85,
          color: Color(0xFF4CAF50),
        ),
        _buildGoalCard(
          icon: Icons.local_fire_department,
          title: "Calorie Goal",
          subtitle: "500 kcal",
          progress: 0.6,
          color: Colors.orange,
        ),
        _buildGoalCard(
          icon: Icons.timer,
          title: "Active Minutes",
          subtitle: "30 minutes",
          progress: 0.9,
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildAchievementsTab() {
    return GridView.count(
      padding: EdgeInsets.all(16),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildAchievementCard(
          icon: Icons.emoji_events,
          title: "First Mile",
          isUnlocked: true,
          color: Color(0xFFFFD700),
        ),
        _buildAchievementCard(
          icon: Icons.local_fire_department,
          title: "Calorie Crusher",
          isUnlocked: true,
          color: Colors.orange,
        ),
        _buildAchievementCard(
          icon: Icons.directions_run,
          title: "Speed Demon",
          isUnlocked: false,
          color: Colors.red,
        ),
        _buildAchievementCard(
          icon: Icons.watch_later,
          title: "Early Bird",
          isUnlocked: false,
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildProgressCard({
    required String title,
    required String value,
    required String total,
    String unit = '',
    required double progress,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$value${unit.isNotEmpty ? ' $unit' : ''}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'of $total${unit.isNotEmpty ? ' $unit' : ''}',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required double progress,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard({
    required IconData icon,
    required String title,
    required bool isUnlocked,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked ? color.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isUnlocked ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isUnlocked ? color : Colors.grey,
                    size: 32,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isUnlocked ? Colors.white : Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (isUnlocked)
            Positioned(
              top: 8,
              right: 8,
              child: Icon(
                Icons.check_circle,
                color: color,
                size: 16,
              ),
            ),
        ],
      ),
    );
  }
}
