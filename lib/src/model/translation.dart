part of simplytranslate;

///Result includes the different translation results
class Result {
  const Result(
      this.text,
      this.rawDefinitions,
      this.rawTranslations,
      this.translations,
      this.definitions,
      this.frequencyTranslations,
      this.types);
  final String text;
  final Map<String, dynamic> rawDefinitions;
  final Map<String, dynamic> rawTranslations;
  final List<Translations> translations;
  final List<Definitions> definitions;
  final List<String> frequencyTranslations;
  final List<String> types;
}

/// raw_translations as a class
class Translations {
  Translations(this.type, this.word, this.frequency, this.meaning);
  final String type;
  final String word;
  final String frequency;
  final List<String> meaning;
}

/// raw_definitions as a class
class Definitions {
  Definitions(this.type, this.definition, this.synonyms, this.informalSynonyms,
      this.useInSentence, this.archaic, this.dictionary);
  final String type;
  final String definition;
  final List<String> synonyms;
  final List<String> informalSynonyms;
  final List<String> archaic;
  final String useInSentence;
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
