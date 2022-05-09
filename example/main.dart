import 'package:simplytranslate/simplytranslate.dart';

void main() async {
  //use Google Translate
  final GoogleTranslator = SimplyTranslator(EngineType.google);
  //use Libretranslate
  final LibreTranslator = SimplyTranslator(EngineType.libre);

  //get "hello" as an Audio-Url
  //uses always Google TTS as Libretranslate doesnt support TTS, gives same result
  print(GoogleTranslator.getTTSUrl("hello", "en"));
  print(LibreTranslator.getTTSUrl("hello", "en"));
  //https://simplytranslate.org/api/tts/?engine=google&lang=en&text=hello

//using Libretranslate
  //only text translation avaliable
  var Ltranslation = await LibreTranslator.translate(
      "The dispositions were very complicated and difficult.",
      from: 'en',
      to: 'de');
  print(Ltranslation.translations.text);
  //Die Anordnungen waren sehr kompliziert und schwierig.

  //without source language (auto):
  Ltranslation = await LibreTranslator.translate(
      "The dispositions were very complicated and difficult.",
      to: 'de');
  print(Ltranslation.translations.text);
  //Die Anordnungen waren sehr kompliziert und schwierig.

//using Googletranslate:
  var Gtranslation = await GoogleTranslator.translate(
      "The dispositions were very complicated and difficult.",
      from: 'en',
      to: 'de');
  //get whole Text translation
  //Returns String
  print(Gtranslation.translations.text);
  //Die Dispositionen waren sehr kompliziert und schwierig.

  //without source language (auto):
  Gtranslation = await GoogleTranslator.translate(
      "The dispositions were very complicated and difficult.",
      to: 'de');
  //Die Dispositionen waren sehr kompliziert und schwierig.

  //get multiple word translations in target language from Google
  //returns Map<String, dynamic>
  Gtranslation = await GoogleTranslator.translate("big", from: 'en', to: 'de');
  print(Gtranslation.translations.translations);
  //{adjective: {dick: {frequency: 1/3, words: [thick, fat, large, big, heavy, stout]}, faustdick: {frequency: 1/3,...

  //get multiple word defenitions in native language from Google
  //returns Map<String, dynamic>
  print(Gtranslation.translations.definition);
  //{adjective: [{definition: of considerable size, extent, or intensity., synonyms: {: [large, sizeable,...
}
