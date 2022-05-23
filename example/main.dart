import 'package:simplytranslate/simplytranslate.dart';

void main() async {
  ///use Google Translate
  final gt = SimplyTranslator(EngineType.google);

  ///use Libretranslate
  final lt = SimplyTranslator(EngineType.libre);

  /// get the list with instances
  print(gt.getInstances);
  //[simplytranslate.org, st.tokhmi.xyz, translate.josias.dev, ...

  ///update instances with the API
  gt.updateInstances();

  ///check if instance is working
  print(await gt.isInstanceWorking("simplytranslate.pussthecat.org"));
  //true

  /// find other instances under https://simple-web.org/projects/simplytranslate.html
  ///change instance (defaut is simplytranslate.org)
  gt.setInstance = "simplytranslate.pussthecat.org";

  ///if you do not specify the source language it is automatically selecting it depending on the text
  ///if you do not specify the target language it is automatically English

  ///get "hello" as an Audio-Url
  ///uses always Google TTS as Libretranslate doesnt support TTS, gives same result
  ///you can use https://pub.dev/packages/audioplayers to play it
  print(gt.getTTSUrl("hello", "en"));
  print(lt.getTTSUrl("hello", "en"));
  //https://simplytranslate.org/api/tts/?engine=google&lang=en&text=hello

  ///using Libretranslate
  ///only text translation avaliable
  ///short form to only get translated text as String, also shorter code:
  String textResult = await lt.tr("Er läuft schnell.", "de", 'en');

  ///is the same as
  textResult = await lt.tr("Er läuft schnell.");
  print(textResult);
  //he's running fast.

  ///long form
  var libTransl = await lt.translate(
      "The dispositions were very complicated and difficult.",
      from: 'en',
      to: 'de');
  print(libTransl.translations.text);
  //Die Anordnungen waren sehr kompliziert und schwierig.

  ///without source language (auto) and choosing a random instance:
  libTransl = await lt.translate(
      "The dispositions were very complicated and difficult.",
      to: 'de',
      instanceMode: InstanceMode.Random);
  print(libTransl.translations.text);
  //Die Anordnungen waren sehr kompliziert und schwierig.

  ///using Googletranslate:
  ///short form to only get translated text as String, also shorter code:
  textResult = await gt.tr("Er läuft schnell.", "en", 'de');

  ///is the same as
  textResult = await gt.tr("Er läuft schnell.");
  print(textResult);
  //He walks fast.

  ///long form to also get definitions and single word translations and switching to next instance
  var gtransl = await gt.translate(
      "The dispositions were very complicated and difficult.",
      from: 'en',
      to: 'de',
      instanceMode: InstanceMode.Loop);

  ///get whole Text translation
  ///Returns String
  print(gtransl.translations.text);
  //Die Dispositionen waren sehr kompliziert und schwierig.

  ///without source language (auto):
  gtransl = await gt.translate(
      "The dispositions were very complicated and difficult.",
      to: 'de');
  //Die Dispositionen waren sehr kompliziert und schwierig.

  ///get multiple word translations in target language from Google
  ///returns Map<String, dynamic>
  gtransl = await gt.translate("very", from: 'en', to: 'de');
  print(gtransl.translations.rawTranslations);
  //{adjective: {dick: {frequency: 1/3, words: [thick, fat, large, big, heavy, stout]}, faustdick: {frequency: 1/3,...

  ///get multiple word definitions in native language from Google
  ///returns Map<String, dynamic>
  print(gtransl.translations.rawDefinitions);
  //{adjective: [{definition: of considerable size, extent, or intensity., synonyms: {: [large, sizeable,...

  //get single word translations sorted by frequency
  print(gtransl.translations.frequencyTranslations);
  //[sehr, stark, bloß, genau, äußerste]

  ///get Lists with Translations and Definitions
  print(gtransl.translations.translations);
  print(gtransl.translations.definitions);

  ///changing instance each time
  for (int i = 0; i < gt.getInstances.length; i++) {
    gtransl = await gt.translate("Gewechselt",
        from: "de", instanceMode: InstanceMode.Random);
    print(gt.getCurrentInstance);
    //translate.josias.dev
    // translate.namazso.eu
    // translate.riverside.rocks,...
  }
}
