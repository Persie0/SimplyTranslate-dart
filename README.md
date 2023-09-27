# SimplyTranslate-dart

[GitHub](https://github.com/Persie0/SimplyTranslate-dart) | [Pub](https://pub.dev/packages/simplytranslate)

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/marvinperzi#)

<a href="https://paypal.me/marvinperzi?country.x=AT&locale.x=de_DE"><img src="https://github.com/andreostrovsky/donate-with-paypal/raw/master/blue.svg" height="36"></a>

## Usage 

As I can't always update the instance list (simplytranslate instances are run by volunteers):
- Search for new instances by simply googling "simplytranslate" and set the instance with setInstance = "instance"
- You could update the instances before with a function but the Codeberg project of the original devs is not reachable anymore

```dart

import 'package:simplytranslate/simplytranslate.dart';

void main() async {
  ///use Google Translate
  final gt = SimplyTranslator(EngineType.google);

  ///if you do not specify the source language it is automatically selecting it depending on the text
  ///if you do not specify the target language it is automatically English

  ///get "hello" as an Audio-Url
  ///uses always Google TTS as Libretranslate doesnt support TTS, gives same result
  ///you can use https://pub.dev/packages/audioplayers to play it
  print(gt.getTTSUrl("hello", "en"));
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
```

## Info
- Max char length for Japanese, Chinese, and Korean is 1250. For other languages, it's 5000 due to different encoding results.

## Credits
This package is based on [Gabriel Pacheco's google-translator](https://github.com/gabrielpacheco23/google-translator), distributed under the MIT License.

As Google has request limitations, [SimplyTranslate](https://simplytranslate.org/) provides a free and open-source alternative with Google Translation quality.

## Simplytranslate API docs
[Simplytranslate API docs](https://git.sr.ht/~metalune/simplytranslate_web/tree/HEAD/api.md)
