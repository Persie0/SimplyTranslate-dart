library simplytranslate;

import 'dart:async';
import 'dart:convert';
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
  var _baseUrlSimply =
      simplyInstances[Random().nextInt(simplyInstances.length)];
  var _baseUrlLingva =
      lingvaInstances[Random().nextInt(lingvaInstances.length)];

  final _pathSimply = '/api/translate/';

  final _languageList = LanguageList();

  EngineType engine;
  SimplyTranslator(this.engine);

  /// slow for text, Translates texts from specified language to another
  Future<Translation> translateSimply(String sourceText,
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
      'engine': engine.name,
      'from': from,
      'to': to,
      'text': sourceText
    };

    ///Uses default instance or set instance
    ///Uses random instance
    if (instanceMode == InstanceMode.Random) {
      _baseUrlSimply =
          simplyInstances[Random().nextInt(simplyInstances.length)];

      ///Loops through the instance list
    } else if (instanceMode == InstanceMode.Loop) {
      nextSimplyInstance();
    } else if (instanceMode == InstanceMode.Lazy) {
      //wait 2s
      await Future.delayed(const Duration(seconds: 2));
    } else if (instanceMode == InstanceMode.Lazy) {
      //wait 2s
      await Future.delayed(const Duration(seconds: 2));
    }
    Uri url;
    dynamic jsonData;
    http.ClientException exeption = http.ClientException("");
    for (int ret = 0; ret <= retries; ret++) {
      url = Uri.https(_baseUrlSimply, _pathSimply);
      final data = await http.post(url, body: parameters).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );

      if (data.statusCode != 200) {
        nextSimplyInstance();
        exeption = http.ClientException(
            'Error ${data.statusCode}:\n\n ${data.body}', url);
        continue;
      }

      jsonData = jsonDecode(data.body);
      if (jsonData == null) {
        nextSimplyInstance();
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
      List<Translations> translList = [];
      List<Definitions> defList = [];
      List<String> one = [];
      List<String> two = [];
      List<String> three = [];
      var types = translations.keys.toList();
      for (var type in translations.keys) {
        for (var word in translations[type].keys) {
          var words = translations[type][word]["words"] ?? [];
          words = words.cast<String>();
          var frequency = translations[type][word]["frequency"] ?? "";
          translList.add(Translations(type, word, frequency, words));
          if (frequency == "3/3") {
            three.add(word);
          } else if (frequency == "2/3") {
            two.add(word);
          } else {
            one.add(word);
          }
        }
      }
      List<String> frequencyTranslations = three + two + one;
      frequencyTranslations = frequencyTranslations.toSet().toList();
      for (var type in def.keys) {
        for (int i = 0; i < def[type].length; i++) {
          List<String> synonyms = [];
          List<String> informalSynonyms = [];
          List<String> archaicSynonyms = [];
          String definition = "";
          String useInSentence = "";
          String dictionary = "";
          var rawSyn = def[type][i]["synonyms"] ?? {};
          definition = def[type][i]["definition"] ?? "";
          useInSentence = def[type][i]["use-in-sentence"] ?? "";
          dictionary = def[type][i]["dictionary"] ?? "";
          useInSentence = def[type][i]["use-in-sentence"] ?? "";
          if (rawSyn.isNotEmpty) {
            synonyms = (def[type][i]["synonyms"][""] ?? []).cast<String>();
            informalSynonyms =
                (def[type][i]["synonyms"]["informal"] ?? []).cast<String>();
            archaicSynonyms =
                (def[type][i]["synonyms"]["archaic"] ?? []).cast<String>();
          }
          defList.add(Definitions(type, definition, synonyms, informalSynonyms,
              useInSentence, archaicSynonyms, dictionary));
        }
      }
      String translation =
          jsonData['translated-text'] ?? jsonData['translated_text'];
      trans = Result(translation, def, translations, translList, defList,
          frequencyTranslations, types);
    }

    ///should use Libre Translate
    else {
      String translation2 =
          jsonData['translated-text'] ?? jsonData['translated_text'];
      trans = Result(translation2, {}, {}, [], [], [], []);
    }

    return _Translation(
      trans,
      source: sourceText,
      sourceLanguage: _languageList[from],
      targetLanguage: _languageList[to],
    );
  }

  void nextSimplyInstance() {
    var index = simplyInstances.indexOf(_baseUrlSimply);
    if (index == simplyInstances.length - 1) {
      index = 0;
    } else {
      index += 1;
    }
    _baseUrlSimply = simplyInstances[index];
  }

  void nextLingvaInstance() {
    var index = lingvaInstances.indexOf(_baseUrlLingva);
    if (index == lingvaInstances.length - 1) {
      index = 0;
    } else {
      index += 1;
    }
    _baseUrlLingva = lingvaInstances[index];
  }

  ///get the TTSUrl of given input
  String getTTSUrlSimply(String sourceText, String lang) {
    if (!LanguageList.contains(lang)) {
      throw LanguageNotSupportedException(lang);
    }
    var _baseUrl = 'simplytranslate.org';
    final _path = '/api/tts/';
    final parameters = {'engine': "google", 'lang': lang, 'text': sourceText};

    String url = Uri.https(_baseUrl, _path, parameters).toString();
    return url;
  }

  ///return the text audio as a Uint8Array (served as number[] in JSON)
  Future<List<int>> getTTSLingva(String text, String lang) async {
    Uri url;
    dynamic jsonData;
    url = Uri.parse(
        "https://" + _baseUrlLingva + "/api/v1/audio/" + lang + "/" + text);
    nextLingvaInstance();
    final data = await http.get(url).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    );
    if (data.statusCode != 200) {
      throw http.ClientException(
          'Error ${data.statusCode}:\n\n ${data.body}', url);
    }

    jsonData = jsonDecode(data.body);
    if (jsonData == null) {
      throw http.ClientException('Error: Can\'t parse json data');
    }
    return jsonData['audio'].cast<int>();
  }

  ///get long text translation with GQL
  Future<String> trLingvaGraphQL(String sourceText,
      [String? from, String? to]) async {
    var url = Uri.parse("https://$_baseUrlLingva/api/graphql");
    var graphqlQuery = {
      "query":
          'query {translation(source:"$from" target:"$to" query:"$sourceText") {target {text}}}',
    };
    var en = jsonEncode(graphqlQuery);
    final data = await http.post(url, body: en).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    );
    if (data.statusCode != 200) {
      throw http.ClientException('Error ${data.statusCode}: ${data.body}', url);
    }

    var jsonData = jsonDecode(
      utf8.decode(data.body.runes.toList()),
    );
    if (jsonData == null) {
      throw http.ClientException('Error: Can\'t parse json data');
    }
    var res = "";
    if (jsonData["errors"] != null) {
      throw http.ClientException(
          'Error:\n\n ${jsonData["errors"][0]["message"]}');
    } else {
      res = jsonData["data"]["translation"]["target"]["text"];
    }
    return res;
  }

  ///slow simply for sentence
  Future<String> trSimply(String sourceText, [String? from, String? to]) async {
    final parameters = {
      'engine': engine.name,
      'from': from ?? "auto",
      'to': to ?? "en",
      'text': sourceText
    };
    nextSimplyInstance();
    Uri url;
    dynamic jsonData;
    url = Uri.https(_baseUrlSimply, _pathSimply);
    final data = await http.post(url, body: parameters).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    );
    if (data.statusCode != 200) {
      throw http.ClientException(
          'Error ${data.statusCode}:\n\n ${data.body}', url);
    }

    jsonData = jsonDecode(data.body);
    if (jsonData == null) {
      throw http.ClientException('Error: Can\'t parse json data');
    }
    if (jsonData['translated-text'] == null) {
      return jsonData['translated_text'];
    }
    return jsonData['translated-text'];
  }

  /// Sets base URL to other instances:
  set setSimplyInstance(String url) => _baseUrlSimply = url;

  /// Sets base URL to other instances:
  set setLingvaInstance(String url) => _baseUrlLingva = url;

  ///get the instances
  get getSimplyInstances => simplyInstances;

  ///get the instances
  get getLingvaInstances => lingvaInstances;

  ///get the currently used instance
  get getCurrentSimplyInstance => _baseUrlSimply;
  get getCurrentLingvaInstance => _baseUrlLingva;

  ///check if the passed instance is working
  Future<bool> isSimplyInstanceWorking(String urlValue) async {
    Uri url;
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

/*  ///update the instances with the API
  Future<bool> updateSimplyInstances(
      {List<String> blacklist = const ["tl.vern.cc"]}) async {
    try {
      final response = await http
          .get(Uri.parse('https://simple-web.org/instances/simplytranslate'));
      List<String> newInstances = [];
      response.body
          .trim()
          .split('\n')
          .forEach((element) => newInstances.add(element));
      for (var element in blacklist) {
        newInstances.remove(element);
      }
      simplyInstances = newInstances;
      return true;
    } catch (error) {
      return false;
    }
  }*/

  ///fetch working Lingva and Simply instances from the API (not always up to date)
  Future<bool> fetchInstances() async {
    final url = "https://simplytranslate-api-tester.vercel.app/getWorkingInstances";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON data here
        final jsonData = jsonDecode(response.body);

        simplyInstances = jsonData["workingInstance"]["simply"].cast<String>();
        lingvaInstances = jsonData["workingInstance"]["lingva"].cast<String>();

        //remove https:// and / at the end for simplyInstances
        for (int i = 0; i < simplyInstances.length; i++) {
          simplyInstances[i] = simplyInstances[i].replaceAll("https://", "");
          if (simplyInstances[i].endsWith("/")) {
            simplyInstances[i] =
                simplyInstances[i].substring(0, simplyInstances[i].length - 1);
          }
        }

        //remove https:// and / at the end for lingvaInstances
        for (int i = 0; i < lingvaInstances.length; i++) {
          lingvaInstances[i] = lingvaInstances[i].replaceAll("https://", "");
          if (lingvaInstances[i].endsWith("/")) {
            lingvaInstances[i] =
                lingvaInstances[i].substring(0, lingvaInstances[i].length - 1);
          }
        }

        return true;
      } else {
        // If the server did not return a 200 OK response, handle the error here
        print("Failed to fetch data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // Handle any exceptions that occur during the HTTP request
      print("Error: $e");
    }
    return false;
  }

  ///slow translate with Lingva for text
  Future<String> trLingva(String sourceText,
      [String? from, String? to, bool? wait2s]) async {
    from = from ?? "auto";
    to = to ?? "en";
    Uri url;
    dynamic jsonData;

    url = Uri.parse("https://" +
        _baseUrlLingva +
        "/api/v1/" +
        from +
        "/" +
        to +
        "/" +
        sourceText);
    if (wait2s == true) {
      //wait 2s
      await Future.delayed(const Duration(seconds: 2));
    } else {
      nextLingvaInstance();
    }
    final data = await http.get(url).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    );
    if (data.statusCode != 200) {
      throw http.ClientException(
          'Error ${data.statusCode}:\n\n ${data.body}', url);
    }

    jsonData = jsonDecode(data.body);
    if (jsonData == null) {
      throw http.ClientException('Error: Can\'t parse json data');
    }
    return jsonData['translation'];
  }

  ///get many single word translations, slow
  Future<List<String>> translateLingvaGQL(
    String sourceText, [
    String? from,
    String? to,
    InstanceMode instanceMode = InstanceMode.Lazy,
  ]) async {
    from = from ?? "auto";
    to = to ?? "en";
    var url = Uri.parse("https://$_baseUrlLingva/api/graphql");
    var graphqlQuery = {
      "query":
          'query {translation(source:"$from" target:"$to" query:"$sourceText") {target {text extraTranslations{list{word article frequency meanings}} }}}',
    };
    var en = jsonEncode(graphqlQuery);
    //wait 2s
    if (instanceMode == InstanceMode.Lazy) {
      await Future.delayed(const Duration(seconds: 2));
    }
    final data = await http.post(url, body: en).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    );
    if (data.statusCode != 200) {
      throw http.ClientException('Error ${data.statusCode}: ${data.body}', url);
    }

    var jsonData = jsonDecode(
      utf8.decode(data.body.runes.toList()),
    );
    if (jsonData == null) {
      throw http.ClientException('Error: Can\'t parse json data');
    }
    var res = jsonData["data"]["translation"]["target"];
    List frequencyTranslations = [];
    if (jsonData["errors"] != null) {
      throw http.ClientException(
          'Error:\n\n ${jsonData["errors"][0]["message"]}');
    } else {
      if (res["extraTranslations"] != null &&
          res["extraTranslations"] != "null") // "null"
      {
        frequencyTranslations = res["extraTranslations"];
      }
    }
//continue
    /*Map info = jsonData['info'] ?? {};*/
    if (frequencyTranslations.isNotEmpty) {
      /*List extraTransl = info["extraTranslations"] ?? [];*/
      if (frequencyTranslations.isNotEmpty) {
        List<String> one = [];
        List<String> two = [];
        List<String> three = [];
        for (int i = 0; i < frequencyTranslations.length; i++) {
          for (int t = 0; t < frequencyTranslations[i]["list"].length; t++) {
            String word = frequencyTranslations[i]["list"][t]["word"];
            int frequency = frequencyTranslations[i]["list"][t]["frequency"];
            if (frequency == 3) {
              three.add(word);
            } else if (frequency == 2) {
              two.add(word);
            } else {
              one.add(word);
            }
          }
        }
        frequencyTranslations = three + two + one;
      } else {
        frequencyTranslations.add(jsonData['translation']);
      }
    } else {
      frequencyTranslations.add(jsonData['translation']);
    }
    if (frequencyTranslations[0] == null ||
        frequencyTranslations[0] == "null") {
      frequencyTranslations = [];
    }
    return frequencyTranslations.cast<String>().toSet().toList();
  }

  ///translate with Lingva, get single translations as List
  Future<List<String>> translateLingva(
    String sourceText, [
    String? from,
    String? to,
    InstanceMode instanceMode = InstanceMode.Lazy,
  ]) async {
    from = from ?? "auto";
    to = to ?? "en";
    Uri url;
    dynamic jsonData;
    url = Uri.parse("https://" +
        _baseUrlLingva +
        "/api/v1/" +
        from +
        "/" +
        to +
        "/" +
        sourceText);

    if (instanceMode == InstanceMode.Lazy) {
      //wait 2s
      await Future.delayed(const Duration(seconds: 2));
    } else {
      nextLingvaInstance();
    }
    final data = await http.get(url).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    );
    if (data.statusCode != 200) {
      throw http.ClientException(
          'Error ${data.statusCode}:\n\n ${data.body}', url);
    }

    jsonData = jsonDecode(data.body);
    if (jsonData == null) {
      throw http.ClientException('Error: Can\'t parse json data');
    }
    List<String> frequencyTranslations = [];
    Map info = jsonData['info'] ?? {};
    if (info.isNotEmpty) {
      List extraTransl = info["extraTranslations"] ?? [];
      if (extraTransl.isNotEmpty) {
        List<String> one = [];
        List<String> two = [];
        List<String> three = [];
        for (int i = 0; i < extraTransl.length; i++) {
          for (int t = 0; t < extraTransl[i]["list"].length; t++) {
            String word = extraTransl[i]["list"][t]["word"];
            int frequency = extraTransl[i]["list"][t]["frequency"];
            if (frequency == 3) {
              three.add(word);
            } else if (frequency == 2) {
              two.add(word);
            } else {
              one.add(word);
            }
          }
        }
        frequencyTranslations = three + two + one;
      } else {
        frequencyTranslations.add(jsonData['translation']);
      }
    } else {
      frequencyTranslations.add(jsonData['translation']);
    }
    return frequencyTranslations.toSet().toList();
  }

  ///test the speed of the translation
  Future<String> speedTest(Function function,
      [String? sourceText, String? from, String? to]) async {
    sourceText = sourceText ?? "Hallo";
    from = from ?? "auto";
    to = to ?? "en";
    Stopwatch stopwatch = new Stopwatch()..start();
    await function(sourceText, from, to);
    return stopwatch.elapsed.inMilliseconds.toString() + "ms";
  }
}

///list with instances
List<String> simplyInstances = [
  "simplytranslate.org",
  "translate.birdcat.cafe",
  "simplytranslate.pussthecat.org"
];
List<String> lingvaInstances = ["translate.plausibility.cloud", "lingva.ml"];

///Translation engines
enum EngineType {
  /// googletranslate
  google,

  /// libretranslate
  libre,
}

///behaviour of what Instance should be used with the next translation
/// Defines the behavior of instance selection for translation requests.
enum InstanceMode {
  /// Selects an instance randomly for each translation request.
  Random,

  /// Iterates through the instances in a loop for each translation request.
  Loop,

  /// Uses the same instance for all translation requests.
  Same,

  /// Delays the translation request by 2 seconds before proceeding.
  Lazy
}
