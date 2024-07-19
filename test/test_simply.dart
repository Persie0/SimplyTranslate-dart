import 'package:test/test.dart';
import 'package:simplytranslate/simplytranslate.dart';

void main() {
  group('SimplyTranslator Tests', () {
    final st = SimplyTranslator(EngineType.google);

    setUp(() async {
      // Set up the instance before each test
      st.setSimplyInstance = "simplytranslate.pussthecat.org";
    });

    test('Fetch instances', () async {
      var instances = await st.fetchInstances();
      expect(instances, isTrue);
    });

    test('Get simply instances', () {
      var instances = st.getSimplyInstances;
      expect(instances, contains(st.getCurrentSimplyInstance));
    });

    test('Check if current instance is working', () async {
      var isWorking =
          await st.isSimplyInstanceWorking(st.getCurrentSimplyInstance);
      expect(isWorking, isTrue);
    });

    test('Check if current Lingva instance is working', () async {
      var isWorking =
          await st.isLingvaInstanceWorking(st.getCurrentLingvaInstance);
      expect(isWorking, isTrue);
    });

    test('Translate text (short form)', () async {
      String textResult = await st.trSimply("Er läuft schnell.", "de", 'en');
      expect(textResult, equals("He walks fast."));
    });

    test('Translate text (long form)', () async {
      var stTransl = await st.translateSimply(
        "Very difficult.",
        from: 'en',
        to: 'de',
        instanceMode: InstanceMode.Loop,
        retries: 4,
      );
      expect(stTransl.translations.text, equals("Sehr schwierig."));
    });

    test('Get multiple word translations', () async {
      var stTransl =
          await st.translateSimply("exuberance", from: 'en', to: 'de');
      expect(stTransl.translations.rawTranslations.toString().toLowerCase(),
          contains('ausgelassenheit'));
    });

    test('Get multiple word definitions', () async {
      var stTransl =
          await st.translateSimply("exuberance", from: 'en', to: 'de');
      expect(stTransl.translations.rawDefinitions.toString().toLowerCase(),
          contains('definition'));
    });

    test('Speed test', () async {
      var speed = await st.speedTest(st.trSimply, "Er läuft schnell.");
      expect(speed, isNotNull);
    });

    test('Get TTS URL', () {
      var ttsUrl = st.getTTSUrlSimply("hello", "en");
      expect(
          ttsUrl,
          contains(
              "https://simplytranslate.org/api/tts/?engine=google&lang=en&text=hello"));
    });
  });
}
