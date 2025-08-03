import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/auth_provider.dart';
import 'attendance_screen.dart';
import 'homework_screen.dart';
import 'notice_screen.dart';
import 'result_screen.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final profile = auth.value;
    final branchName = profile?.branchName ?? "Branch";

    // Type-safe feature structure
    final features = [
      /*FeatureItem(
        label: 'Assignment',
        icon: Icons.assignment,
        screenBuilder: (_) => const AssignmentScreen(),
      ),*/
      FeatureItem(
        label: 'Attendance',
        icon: Icons.check_circle,
        screenBuilder: (_) => const AttendanceScreen(),
      ),
      /*FeatureItem(
        label: 'Fee Details',
        icon: Icons.attach_money,
        screenBuilder: (_) => const FeeDetailsScreen(),
      ),*/
      FeatureItem(
        label: 'Homework',
        icon: Icons.book,
        screenBuilder: (userName) => HomeworkScreen(userName: userName),
      ),
      FeatureItem(
        label: 'Notice',
        icon: Icons.notifications,
        screenBuilder: (userName) => NoticeScreen(userName: userName),
      ),
      FeatureItem(
        label: 'Result',
        icon: Icons.grade,
        screenBuilder: (userName) => ResultScreen(userName: userName),
      ),
    ];

    String getGreetingMessage() {
      final hour = DateTime.now().hour;

      if (hour >= 5 && hour < 12) {
        return 'Good Morning';
      } else if (hour >= 12 && hour < 17) {
        return 'Good Afternoon';
      } else if (hour >= 17 && hour < 21) {
        return 'Good Evening';
      } else {
        return 'Good Night';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(branchName, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: Colors.yellow,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.teal,
            padding: const EdgeInsets.all(16),
            child: Text(
              getGreetingMessage(),
              style: GoogleFonts.roboto(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 150),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              padding: const EdgeInsets.all(12),
              children: features.map((feature) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade50,
                    foregroundColor: Colors.teal.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    if (profile == null) return;
                    final userName = profile.uniqId;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => feature.screenBuilder(userName),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(feature.icon, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        feature.label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureItem {
  final String label;
  final IconData icon;
  final Widget Function(String userName) screenBuilder;

  FeatureItem({
    required this.label,
    required this.icon,
    required this.screenBuilder,
  });
}
