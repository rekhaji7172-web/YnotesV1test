import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  final List<Map<String, String>> resources = const [
    {
      'title': 'Khan Academy',
      'desc': 'Free online courses, lessons & practice.',
      'url': 'https://www.khanacademy.org',
      'category': 'COURSES'
    },
    {
      'title': 'WolframAlpha',
      'desc': 'Computational intelligence for math & science.',
      'url': 'https://www.wolframalpha.com',
      'category': 'TOOLS'
    },
    {
      'title': 'Coursera',
      'desc': 'Learn from top universities and companies.',
      'url': 'https://www.coursera.org',
      'category': 'COURSES'
    },
    {
      'title': 'Notion',
      'desc': 'The all-in-one workspace for notes & docs.',
      'url': 'https://www.notion.so',
      'category': 'PRODUCTIVITY'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('YResources', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: -1, fontSize: 24)),
            Text('KNOWLEDGE REPOSITORY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 2)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: resources.length,
        itemBuilder: (context, index) {
          final res = resources[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade100),
              boxShadow: [
                BoxShadow(color: Colors.indigo.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(20),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.indigo.shade50, borderRadius: BorderRadius.circular(8)),
                    child: Text(res['category']!, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.indigo)),
                  ),
                  const SizedBox(width: 8),
                  Text(res['title']!, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(res['desc']!, style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
              ),
              trailing: const Icon(LucideIcons.externalLink, size: 18, color: Colors.grey),
              onTap: () async {
                final url = Uri.parse(res['url']!);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
