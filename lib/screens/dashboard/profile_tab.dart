import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authProvider);

    return Scaffold(
      body: state.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No user profile found.'));
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 220.0,
                backgroundColor: Colors.teal,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      color: Colors.teal,
                      /*gradient: LinearGradient(
                        colors: [Colors.teal, Colors.green],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),*/
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            'http://203.190.12.69/ems/bni/app/${profile.imageUrl}',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          profile.fullName,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'ID: ${profile.uniqId}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            'Student Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const Divider(),
                          ProfileRow(
                            icon: Icons.phone,
                            label: 'Mobile',
                            value: profile.contactMobile,
                          ),
                          ProfileRow(
                            icon: Icons.class_,
                            label: 'Class',
                            value: profile.className,
                          ),
                          ProfileRow(
                            icon: Icons.group,
                            label: 'Section',
                            value: profile.sectionName,
                          ),
                          ProfileRow(
                            icon: Icons.groups,
                            label: 'Group',
                            value: profile.groupName,
                          ),
                          ProfileRow(
                            icon: Icons.language,
                            label: 'Medium',
                            value: profile.mediumName,
                          ),
                          ProfileRow(
                            icon: Icons.access_time,
                            label: 'Shift',
                            value: profile.shiftName,
                          ),
                          ProfileRow(
                            icon: Icons.apartment,
                            label: 'Branch',
                            value: profile.branchName,
                          ),
                          ProfileRow(
                            icon: Icons.school,
                            label: 'Institute',
                            value: profile.instituteName,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class ProfileRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 20),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(value, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
