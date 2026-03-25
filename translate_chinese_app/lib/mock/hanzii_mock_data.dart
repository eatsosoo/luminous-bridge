import 'dart:ui';

class CharacterStudyItem {
  final String character;
  final String meaning;
  final String pinyin;
  // Stroke paths are mock polylines in normalized [0..1] coordinates.
  final List<List<Offset>> strokes;

  const CharacterStudyItem({
    required this.character,
    required this.meaning,
    required this.pinyin,
    required this.strokes,
  });
}

const hanziPhraseItems = <CharacterStudyItem>[
  CharacterStudyItem(
    character: '我',
    meaning: 'I / me',
    pinyin: 'wǒ',
    strokes: [
      // 1) top horizontal
      [
        Offset(0.20, 0.22),
        Offset(0.80, 0.22),
      ],
      // 2) vertical
      [
        Offset(0.50, 0.22),
        Offset(0.50, 0.92),
      ],
      // 3) middle horizontal
      [
        Offset(0.20, 0.55),
        Offset(0.80, 0.55),
      ],
      // 4) bottom curve (mock)
      [
        Offset(0.22, 0.88),
        Offset(0.45, 0.72),
        Offset(0.50, 0.88),
        Offset(0.78, 0.88),
      ],
    ],
  ),
  CharacterStudyItem(
    character: '正',
    meaning: 'correct / right',
    pinyin: 'zhèng',
    strokes: [
      // 1) left vertical
      [
        Offset(0.28, 0.15),
        Offset(0.28, 0.90),
      ],
      // 2) top horizontal
      [
        Offset(0.28, 0.28),
        Offset(0.72, 0.28),
      ],
      // 3) middle cross
      [
        Offset(0.28, 0.55),
        Offset(0.72, 0.55),
      ],
      // 4) right vertical down
      [
        Offset(0.60, 0.28),
        Offset(0.60, 0.90),
      ],
      // 5) bottom diagonal
      [
        Offset(0.40, 0.78),
        Offset(0.55, 0.70),
        Offset(0.70, 0.82),
      ],
    ],
  ),
  CharacterStudyItem(
    character: '在',
    meaning: 'be at / exist',
    pinyin: 'zài',
    strokes: [
      // 1) left dot/top
      [
        Offset(0.40, 0.22),
        Offset(0.52, 0.22),
      ],
      // 2) vertical left
      [
        Offset(0.40, 0.22),
        Offset(0.40, 0.88),
      ],
      // 3) mid horizontal
      [
        Offset(0.40, 0.52),
        Offset(0.78, 0.52),
      ],
      // 4) right down diagonal (mock sweep)
      [
        Offset(0.62, 0.52),
        Offset(0.72, 0.70),
        Offset(0.58, 0.88),
      ],
    ],
  ),
  CharacterStudyItem(
    character: '学',
    meaning: 'study / learn',
    pinyin: 'xué',
    strokes: [
      // 1) top horizontal
      [
        Offset(0.20, 0.22),
        Offset(0.80, 0.22),
      ],
      // 2) left vertical down
      [
        Offset(0.28, 0.22),
        Offset(0.28, 0.88),
      ],
      // 3) right vertical down
      [
        Offset(0.72, 0.22),
        Offset(0.72, 0.88),
      ],
      // 4) bottom horizontal
      [
        Offset(0.28, 0.65),
        Offset(0.72, 0.65),
      ],
      // 5) inner diagonal
      [
        Offset(0.40, 0.62),
        Offset(0.52, 0.76),
        Offset(0.62, 0.60),
      ],
    ],
  ),
];

const mockTranslateJson = {
  "formatted": "今天我去学校学习中文。",
  "sentences": [
    {
      "sentence": "今天我去学校学习中文。",
      "sentence_pinyin": "jīn tiān wǒ qù xué xiào xué xí zhōng wén。",
      "meaning": "Hôm nay tôi đi học tiếng Trung ở trường.",
      "tokens": [
        {"text": "今天", "type": "word", "pinyin": "jīn tiān"},
        {"text": "我", "type": "word", "pinyin": "wǒ"},
        {"text": "去", "type": "word", "pinyin": "qù"},
        {"text": "学校", "type": "word", "pinyin": "xué xiào"},
        {"text": "学习", "type": "word", "pinyin": "xué xí"},
        {"text": "中文", "type": "word", "pinyin": "zhōng wén"},
        {"text": "。", "type": "punctuation"}
      ]
    }
  ],
  "stats": {
    "total_sentences": 1,
    "total_lines": 1,
    "total_tokens": 7
  }
};