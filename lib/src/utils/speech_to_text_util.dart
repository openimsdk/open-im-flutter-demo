// import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:speech_to_text/speech_to_text.dart';
//
// class SpeechToTextUtil {
//   final SpeechToText _speechToText = SpeechToText();
//   bool _speechEnabled = false;
//
//   /// This has to happen only once per app
//   initSpeech() async {
//     return _speechEnabled = await _speechToText.initialize();
//   }
//
//   /// Each time to start a speech recognition session
//   void startListening(Function(SpeechRecognitionResult result) onResult) async {
//     if (_speechEnabled) {
//       // var locales = await _speechToText.locales();
//       await _speechToText.listen(
//         onResult: onResult,
//         localeId: 'zh-CN', //en-US
//       );
//     }
//   }
//
//   /// Manually stop the active speech recognition session
//   /// Note that there are also timeouts that each platform enforces
//   /// and the SpeechToText plugin supports setting timeouts on the
//   /// listen method.
//   void stopListening() async {
//     if (_speechEnabled) {
//       await _speechToText.stop();
//     }
//   }
//
//   /// This is the callback that the SpeechToText plugin calls when
//   /// the platform returns recognized words.
//   void _onSpeechResult(SpeechRecognitionResult result) {}
//
//   SpeechToTextUtil._();
//
//   static final SpeechToTextUtil instance = SpeechToTextUtil._();
// }
