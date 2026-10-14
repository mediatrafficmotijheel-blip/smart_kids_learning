import 'package:flutter/material.dart';
import 'package:smart_kids_learning/core/widgets/cloud_background.dart';
import 'package:smart_kids_learning/core/widgets/letter_tile.dart';
import 'package:smart_kids_learning/features/alphabet/data/bangla_alphabet.dart';
import 'package:smart_kids_learning/features/alphabet/models/bangla_letter.dart';
import 'package:smart_kids_learning/features/alphabet/presentation/letter_detail_sheet.dart';

class AlphabetScreen extends StatefulWidget {
  const AlphabetScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<AlphabetScreen> createState() => _AlphabetScreenState();
}

class _AlphabetScreenState extends State<AlphabetScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(
    length: 2,
    vsync: this,
    initialIndex: widget.initialTab,
  );

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CloudBackground(
      showSun: true,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  if (Navigator.of(context).canPop())
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 30),
                    ),
                  const Expanded(
                    child: Text(
                      'à¦¬à¦°à§à¦£ à¦¶à¦¿à¦–à¦¿',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
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
                  ),
                  if (Navigator.of(context).canPop())
                    const SizedBox(width: 40),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TabBar(
                controller: _tab,
                labelColor: const Color(0xFF1E88E5),
                unselectedLabelColor: Colors.black54,
                labelStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
                indicator: BoxDecoration(
                  color: const Color(0xFF1E88E5).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(24),
                ),
                tabs: const [
                  Tab(text: 'à¦¸à§à¦¬à¦°à¦¬à¦°à§à¦£'),
                  Tab(text: 'à¦¬à§à¦¯à¦žà§à¦œà¦¨à¦¬à¦°à§à¦£'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: const [
                  _LetterGrid(letters: BanglaAlphabet.vowels),
                  _LetterGrid(letters: BanglaAlphabet.consonants),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LetterGrid extends StatelessWidget {
  const _LetterGrid({required this.letters});

  final List<BanglaLetter> letters;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: letters.length,
      itemBuilder: (context, index) {
        final letter = letters[index];
        return LetterTile(
          letter: letter.letter,
          color: letter.color,
          size: 120,
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => LetterDetailSheet(letter: letter),
            );
          },
        );
      },
    );
  }
}