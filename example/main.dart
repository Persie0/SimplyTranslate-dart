import 'package:simplytranslate/simplytranslate.dart';

void main() async {
  ///use Google Translate
  final GoogleTranslator = SimplyTranslator(EngineType.google);

  ///use Libretranslate
  final LibreTranslator = SimplyTranslator(EngineType.libre);

  /// get the list with instances
  print(GoogleTranslator.get_Instances);
  //[simplytranslate.org, st.tokhmi.xyz, translate.josias.dev, ...

  ///check if instance is working
  print(await GoogleTranslator.is_instance_Working(
      "simplytranslate.pussthecat.org"));
  //true

  /// find other instances under https://simple-web.org/projects/simplytranslate.html
  ///change instance (defaut is simplytranslate.org)
  GoogleTranslator.set_Instance = "simplytranslate.pussthecat.org";

  ///if you do not specify the source language it is automatically selecting it depending on the text
  ///if you do not specify the target language it is automatically English

  ///get "hello" as an Audio-Url
  ///uses always Google TTS as Libretranslate doesnt support TTS, gives same result
  print(GoogleTranslator.getTTSUrl("hello", "en"));
  print(LibreTranslator.getTTSUrl("hello", "en"));
  //https://simplytranslate.org/api/tts/?engine=google&lang=en&text=hello

  ///using Libretranslate
  ///only text translation avaliable
  ///short form to only get translated text as String, also shorter code:
  String textResult = await LibreTranslator.tr("Er läuft schnell.", "de", 'en');

  ///is the same as
  textResult = await LibreTranslator.tr("Er läuft schnell.");
  print(textResult);
  //he's running fast.

  ///long form
  var Ltranslation = await LibreTranslator.translate(
      "The dispositions were very complicated and difficult.",
      from: 'en',
      to: 'de');
  print(Ltranslation.translations.text);
  //Die Anordnungen waren sehr kompliziert und schwierig.

  ///without source language (auto) and choosing a random instance:
  Ltranslation = await LibreTranslator.translate(
      "The dispositions were very complicated and difficult.",
      to: 'de',
      instanceMode: InstanceMode.Random);
  print(Ltranslation.translations.text);
  //Die Anordnungen waren sehr kompliziert und schwierig.

  ///using Googletranslate:
  ///short form to only get translated text as String, also shorter code:
  textResult = await GoogleTranslator.tr("Er läuft schnell.", "en", 'de');

  ///is the same as
  textResult = await GoogleTranslator.tr("Er läuft schnell.");
  print(textResult);
  //He walks fast.

  ///long form to also get definitions and single word translations and switching to next instance
  var Gtranslation = await GoogleTranslator.translate(
      "The dispositions were very complicated and difficult.",
      from: 'en',
      to: 'de',
      instanceMode: InstanceMode.Loop);

  ///get whole Text translation
  ///Returns String
  print(Gtranslation.translations.text);
  //Die Dispositionen waren sehr kompliziert und schwierig.

  ///without source language (auto):
  Gtranslation = await GoogleTranslator.translate(
      "The dispositions were very complicated and difficult.",
      to: 'de');
  //Die Dispositionen waren sehr kompliziert und schwierig.

  ///get multiple word translations in target language from Google
  ///returns Map<String, dynamic>
  Gtranslation = await GoogleTranslator.translate("very", from: 'en', to: 'de');
  print(Gtranslation.translations.raw_translations);
  //{adjective: {dick: {frequency: 1/3, words: [thick, fat, large, big, heavy, stout]}, faustdick: {frequency: 1/3,...

  ///get multiple word definitions in native language from Google
  ///returns Map<String, dynamic>
  print(Gtranslation.translations.raw_definitions);
  //{adjective: [{definition: of considerable size, extent, or intensity., synonyms: {: [large, sizeable,...

  //get single word translations sorted by frequency
  print(Gtranslation.translations.frequency_translations);
  //[sehr, stark, bloß, genau, äußerste]

  ///get Lists with Translations and Definitions
  print(Gtranslation.translations.translations);
  print(Gtranslation.translations.definitions);

  ///changing instance each time
  for (int i = 0; i < GoogleTranslator.get_Instances.length; i++) {
    Gtranslation = await GoogleTranslator.translate("Gewechselt",
        from: "de", instanceMode: InstanceMode.Random);
    print(GoogleTranslator.get_current_Instance);
    //translate.josias.dev
    // translate.namazso.eu
    // translate.riverside.rocks,...
  }
}
