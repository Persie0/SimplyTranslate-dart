# SimplyTranslate-dart

[GitHub](https://github.com/Persie0/SimplyTranslate-dart) | [Pub](https://pub.dev/packages/simplytranslate)

## Project info
A Dart package to translate text using SimplyTranslate, Lingva Translate, and LibreTranslate. 

TTS is also supported.

[SimplyTranslate](https://codeberg.org/ManeraKai/simplytranslate) and [Lingva Translate](https://github.com/thedaviddelta/lingva-translate) are free and open-source alternatives to Google Translate (that make use of Google Translate under the hood).

[LibreTranslate](https://github.com/LibreTranslate/LibreTranslate) is a free and open-source alternative to Google Translate that uses a open-source translation engine.
## Not working? 

As I can't always update the instance list (instances are run by volunteers and can be turned off at any time), do one of the following:
- fetch the working instances via `fetchInstances` (look at example code, corresponding project is [here](https://github.com/Persie0/simplytranslate_api_tester))
- Search for new instances by googling "simplytranslate" or "lingva translate" and set the instance with setInstance = "instance"
- lingva instances can also be found [here](https://github.com/thedaviddelta/lingva-translate?tab=readme-ov-file#instances)

## Import
```dart
import 'package:simplytranslate/simplytranslate.dart';
```

## Usage
[Example code](https://pub.dev/packages/simplytranslate/example)

## Limitations
- Max char length per request for Japanese, Chinese, and Korean is around 1250. For other languages, it's around 5000 due to different encoding results.

## Apps using SimplyTranslate
- [Pareader](https://play.google.com/store/apps/details?id=at.austriao.pareader) - Learn languages with news articles in multiple languages and translate words with a simple tap.

## Buy me a coffee

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/marvinperzi#)

<a href="https://paypal.me/persie0"><img src="https://github.com/andreostrovsky/donate-with-paypal/raw/master/blue.svg" height="36"></a>


## Credits
This package is based on [Gabriel Pacheco's google-translator](https://github.com/gabrielpacheco23/google-translator), distributed under the MIT License.

As Google has request limitations, [SimplyTranslate](https://simplytranslate.org/) provides a free and open-source alternative with Google Translation quality.