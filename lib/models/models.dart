class Categories {
  String che;
  String en;
  String ru;

  Categories({
    required this.che,
    required this.en,
    required this.ru,
  });

  factory Categories.fromMap(Map<String, dynamic> map) {
    return Categories(
      che: map['che'] as String,
      en: map['en'] as String,
      ru: map['ru'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'che': che,
      'en': en,
      'ru': ru,
    };
  }

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      che: json['che'] as String,
      en: json['en'] as String,
      ru: json['ru'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'che': che,
      'en': en,
      'ru': ru,
    };
  }
}

class Sentence {
  String ar;
  String che;
  String en;
  String ru;

  Sentence({
    required this.ar,
    required this.che,
    required this.en,
    required this.ru,
  });

  factory Sentence.fromMap(Map<String, dynamic> map) {
    return Sentence(
      ar: map['ar'] as String,
      che: map['che'] as String,
      en: map['en'] as String,
      ru: map['ru'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ar': ar,
      'che': che,
      'en': en,
      'ru': ru,
    };
  }

  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
      ar: json['ar'] as String,
      che: json['che'] as String,
      en: json['en'] as String,
      ru: json['ru'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ar': ar,
      'che': che,
      'en': en,
      'ru': ru,
    };
  }
}

class Word {
  String picture;
  String ar;
  String che;
  String en;
  String ru;

  Word({
    required this.picture,
    required this.ar,
    required this.che,
    required this.en,
    required this.ru,
  });

  factory Word.fromMap(Map<dynamic, dynamic> map) {
    return Word(
      picture: map['picture'] as String,
      ar: (map['translation'] as Map)['ar'] as String,
      che: (map['translation'] as Map)['che'] as String,
      en: (map['translation'] as Map)['en'] as String,
      ru: (map['translation'] as Map)['ru'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'picture': picture,
      'translation': {
        'ar': ar,
        'che': che,
        'en': en,
        'ru': ru,
      }
    };
  }

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      picture: json['picture'] as String,
      ar: json['translation']['ar'] as String,
      che: json['translation']['che'] as String,
      en: json['translation']['en'] as String,
      ru: json['translation']['ru'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'picture': picture,
      'translation': {
        'ar': ar,
        'che': che,
        'en': en,
        'ru': ru,
      }
    };
  }
}

class Level {
  Categories category;
  Sentence sentence;
  List<Word> words;
  bool? finish;
  double? procent;
  num id;

  Level({
    required this.category,
    required this.sentence,
    required this.words,
    this.finish,
    this.procent,
    required this.id
  });

  factory Level.fromMap(Map<String, dynamic> map) {
    return Level(
      category: Categories.fromMap(map['category']),
      sentence: Sentence.fromMap(map['sentence']),
      words: (map['words'] as List<dynamic>).map((word) => Word.fromMap(word)).toList(),
      finish: map['finish'] as bool?,
      procent: (map['procent'] as num?)?.toDouble(),
      id: (map['id']) as num
    );
  }

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      category: Categories.fromJson(json['category']),
      sentence: Sentence.fromJson(json['sentence']),
      words: (json['words'] as List<dynamic>).map((word) => Word.fromJson(word)).toList(),
      finish: json['finish'] as bool?,
      procent: (json['procent'] as num?)?.toDouble(),
      id: (json['id']) as num

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category.toMap(),
      'sentence': sentence.toMap(),
      'words': words.map((word) => word.toMap()).toList(),
      'finish': finish,
      'procent': procent,
      'id' : id
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category.toJson(),
      'sentence': sentence.toJson(),
      'words': words.map((word) => word.toJson()).toList(),
      'finish': finish,
      'procent': procent,
      'id' : id
    };
  }
}
