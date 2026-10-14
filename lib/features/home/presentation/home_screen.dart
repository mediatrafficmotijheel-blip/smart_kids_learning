import 'package:flutter/material.dart';
import 'package:smart_kids_learning/core/widgets/bouncy_card.dart';
import 'package:smart_kids_learning/core/widgets/cloud_background.dart';
import 'package:smart_kids_learning/features/alphabet/presentation/alphabet_screen.dart';
import 'package:smart_kids_learning/features/progress/presentation/progress_screen.dart';
import 'package:smart_kids_learning/features/quiz/presentation/quiz_screen.dart';
import 'package:smart_kids_learning/features/settings/presentation/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CloudBackground(
      showSun: true,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text('ðŸ‘¦', style: TextStyle(fontSize: 40)),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'à¦—à¦¾à¦¨à§‡ à¦—à¦¾à¦¨à§‡ à¦¶à¦¿à¦–à¦¿',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black38,
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'à¦¬à¦¾à¦šà§à¦šà¦¾à¦¦à§‡à¦° à¦®à¦œà¦¾à¦¦à¦¾à¦° à¦›à¦¡à¦¼à¦¾ à¦—à¦¾à¦¨',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black38,
                                offset: Offset(1, 1),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                children: [
                  _MenuCard(
                    emoji: 'ðŸ”¤',
                    title: 'à¦¬à¦°à§à¦£ à¦¶à¦¿à¦–à¦¿',
                    subtitle: 'à¦…, à¦†, à¦‡, à¦ˆ...',
                    color: const Color(0xFFE53935),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AlphabetScreen(initialTab: 0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _MenuCard(
                    emoji: 'ðŸ”¢',
                    title: 'à¦¸à¦‚à¦–à§à¦¯à¦¾ à¦¶à¦¿à¦–à¦¿',
                    subtitle: 'à§§, à§¨, à§©...',
                    color: const Color(0xFF1E88E5),
                    onTap: () => _comingSoon(context, 'à¦¸à¦‚à¦–à§à¦¯à¦¾ à¦¶à¦¿à¦–à¦¿'),
                  ),
                  const SizedBox(height: 14),
                  _MenuCard(
                    emoji: 'â“',
                    title: 'à¦•à§à¦‡à¦œ à¦–à§‡à¦²à¦¿',
                    subtitle: 'à¦®à¦œà¦¾à¦° à¦ªà§à¦°à¦¶à§à¦¨',
                    color: const Color(0xFF43A047),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QuizScreen()),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _MenuCard(
                    emoji: 'ðŸ†',
                    title: 'à¦†à¦®à¦¾à¦° à¦…à¦—à§à¦°à¦—à¦¤à¦¿',
                    subtitle: 'à¦•à¦¤à¦Ÿà§à¦•à§ à¦¶à¦¿à¦–à§‡à¦›à¦¿',
                    color: const Color(0xFFFB8C00),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ProgressScreen()),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _MenuCard(
                    emoji: 'âš™ï¸',
                    title: 'à¦¸à§‡à¦Ÿà¦¿à¦‚à¦¸',
                    subtitle: 'à¦­à¦¾à¦·à¦¾ à¦“ à¦¥à¦¿à¦®',
                    color: const Color(0xFF8E24AA),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SettingsScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _comingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label à¦¶à§€à¦˜à§à¦°à¦‡ à¦†à¦¸à¦›à§‡!'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BouncyCard(
      color: Colors.white,
      padding: const EdgeInsets.all(14),
      borderRadius: 28,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 34)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF222222),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: color, size: 32),
        ],
      ),
    );
  }
}