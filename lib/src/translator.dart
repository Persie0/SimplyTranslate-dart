library simplytranslate;

import 'dart:async';
import 'dart:convert' show jsonDecode;
import 'package:http/http.dart' as http;
import './langs/language.dart';

part './model/translation.dart';

///
/// This library is a Dart implementation of Simplytranslate API
///
/// [author] Marvin Perzi.
///
class SimplyTranslator {
  var _baseUrl = 'simplytranslate.org'; /// faster than translate.google.com
  final _path = '/api/translate/';
  final _languageList = LanguageList();

  EngineType engine;
  SimplyTranslator(this.engine);

  /// Translates texts from specified language to another
  Future<Translation> translate(String sourceText,
      {String from = 'auto', String to = 'en'}) async {
    for (var each in [from, to]) {
      if (!LanguageList.contains(each)) {
        throw LanguageNotSupportedException(each);
      }
    }

    final parameters = {
      'engine': engine.toString().replaceAll("EngineType.", ""),
      'from': from,
      'to': to,
      'text': sourceText
    };

    var url = Uri.https(_baseUrl, _path, parameters);
    final data = await http.get(url);

    if (data.statusCode != 200) {
      throw http.ClientException(
          'Error ${data.statusCode}:\n\n ${data.body}', url);
    }

    final jsonData = jsonDecode(data.body);
    if (jsonData == null) {
      throw http.ClientException('Error: Can\'t parse json data');
    }
    final Result trans;
    ///should use Google Translate
    if (engine == EngineType.google) {
      var def = Map<String, dynamic>.from(jsonData['definitions'] ?? {});
      var translations =
          Map<String, dynamic>.from(jsonData['translations'] ?? {});
      trans = Result(jsonData['translated-text'], def, translations);
    }
    ///should use Libre Translate
    else {
      trans = Result(jsonData['translated-text'], Map(), Map());
    }
    if (from == 'auto' && from != to) {
      from = jsonData[2] ?? from;
      if (from == to) {
        from = 'auto';
      }
    }

    return _Translation(
      trans,
      source: sourceText,
      sourceLanguage: _languageList[from],
      targetLanguage: _languageList[to],
    );
  }

  ///get the TTSUrl of give input
  String getTTSUrl(String sourceText, String lang) {
    if (!LanguageList.contains(lang)) {
      throw LanguageNotSupportedException(lang);
    }
    var _baseUrl = 'simplytranslate.org';
    final _path = '/api/tts/';
    final parameters = {'engine': "google", 'lang': lang, 'text': sourceText};

    String url = Uri.https(_baseUrl, _path, parameters).toString();
    return url;
  }

  Future<String> tr(String sourceText,
      [String? from, String? to]) async {
    return (await translate(sourceText, from: from??"auto", to: to??"en")).translations.text;

  }

  /// Sets base URL to other instances:
  ///https:///simple-web.org/projects/simplytranslate.html
  set baseUrl(String url) => _baseUrl = url;
}

enum EngineType {
  google, /// googletranslate
  libre, /// libretranslate
}

enum Mode {
  tts, /// TTS of word
  text, /// text translation
}
