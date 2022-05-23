library simplytranslate;

import 'dart:async';
import 'dart:convert' show jsonDecode;
import 'dart:math';
import 'package:http/http.dart' as http;
import './langs/language.dart';

part './model/translation.dart';

///
/// This library is a Dart implementation of Simplytranslate API
///
/// [author] Marvin Perzi.
///
class SimplyTranslator {
  var _baseUrl = instances[Random().nextInt(instances.length)];

  /// faster than translate.google.com
  final _path = '/api/translate/';
  final _languageList = LanguageList();

  EngineType engine;
  SimplyTranslator(this.engine);

  /// Translates texts from specified language to another
  Future<Translation> translate(String sourceText,
      {String from = 'auto',
      String to = 'en',
      InstanceMode instanceMode = InstanceMode.Loop,
      int retries = 1}) async {
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

    ///Uses default instance or set instance
    ///Uses random instance
    if (instanceMode == InstanceMode.Random) {
      _baseUrl = instances[Random().nextInt(instances.length)];

      ///Loops through the instance list
    } else if (instanceMode == InstanceMode.Loop) {
      next_instance();
    }
    var url;
    dynamic jsonData;
    var exeption;
    for (int ret = 0; ret <= retries; ret++) {
      url = Uri.https(_baseUrl, _path, parameters);
      final data = await http.post(url, body: parameters);

      if (data.statusCode != 200) {
        next_instance();
        exeption = http.ClientException(
            'Error ${data.statusCode}:\n\n ${data.body}', url);
        continue;
      }

      jsonData = jsonDecode(data.body);
      if (jsonData == null) {
        next_instance();
        exeption = http.ClientException('Error: Can\'t parse json data');
        continue;
      }
      if ((data.statusCode == 200) && (jsonData != null)) {
        break;
      }
      if (ret == retries) {
        throw exeption;
      }
    }

    /// final Result trans;
    var trans = Result("text", {}, {}, [], [], [], []);

    ///should use Google Translate
    if (engine == EngineType.google) {
      var def = Map<String, dynamic>.from(jsonData['definitions'] ?? {});
      var translations =
          Map<String, dynamic>.from(jsonData['translations'] ?? {});
      List<Translations> transl_list = [];
      List<Definitions> def_list = [];
      List<String> one = [];
      List<String> two = [];
      List<String> three = [];
      var types = translations.keys.toList();
      for (var type in translations.keys) {
        for (var word in translations[type].keys) {
          var words = translations[type][word]["words"] ?? [];
          words = words.cast<String>();
          var frequency = translations[type][word]["frequency"] ?? "";
          transl_list.add(Translations(type, word, frequency, words));
          if (frequency == "3/3") {
            three.add(word);
          } else if (frequency == "2/3") {
            two.add(word);
          } else {
            one.add(word);
          }
        }
      }
      List<String> frequency_translations = three + two + one;
      for (var type in def.keys) {
        for (int i = 0; i < def[type].length; i++) {
          List<String> synonyms = [];
          List<String> informal_synonyms = [];
          List<String> archaic_synonyms = [];
          String definition = "";
          String use_in_sentence = "";
          String dictionary = "";
          var raw_syn = def[type][i]["synonyms"] ?? {};
          definition = def[type][i]["definition"] ?? "";
          use_in_sentence = def[type][i]["use-in-sentence"] ?? "";
          dictionary = def[type][i]["dictionary"] ?? "";
          use_in_sentence = def[type][i]["use-in-sentence"] ?? "";
          if (raw_syn.isNotEmpty) {
            synonyms = (def[type][i]["synonyms"][""] ?? []).cast<String>();
            informal_synonyms =
                (def[type][i]["synonyms"]["informal"] ?? []).cast<String>();
            archaic_synonyms =
                (def[type][i]["synonyms"]["archaic"] ?? []).cast<String>();
          }
          def_list.add(Definitions(
              type,
              definition,
              synonyms,
              informal_synonyms,
              use_in_sentence,
              archaic_synonyms,
              dictionary));
        }
      }
      trans = Result(jsonData['translated-text'], def, translations,
          transl_list, def_list, frequency_translations, types);
    }

    ///should use Libre Translate
    else {
      trans = Result(jsonData['translated-text'], {}, {}, [], [], [], []);
    }

    return _Translation(
      trans,
      source: sourceText,
      sourceLanguage: _languageList[from],
      targetLanguage: _languageList[to],
    );
  }

  void next_instance() {
    var index = instances.indexOf(_baseUrl);
    if (index == instances.length - 1) {
      index = 0;
    } else {
      index += 1;
    }
    _baseUrl = instances[index];
  }

  ///get the TTSUrl of given input
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

  Future<String> tr(String sourceText, [String? from, String? to]) async {
    return (await translate(sourceText, from: from ?? "auto", to: to ?? "en"))
        .translations
        .text;
  }

  /// Sets base URL to other instances:
  ///https:///simple-web.org/projects/simplytranslate.html
  set set_Instance(String url) => _baseUrl = url;

  ///get the instances
  get get_Instances => instances;

  ///get the currently used instance
  get get_current_Instance => _baseUrl;

  ///check if the passed instance is working
  Future<bool> is_instance_Working(String urlValue) async {
    var url;
    try {
      url = Uri.parse("https://$urlValue");
    } catch (err) {
      print(err);
      return false;
    }
    try {
      final response = await http
          .get(Uri.parse('$url/api/translate?from=en&to=es&text=hello'));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }

  ///update the instances with the API
  Future<bool> update_Instances(
      {List<String> blacklist = const ["tl.vern.cc"]}) async {
    try {
      final response = await http
          .get(Uri.parse('https://simple-web.org/instances/simplytranslate'));
      List<String> newInstances = [];
      response.body
          .trim()
          .split('\n')
          .forEach((element) => newInstances.add(element));
      blacklist.forEach((element) {
        newInstances.remove(element);
      });
      instances = newInstances;
      return true;
    } catch (error) {
      return false;
    }
  }
}

///list with instances
List<String> instances = [
  "simplytranslate.org",
  "st.tokhmi.xyz",
  "translate.josias.dev",
  "translate.namazso.eu",
  "translate.riverside.rocks",
  "st.manerakai.com",
  "translate.bus-hit.me",
  "simplytranslate.pussthecat.org",
  "translate.northboot.xyz",
  "translate.tiekoetter.com",
  "simplytranslate.esmailelbob.xyz",
  "translate.syncpundit.com",
  // "tl.vern.cc",
  "translate.slipfox.xyz"
];

///Translation engines
enum EngineType {
  google,

  /// googletranslate
  libre,

  /// libretranslate
}

///mode
enum Mode {
  /// TTS of word
  tts,

  /// text translation
  text,
}

///behaviour of what Instance should be used with the next translation
enum InstanceMode { Random, Loop, Same }
