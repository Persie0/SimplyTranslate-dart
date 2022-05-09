part of simplytranslate;


class Result{
  Result(this.text, this.definition, this.translations);
  final String text;
  final Map<String, dynamic> definition;
  final Map<String, dynamic> translations;
}
/// Translation returned from SimplyTranslator.translate method
abstract class Translation {
  final Result translations;
  late final String source;
  late final Language targetLanguage;
  late final Language sourceLanguage;

  Translation._(
  this.translations,this.source, this.sourceLanguage, this.targetLanguage);

}


class _Translation extends Translation {
 final Result translations;
  final String source;
  final Language sourceLanguage;
  final Language targetLanguage;


  _Translation(
    this.translations,{
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.source,
  }) : super._(translations, source, sourceLanguage, targetLanguage);

}
