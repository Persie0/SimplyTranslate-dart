# SimplyTranslate-dart

[GitHub](https://github.com/Persie0/SimplyTranslate-dart) | [Pub](https://pub.dev/packages/simplytranslate)

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/marvinperzi#)

<a href="https://paypal.me/marvinperzi?country.x=AT&locale.x=de_DE"><img src="https://github.com/andreostrovsky/donate-with-paypal/raw/master/blue.svg" height="36"></a>

## Info
A Dart package to translate text using SimplyTranslate, Lingva Translate, and LibreTranslate. 

[SimplyTranslate](https://codeberg.org/ManeraKai/simplytranslate) and [Lingva Translate](https://github.com/thedaviddelta/lingva-translate) are free and open-source alternatives to Google Translate (that make use of Google Translate under the hood).

[LibreTranslate](https://github.com/LibreTranslate/LibreTranslate) is a free and open-source alternative to Google Translate that uses a open-source translation engine.
## Usage 

As I can't always update the instance list (instances are run by volunteers and can be turned off at any time):
- Search for new instances by googling "simplytranslate" or "lingva translate" and set the instance with setInstance = "instance"
- lingva instances can also be found [here](https://github.com/thedaviddelta/lingva-translate?tab=readme-ov-file#instances)

```dart
import 'package:simplytranslate/simplytranslate.dart';

void main() async {
  ///if you do not specify the source language it is automatically selecting it depending on the text
  ///if you do not specify the target language it is automatically English

  //////////////////////////////////
  // SimplyTranslate (=Google Translate)
  //////////////////////////////////
  final st = SimplyTranslator(EngineType.google);

  /// find other instances under https://simple-web.org/projects/simplytranslate.html
  ///change instance (defaut is simplytranslate.org)
  st.setSimplyInstance = "simplytranslate.pussthecat.org";

  /// get the list with instances
  print(st.getSimplyInstances);
  //[simplytranslate.org, st.tokhmi.xyz, translate.josias.dev, ...

  ///check if instance is working
  print(await st.isSimplyInstanceWorking("simplytranslate.pussthecat.org"));
  //true

  ///short form to only get translated text as String, also shorter code:
  String textResult = await st.trSimply("Er läuft schnell.", "de", 'en');
  print(textResult);
  //He walks fast.

  ///long form, switching to next instance after each translation, 4 retries if it fails (default 1)
  var stTransl = await st.translateSimply(
      "The dispositions were very complicated and difficult.",
      from: 'en',
      to: 'de',
      instanceMode: InstanceMode.Loop,
      retries: 4);
  print(stTransl.translations.text);
  //Die Anordnungen waren sehr kompliziert und schwierig.

  ///without source language (auto) and choosing a random instance:
  stTransl = await st.translateSimply(
      "The dispositions were very complicated and difficult.",
      to: 'de',
      instanceMode: InstanceMode.Random);
  print(stTransl.translations.text);
  //Die Anordnungen waren sehr kompliziert und schwierig.

  ///get multiple word translations in target language from Google
  ///returns Map<String, dynamic>
  stTransl = await st.translateSimply("exuberance", from: 'en', to: 'de');
  print(stTransl.translations.rawTranslations);
  //{adjective: {dick: {frequency: 1/3, words: [thick, fat, large, big, heavy, stout]}, faustdick: {frequency: 1/3,...

  ///get multiple word definitions in native language from Google
  ///returns Map<String, dynamic>
  print(stTransl.translations.rawDefinitions);
  //{adjective: [{definition: of considerable size, extent, or intensity., synonyms: {: [large, sizeable,...

  //get single word translations sorted by frequency
  print(stTransl.translations.frequencyTranslations);
  //[sehr, stark, bloß, genau, äußerste]

  ///get Lists with Translations and Definitions
  var def = stTransl.translations.definitions;
  print(def[0].synonyms);
  print(def[0].useInSentence);
  //...

  var tra = stTransl.translations.translations;
  print(tra[0].frequency);
  print(tra[0].meaning);
  //...

  ///changing instance each time
  for (int i = 0; i < st.getSimplyInstances.length; i++) {
    stTransl = await st.translateSimply("Gewechselt",
        from: "de", instanceMode: InstanceMode.Random);
    print(st.getCurrentSimplyInstance);
    //translate.josias.dev
    // translate.namazso.eu
    // translate.riverside.rocks,...
  }

  //////////////////////////////////
  // Lingva Translate (=Google Translate)
  //////////////////////////////////

  final vt = SimplyTranslator(EngineType.google);

  ///using Lingva Translate short form
  String textResult2 = await vt.trLingva("Er läuft schnell.", "de", 'en');
  print(textResult2);
  //He walks fast.

  ///using Graphql Request
  textResult2 = await vt.trLingvaGraphQL("Er läuft schnell.", "de", 'en');
  print(textResult2);
  //He walks fast.

  ///using Lingva Translate long form, getting list of multiple translations (only for words)
  var listResult = await vt.translateLingva(
    "bank",
    'en',
    'de',
    InstanceMode.Loop,
  );
  print(listResult);
  //["Bank", "Ufer", ...]

  ///using Lingva Translate long form with Graphql Request
  listResult = await vt.translateLingvaGQL(
    "bank",
    'en',
    'de',
    InstanceMode.Loop,
  );
  print(listResult);
  //["Bank", "Ufer", ...]

  //////////////////////////////////
  // LibreTranslate (NOT!!! Google Translate)
  // has the same functions as SimplyTranslate
  //////////////////////////////////
  final lt = SimplyTranslator(EngineType.libre);

  ///using Libretranslate
  ///only text translation avaliable
  ///short form to only get translated text as String, also shorter code:
  String textResult3 = await lt.trSimply("Er läuft schnell.", "de", 'en');
  print(textResult3);
  //He walks fast.

  //........

  //////////////////////////////
  // Test functions
  //////////////////////////////

  ///get time it took to translate
  print(await st.speedTest(st.trSimply, "Er läuft schnell."));
  //558ms

  //////////////////////////////
  // TTS
  //////////////////////////////

  ///get "hello" as an Audio-Url
  ///uses always Google TTS as Libretranslate doesnt support TTS, gives same result
  ///you can use https://pub.dev/packages/audioplayers to play it
  print(st.getTTSUrlSimply("hello", "en"));
  //https://simplytranslate.org/api/tts/?engine=google&lang=en&text=hello
}

```

## Info
- Max char length for Japanese, Chinese, and Korean is around 1250. For other languages, it's around 5000 due to different encoding results.

## Credits
This package is based on [Gabriel Pacheco's google-translator](https://github.com/gabrielpacheco23/google-translator), distributed under the MIT License.

As Google has request limitations, [SimplyTranslate](https://simplytranslate.org/) provides a free and open-source alternative with Google Translation quality.