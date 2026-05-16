import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'tasks_screen.dart';
import 'notes_screen.dart';
import 'focus_screen.dart';
import 'study_center_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      const TasksScreen(),
      const NotesScreen(),
      const FocusScreen(),
      const StudyCenterScreen(),
      Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.indigo.shade50, width: 8),
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.indigo.shade50,
                  child: Icon(Icons.person_rounded, size: 60, color: Colors.indigo.shade300),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Local User',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1),
              ),
              const Text(
                'Data saved on device',
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  children: [
                    _buildProfileStat('Account Tier', 'LOCAL ONLY'),
                    const Divider(height: 32),
                    _buildProfileStat('Build', 'v3.0.0-offline'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Privacy First: Your data stays on your phone.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ],
          ),
        ),
      ),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade50)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, LucideIcons.checkSquare, 'Tasks'),
                _buildNavItem(1, LucideIcons.fileText, 'Notes'),
                _buildNavItem(2, LucideIcons.clock, 'Focus'),
                _buildNavItem(3, LucideIcons.bookOpen, 'Study'),
                _buildNavItem(4, LucideIcons.user, 'Me'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w700, fontSize: 13)),
        Text(value, style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.w900, fontSize: 13)),
      ],
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.indigo.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.indigo : Colors.grey.shade400, size: 22),
            const SizedBox(height: 4),
            Text(
              isSelected ? label : '',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: isSelected ? Colors.indigo : Colors.grey.shade400,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
