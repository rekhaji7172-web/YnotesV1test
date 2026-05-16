import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'flashcard_screen.dart';
import 'resources_screen.dart';

class StudyCenterScreen extends StatelessWidget {
  const StudyCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('YStudy', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: -1, fontSize: 24)),
            Text('ACADEMIC TOOLKIT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 2)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildStudyCard(
              context,
              'Flashcards',
              'Quick recall practice',
              LucideIcons.layers,
              Colors.indigo,
              const FlashcardScreen(),
            ),
            const SizedBox(height: 20),
            _buildStudyCard(
              context,
              'Resources',
              'Find learning materials',
              LucideIcons.search,
              Colors.green,
              const ResourcesScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudyCard(BuildContext context, String title, String subtitle, IconData icon, Color color, Widget screen) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 8)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                  Text(subtitle, style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w600, fontSize: 13)),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight, color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }
}
