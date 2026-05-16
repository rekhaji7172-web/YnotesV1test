import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final List<Map<String, String>> _flashcards = [
    {'question': 'What is the capital of France?', 'answer': 'Paris'},
    {'question': 'Who wrote "Romeo and Juliet"?', 'answer': 'William Shakespeare'},
    {'question': 'What is the chemical symbol for Gold?', 'answer': 'Au'},
    {'question': 'What is 15 * 15?', 'answer': '225'},
  ];

  int _currentIndex = 0;
  bool _showAnswer = false;

  void _nextCard() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _flashcards.length;
      _showAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final card = _flashcards[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('YFlashcards', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: -1, fontSize: 24)),
            Text('STUDY QUICKLY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 2)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const Spacer(),
            GestureDetector(
              onTap: () => setState(() => _showAnswer = !_showAnswer),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: double.infinity,
                height: 300,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: _showAnswer ? Colors.indigo : Colors.blueGrey.shade900,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(color: Colors.indigo.withOpacity(0.2), blurRadius: 30, offset: const Offset(0, 10)),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _showAnswer ? 'ANSWER' : 'QUESTION',
                        style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _showAnswer ? card['answer']! : card['question']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Tap card to flip', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Add Card', style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  onPressed: _nextCard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('Next Card'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
