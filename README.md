# simplytranslate
Simplytranslate API for Dart / Flutter

GitHub: https://github.com/Persie0/SimplyTranslate-dart

Pub: https://pub.dev/packages/simplytranslate

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/marvinperzi#)

# Usage 

```dart
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
  //short form to only get translated text as String, also shorter code:
  String textResult = await LibreTranslator.tr("Er läuft schnell.","en",'de');
  //is the same as
  textResult = await LibreTranslator.tr("Er läuft schnell.");
  //he's running fast.

  //long form
  var Ltranslation = await LibreTranslator.translate(
      "The dispositions were very complicated and difficult.",
      from: 'en',
      to: 'de');
  print(textResult);
  print(Ltranslation.translations.text);
  //Die Anordnungen waren sehr kompliziert und schwierig.

  //without source language (auto):
  Ltranslation = await LibreTranslator.translate(
      "The dispositions were very complicated and difficult.",
      to: 'de');
  print(Ltranslation.translations.text);
  //Die Anordnungen waren sehr kompliziert und schwierig.

//using Googletranslate:
  //short form to only get translated text as String, also shorter code:
  textResult = await GoogleTranslator.tr("Er läuft schnell.","en",'de');
  //is the same as
  textResult = await GoogleTranslator.tr("Er läuft schnell.");
  print(textResult);
  //He walks fast.

  //long form to also get definitions and single word translations
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

  //get multiple word definitions in native language from Google
  //returns Map<String, dynamic>
  print(Gtranslation.translations.definition);
  //{adjective: [{definition: of considerable size, extent, or intensity., synonyms: {: [large, sizeable,...
}

```
&nbsp;

# Simplytranslate API docs
Simplytranslate API docs:  https://git.sr.ht/~metalune/simplytranslate_web/tree/HEAD/api.md
&nbsp;

# Credits
Credits go to:
https://github.com/gabrielpacheco23/google-translator
which was used as a template for this package.


As Google only allows a limited amount of requests an alternative was needed.
I chose
https://sr.ht/~metalune/SimplyTranslate/
Free and open source but you still get Google Translation quality.



Also considered and a great project (but no Libretranslate):
https://github.com/TheDavidDelta/lingva-translate
