part of simplytranslate;

///Result includes the different translation results
class Result {
  const Result(
      this.text,
      this.raw_definitions,
      this.raw_translations,
      this.translations,
      this.definitions,
      this.frequency_translations,
      this.types);
  final String text;
  final Map<String, dynamic> raw_definitions;
  final Map<String, dynamic> raw_translations;
  final List<Translations> translations;
  final List<Definitions> definitions;
  final List<String> frequency_translations;
  final List<String> types;
}

///Result includes the different translation results
class Translations {
  Translations(this.type, this.word, this.frequency, this.meaning);
  final String type;
  final String word;
  final String frequency;
  final List<String> meaning;
}

class Definitions {
  Definitions(this.type, this.definition, this.synonyms, this.informal_synonyms,
      this.use_in_sentence, this.archaic, this.dictionary);
  final String type;
  final String definition;
  final List<String> synonyms;
  final List<String> informal_synonyms;
  final List<String> archaic;
  final String use_in_sentence;
  final String dictionary;
}

/// Translation returned from SimplyTranslator.translate method
abstract class Translation {
  final Result translations;
  late final String source;
  late final Language targetLanguage;
  late final Language sourceLanguage;

  Translation._(
      this.translations, this.source, this.sourceLanguage, this.targetLanguage);
}

class _Translation extends Translation {
  final Result translations;
  final String source;
  final Language sourceLanguage;
  final Language targetLanguage;

  _Translation(
    this.translations, {
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.source,
  }) : super._(translations, source, sourceLanguage, targetLanguage);
}
