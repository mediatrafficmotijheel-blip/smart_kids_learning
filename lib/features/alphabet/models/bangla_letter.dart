import 'package:flutter/material.dart';

/// A single Bangla letter (vowel or consonant).
class BanglaLetter {
  const BanglaLetter({
    required this.id,
    required this.letter,
    required this.romanized,
    required this.exampleWord,
    required this.exampleEmoji,
    required this.color,
    required this.category,
  });

  final String id;
  final String letter;
  final String romanized;
  final String exampleWord;
  final String exampleEmoji;
  final Color color;
  final LetterCategory category;
}

enum LetterCategory { vowel, consonant }