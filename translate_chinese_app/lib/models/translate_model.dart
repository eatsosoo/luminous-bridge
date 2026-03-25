class TranslateResponse {
  final String formatted;
  final List<Sentence> sentences;

  TranslateResponse({
    required this.formatted,
    required this.sentences,
  });

  factory TranslateResponse.fromJson(Map<String, dynamic> json) {
    return TranslateResponse(
      formatted: json['formatted'],
      sentences: (json['sentences'] as List)
          .map((e) => Sentence.fromJson(e))
          .toList(),
    );
  }
}

class Sentence {
  final String sentence;
  final String pinyin;
  final String meaning;
  final List<Token> tokens;

  Sentence({
    required this.sentence,
    required this.pinyin,
    required this.meaning,
    required this.tokens,
  });

  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
      sentence: json['sentence'],
      pinyin: json['sentence_pinyin'],
      meaning: json['meaning'],
      tokens: (json['tokens'] as List)
          .map((e) => Token.fromJson(e))
          .toList(),
    );
  }
}

class Token {
  final String text;
  final String type;
  final String? pinyin;

  Token({
    required this.text,
    required this.type,
    this.pinyin,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      text: json['text'],
      type: json['type'],
      pinyin: json['pinyin'],
    );
  }
}