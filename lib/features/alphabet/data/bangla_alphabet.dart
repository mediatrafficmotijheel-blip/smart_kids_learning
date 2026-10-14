import 'package:flutter/material.dart';
import 'package:smart_kids_learning/features/alphabet/models/bangla_letter.dart';

class BanglaAlphabet {
  BanglaAlphabet._();

  static const Color _c1 = Color(0xFFE53935); // red
  static const Color _c2 = Color(0xFF1E88E5); // blue
  static const Color _c3 = Color(0xFF43A047); // green
  static const Color _c4 = Color(0xFFFB8C00); // orange
  static const Color _c5 = Color(0xFF8E24AA); // purple
  static const Color _c6 = Color(0xFFFDD835); // yellow
  static const Color _c7 = Color(0xFFD81B60); // pink
  static const Color _c8 = Color(0xFF00897B); // teal
  static const Color _c9 = Color(0xFF3949AB); // indigo
  static const Color _c10 = Color(0xFF6D4C41); // brown

  static const List<Color> rainbow = [
    _c1, _c2, _c3, _c4, _c5, _c6, _c7, _c8, _c9, _c10
  ];

  static const List<BanglaLetter> vowels = [
    BanglaLetter(id: 'o', letter: 'à¦…', romanized: 'o', exampleWord: 'à¦…à¦œà¦—à¦°', exampleEmoji: 'ðŸ', color: _c1, category: LetterCategory.vowel),
    BanglaLetter(id: 'aa', letter: 'à¦†', romanized: 'aa', exampleWord: 'à¦†à¦®', exampleEmoji: 'ðŸ¥­', color: _c2, category: LetterCategory.vowel),
    BanglaLetter(id: 'i', letter: 'à¦‡', romanized: 'i', exampleWord: 'à¦‡à¦à¦¦à§à¦°', exampleEmoji: 'ðŸ­', color: _c3, category: LetterCategory.vowel),
    BanglaLetter(id: 'ii', letter: 'à¦ˆ', romanized: 'ii', exampleWord: 'à¦ˆà¦—à¦²', exampleEmoji: 'ðŸ¦…', color: _c4, category: LetterCategory.vowel),
    BanglaLetter(id: 'u', letter: 'à¦‰', romanized: 'u', exampleWord: 'à¦‰à¦Ÿ', exampleEmoji: 'ðŸª', color: _c5, category: LetterCategory.vowel),
    BanglaLetter(id: 'uu', letter: 'à¦Š', romanized: 'uu', exampleWord: 'à¦Šà¦·à¦¾', exampleEmoji: 'ðŸŒ…', color: _c6, category: LetterCategory.vowel),
    BanglaLetter(id: 'ri', letter: 'à¦‹', romanized: 'ri', exampleWord: 'à¦‹à¦¤à§', exampleEmoji: 'ðŸ‚', color: _c7, category: LetterCategory.vowel),
    BanglaLetter(id: 'e', letter: 'à¦', romanized: 'e', exampleWord: 'à¦à¦•', exampleEmoji: '1ï¸âƒ£', color: _c8, category: LetterCategory.vowel),
    BanglaLetter(id: 'oi', letter: 'à¦', romanized: 'oi', exampleWord: 'à¦à¦¤à¦¿à¦¹à¦¾à¦¸à¦¿à¦•', exampleEmoji: 'ðŸ›ï¸', color: _c9, category: LetterCategory.vowel),
    BanglaLetter(id: 'oo', letter: 'à¦“', romanized: 'o', exampleWord: 'à¦“à¦²', exampleEmoji: 'ðŸ¥”', color: _c10, category: LetterCategory.vowel),
    BanglaLetter(id: 'ou', letter: 'à¦”', romanized: 'ou', exampleWord: 'à¦”à¦·à¦§', exampleEmoji: 'ðŸ’Š', color: _c1, category: LetterCategory.vowel),
  ];

  static const List<BanglaLetter> consonants = [
    BanglaLetter(id: 'k', letter: 'à¦•', romanized: 'k', exampleWord: 'à¦•à¦²à¦¾', exampleEmoji: 'ðŸŒ', color: _c1, category: LetterCategory.consonant),
    BanglaLetter(id: 'kh', letter: 'à¦–', romanized: 'kh', exampleWord: 'à¦–à¦°à¦—à§‹à¦¶', exampleEmoji: 'ðŸ°', color: _c2, category: LetterCategory.consonant),
    BanglaLetter(id: 'g', letter: 'à¦—', romanized: 'g', exampleWord: 'à¦—à¦°à§', exampleEmoji: 'ðŸ„', color: _c3, category: LetterCategory.consonant),
    BanglaLetter(id: 'gh', letter: 'à¦˜', romanized: 'gh', exampleWord: 'à¦˜à¦¡à¦¼à¦¿', exampleEmoji: 'âŒš', color: _c4, category: LetterCategory.consonant),
    BanglaLetter(id: 'ng', letter: 'à¦™', romanized: 'ng', exampleWord: 'à¦¬à§à¦¯à¦¾à¦™', exampleEmoji: 'ðŸ¸', color: _c5, category: LetterCategory.consonant),
    BanglaLetter(id: 'ch', letter: 'à¦š', romanized: 'ch', exampleWord: 'à¦šà¦¶à¦®à¦¾', exampleEmoji: 'ðŸ‘“', color: _c6, category: LetterCategory.consonant),
    BanglaLetter(id: 'chh', letter: 'à¦›', romanized: 'chh', exampleWord: 'à¦›à¦¾à¦¤à¦¾', exampleEmoji: 'â˜‚ï¸', color: _c7, category: LetterCategory.consonant),
    BanglaLetter(id: 'j', letter: 'à¦œ', romanized: 'j', exampleWord: 'à¦œà¦¾à¦¹à¦¾à¦œ', exampleEmoji: 'ðŸš¢', color: _c8, category: LetterCategory.consonant),
    BanglaLetter(id: 'jh', letter: 'à¦', romanized: 'jh', exampleWord: 'à¦à§à¦¡à¦¼à¦¿', exampleEmoji: 'ðŸ§º', color: _c9, category: LetterCategory.consonant),
    BanglaLetter(id: 'ny', letter: 'à¦ž', romanized: 'n', exampleWord: 'à¦®à¦¿à¦žà¦¾', exampleEmoji: 'ðŸ§‘', color: _c10, category: LetterCategory.consonant),
    BanglaLetter(id: 'tt', letter: 'à¦Ÿ', romanized: 't', exampleWord: 'à¦Ÿà¦®à§‡à¦Ÿà§‹', exampleEmoji: 'ðŸ…', color: _c1, category: LetterCategory.consonant),
    BanglaLetter(id: 'tth', letter: 'à¦ ', romanized: 'th', exampleWord: 'à¦ à§‹à¦à¦Ÿ', exampleEmoji: 'ðŸ‘„', color: _c2, category: LetterCategory.consonant),
    BanglaLetter(id: 'dd', letter: 'à¦¡', romanized: 'd', exampleWord: 'à¦¡à¦¿à¦®', exampleEmoji: 'ðŸ¥š', color: _c3, category: LetterCategory.consonant),
    BanglaLetter(id: 'ddh', letter: 'à¦¢', romanized: 'dh', exampleWord: 'à¦¢à¦¾à¦•', exampleEmoji: 'ðŸ¥', color: _c4, category: LetterCategory.consonant),
    BanglaLetter(id: 'nn', letter: 'à¦£', romanized: 'n', exampleWord: 'à¦¹à¦°à¦¿à¦£', exampleEmoji: 'ðŸ¦Œ', color: _c5, category: LetterCategory.consonant),
    BanglaLetter(id: 't', letter: 'à¦¤', romanized: 't', exampleWord: 'à¦¤à¦¾à¦°à¦¾', exampleEmoji: 'â­', color: _c6, category: LetterCategory.consonant),
    BanglaLetter(id: 'th', letter: 'à¦¥', romanized: 'th', exampleWord: 'à¦¥à¦¾à¦²à¦¾', exampleEmoji: 'ðŸ½ï¸', color: _c7, category: LetterCategory.consonant),
    BanglaLetter(id: 'd', letter: 'à¦¦', romanized: 'd', exampleWord: 'à¦¦à¦¾à¦à¦¤', exampleEmoji: 'ðŸ¦·', color: _c8, category: LetterCategory.consonant),
    BanglaLetter(id: 'dh', letter: 'à¦§', romanized: 'dh', exampleWord: 'à¦§à¦¾à¦¨', exampleEmoji: 'ðŸŒ¾', color: _c9, category: LetterCategory.consonant),
    BanglaLetter(id: 'n', letter: 'à¦¨', romanized: 'n', exampleWord: 'à¦¨à¦¦à§€', exampleEmoji: 'ðŸžï¸', color: _c10, category: LetterCategory.consonant),
    BanglaLetter(id: 'p', letter: 'à¦ª', romanized: 'p', exampleWord: 'à¦ªà¦¾à¦–à¦¿', exampleEmoji: 'ðŸ¦', color: _c1, category: LetterCategory.consonant),
    BanglaLetter(id: 'ph', letter: 'à¦«', romanized: 'ph', exampleWord: 'à¦«à§à¦²', exampleEmoji: 'ðŸŒ¸', color: _c2, category: LetterCategory.consonant),
    BanglaLetter(id: 'b', letter: 'à¦¬', romanized: 'b', exampleWord: 'à¦¬à¦¾à¦˜', exampleEmoji: 'ðŸ¯', color: _c3, category: LetterCategory.consonant),
    BanglaLetter(id: 'bh', letter: 'à¦­', romanized: 'bh', exampleWord: 'à¦­à¦¾à¦²à§à¦•', exampleEmoji: 'ðŸ»', color: _c4, category: LetterCategory.consonant),
    BanglaLetter(id: 'm', letter: 'à¦®', romanized: 'm', exampleWord: 'à¦®à¦¾à¦›', exampleEmoji: 'ðŸŸ', color: _c5, category: LetterCategory.consonant),
    BanglaLetter(id: 'j2', letter: 'à¦¯', romanized: 'j', exampleWord: 'à¦¯à¦¾à¦¦à§', exampleEmoji: 'ðŸŽ©', color: _c6, category: LetterCategory.consonant),
    BanglaLetter(id: 'r', letter: 'à¦°', romanized: 'r', exampleWord: 'à¦°à¦¾à¦œà¦¾', exampleEmoji: 'ðŸ‘‘', color: _c7, category: LetterCategory.consonant),
    BanglaLetter(id: 'l', letter: 'à¦²', romanized: 'l', exampleWord: 'à¦²à§‡à¦¬à§', exampleEmoji: 'ðŸ‹', color: _c8, category: LetterCategory.consonant),
    BanglaLetter(id: 'sh', letter: 'à¦¶', romanized: 'sh', exampleWord: 'à¦¶à¦¿à¦‚', exampleEmoji: 'ðŸ', color: _c9, category: LetterCategory.consonant),
    BanglaLetter(id: 'shh', letter: 'à¦·', romanized: 'sh', exampleWord: 'à¦·à¦¾à¦Ÿ', exampleEmoji: '6ï¸âƒ£', color: _c10, category: LetterCategory.consonant),
    BanglaLetter(id: 's', letter: 'à¦¸', romanized: 's', exampleWord: 'à¦¸à§‚à¦°à§à¦¯', exampleEmoji: 'â˜€ï¸', color: _c1, category: LetterCategory.consonant),
    BanglaLetter(id: 'h', letter: 'à¦¹', romanized: 'h', exampleWord: 'à¦¹à¦¾à¦¤à¦¿', exampleEmoji: 'ðŸ˜', color: _c2, category: LetterCategory.consonant),
    BanglaLetter(id: 'rr', letter: 'à¦¡à¦¼', romanized: 'r', exampleWord: 'à¦¬à¦¡à¦¼', exampleEmoji: 'ðŸ“', color: _c3, category: LetterCategory.consonant),
    BanglaLetter(id: 'rrh', letter: 'à¦¢à¦¼', romanized: 'rh', exampleWord: 'à¦†à¦·à¦¾à¦¢à¦¼', exampleEmoji: 'ðŸŒ§ï¸', color: _c4, category: LetterCategory.consonant),
    BanglaLetter(id: 'y', letter: 'à¦¯à¦¼', romanized: 'y', exampleWord: 'à¦¬à¦¯à¦¼', exampleEmoji: 'ðŸ‘¦', color: _c5, category: LetterCategory.consonant),
    BanglaLetter(id: 't2', letter: 'à§Ž', romanized: 't', exampleWord: 'à¦¹à¦ à¦¾à§Ž', exampleEmoji: 'âš¡', color: _c6, category: LetterCategory.consonant),
    BanglaLetter(id: 'ng2', letter: 'à¦‚', romanized: 'ng', exampleWord: 'à¦°à¦‚', exampleEmoji: 'ðŸŽ¨', color: _c7, category: LetterCategory.consonant),
    BanglaLetter(id: 'hh', letter: 'à¦ƒ', romanized: 'h', exampleWord: 'à¦¦à§à¦ƒà¦–', exampleEmoji: 'ðŸ˜¢', color: _c8, category: LetterCategory.consonant),
    BanglaLetter(id: 'n2', letter: 'à¦', romanized: 'n', exampleWord: 'à¦šà¦¾à¦à¦¦', exampleEmoji: 'ðŸŒ™', color: _c9, category: LetterCategory.consonant),
  ];
}