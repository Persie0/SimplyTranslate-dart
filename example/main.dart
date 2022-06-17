import 'package:simplytranslate/simplytranslate.dart';

void main() async {
  ///use Google Translate
  final gt = SimplyTranslator(EngineType.google);

  ///if you do not specify the source language it is automatically selecting it depending on the text
  ///if you do not specify the target language it is automatically English

  ///get "hello" as an Audio-Url
  ///uses always Google TTS as Libretranslate doesnt support TTS, gives same result
  ///you can use https://pub.dev/packages/audioplayers to play it
  print(gt.getTTSUrlSimply("hello", "en"));
  //https://simplytranslate.org/api/tts/?engine=google&lang=en&text=hello

  ///using Googletranslate:
  ///short form to only get translated text as String, also shorter code:
  String textResult = await gt.trSimply("Er läuft schnell.", "de", 'en');

  print(textResult);
  //He walks fast.

  ///get time it took to translate
  print(await gt.speedTest(gt.trSimply, "Er läuft schnell."));
  //1278ms

  ///use Libretranslate
  final lt = SimplyTranslator(EngineType.libre);

  /// get the list with instances
  print(gt.getInstances);
  //[simplytranslate.org, st.tokhmi.xyz, translate.josias.dev, ...

  ///update instances with the API
  gt.updateSimplyInstances();

  ///check if instance is working
  print(await gt.isSimplyInstanceWorking("simplytranslate.pussthecat.org"));
  //true

  /// find other instances under https://simple-web.org/projects/simplytranslate.html
  ///change instance (defaut is simplytranslate.org)
  gt.setInstance = "simplytranslate.pussthecat.org";

  ///using Libretranslate
  ///only text translation avaliable
  ///short form to only get translated text as String, also shorter code:
  textResult = await lt.trSimply("Er läuft schnell.", "de", 'en');

  ///is the same as
  textResult = await lt.trSimply("Er läuft schnell.");
  print(textResult);
  //he's running fast.

  ///long form, switching to next instance, 4 retries if it fails (default 1)
  var libTransl = await lt.translateSimply(
      "The dispositions were very complicated and difficult.",
      from: 'en',
      to: 'de',
      instanceMode: InstanceMode.Loop,
      retries: 4);
  print(libTransl.translations.text);
  //Die Anordnungen waren sehr kompliziert und schwierig.

  ///without source language (auto) and choosing a random instance:
  libTransl = await lt.translateSimply(
      "The dispositions were very complicated and difficult.",
      to: 'de',
      instanceMode: InstanceMode.Random);
  print(libTransl.translations.text);
  //Die Anordnungen waren sehr kompliziert und schwierig.

  ///long form to also get definitions and single word translations and switching to next instance, 4 retries if it fails (default 1)
  var gtransl = await gt.translateSimply(
      "The dispositions were very complicated and difficult.",
      from: 'en',
      to: 'de',
      instanceMode: InstanceMode.Loop,
      retries: 4);

  ///get whole Text translation
  ///Returns String
  print(gtransl.translations.text);
  //Die Dispositionen waren sehr kompliziert und schwierig.

  ///without source language (auto):
  gtransl = await gt.translateSimply(
      "The dispositions were very complicated and difficult.",
      to: 'de');
  //Die Dispositionen waren sehr kompliziert und schwierig.

  ///get multiple word translations in target language from Google
  ///returns Map<String, dynamic>
  gtransl = await gt.translateSimply("exuberance", from: 'en', to: 'de');
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
    gtransl = await gt.translateSimply("Gewechselt",
        from: "de", instanceMode: InstanceMode.Random);
    print(gt.getCurrentInstance);
    //translate.josias.dev
    // translate.namazso.eu
    // translate.riverside.rocks,...
  }
}
