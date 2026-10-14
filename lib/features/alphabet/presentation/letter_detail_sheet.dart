import 'package:flutter/material.dart';
import 'package:smart_kids_learning/core/services/tts_service.dart';
import 'package:smart_kids_learning/features/alphabet/models/bangla_letter.dart';

/// A big, cheerful popup that shows a letter, its example word/emoji,
/// and speaks it when opened.
class LetterDetailSheet extends StatefulWidget {
  const LetterDetailSheet({super.key, required this.letter});

  final BanglaLetter letter;

  @override
  State<LetterDetailSheet> createState() => _LetterDetailSheetState();
}

class _LetterDetailSheetState extends State<LetterDetailSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TtsService.instance.speak(widget.letter.letter);
    });
  }

  @override
  Widget build(BuildContext context) {
    final letter = widget.letter;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: letter.color,
                borderRadius: BorderRadius.circular(36),
                boxShadow: [
                  BoxShadow(
                    color: letter.color.withValues(alpha: 0.5),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                letter.letter,
                style: const TextStyle(
                  fontSize: 84,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${letter.exampleEmoji}  ${letter.exampleWord}',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: Color(0xFF222222),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'à¦°à§‹à¦®à¦¾à¦¨: ${letter.romanized}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: letter.color,
                      minimumSize: const Size.fromHeight(60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => TtsService.instance.speak(letter.letter),
                    icon: const Icon(Icons.volume_up, size: 28),
                    label: const Text(
                      'à¦†à¦¬à¦¾à¦° à¦¶à§à¦¨à§à¦¨',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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