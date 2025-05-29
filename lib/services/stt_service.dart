import 'package:first_project/extensions/enum_extensions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';


// @@@@@@@@@@@@@@@@@@ ENUMS @@@@@@@@@@@@@@@@

// %%%%%%%%%%%%%%%%% TTS LANG %%%%%%%%%%%%%%
enum Languages {
    english,
    french
}
// %%%%%%%%%%%%%%%%% END - TTS LANG %%%%%%%%%%%%%%

// @@@@@@@@@@@@@@@@@@ END - ENUMS @@@@@@@@@@@@@@@@





// @@@@@@@@@@@@@@@@@@@@@ MAIN CLASS @@@@@@@@@@@@@@@@@@@@@@
class SttService {

    // %%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%
    static const String ttsPreferenceKey = "currentTtsLang";
    final SpeechToText _stt = SpeechToText();
    bool _isAvailable = false;
    bool get isAvailable => _isAvailable;
    bool get isListening => _stt.isListening;
    late DateTime _lastListeningStart;
    late Function(String) _onResultAction;
    String _beforeRestartSpeech = '';
    bool _hasStopped = true;
    bool _isLocked = true;
    // %%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%% INIT STT %%%%%%%%%%%%%%%
    Future<bool> init () async {
        var status = await Permission.microphone.request();
        if (!status.isGranted) return false;
        _isAvailable = await _stt.initialize();

        _stt.statusListener = (status) async {
            if (!_hasStopped && !_stt.isListening) {
                stopListening(isLocked: _isLocked);
                await Future.delayed(Duration(milliseconds: 300));
                _restartListeningIfTooEarlyCut();
            }
        };
        return _isAvailable;
    }
    // %%%%%%%%%%%%%%%%%%% END - INIT STT %%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%% RESTART LISTENING IF TOO EARLY CUT %%%%%%%%%%%
    void _restartListeningIfTooEarlyCut () {
        final now = DateTime.now();
        if (now.difference(_lastListeningStart).inSeconds < 5) {
            startListening(_onResultAction, beforeSpeech: _beforeRestartSpeech, isLocked: _isLocked);
        }
    }
    // %%%%%%%%%%%%%%%%%%% END - RESTART LISTENING IF TOO EARLY CUT %%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% START LISTENING %%%%%%%%%%%%%%%%%
    Future<void> startListening (Function(String) onResultAction, {String beforeSpeech = '', String afterSpeech = '', bool isLocked = false}) async {

        _isLocked = isLocked;
        if (!_isAvailable || _isLocked) return;
        final language = await retrieveTtsLanguage();
        final String languageCode;

        if (language == Languages.french.formattedName || language == Languages.french.name) {
            languageCode = 'fr-FR';
        } else {
            languageCode = 'en-US';
        }

        _hasStopped = false;
        _onResultAction = onResultAction;
        _lastListeningStart = DateTime.now();
        _stt.listen(
            localeId: languageCode,

            onResult: (result) {
                if (beforeSpeech.trim().isNotEmpty) beforeSpeech = "${beforeSpeech.trim()} ";
                if (afterSpeech.trim().isNotEmpty) " ${afterSpeech.trim()}";
                onResultAction(beforeSpeech + result.recognizedWords + afterSpeech);
                _beforeRestartSpeech = beforeSpeech + result.recognizedWords + afterSpeech;
            },

            pauseFor: Duration(seconds: 15),
            listenFor: Duration(minutes: 3),

            listenOptions: SpeechListenOptions(
                partialResults: true,
                cancelOnError: true,
                listenMode: ListenMode.dictation,
            )
        );
    }
    // %%%%%%%%%%%%%%%%%%%% END - START LISTENING %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% STOP LISTENING %%%%%%%%%%%%%%%%%
    void stopListening ({bool isLocked = true}) {
        _isLocked = isLocked ? true : false;
        _hasStopped = true;
        _stt.stop();
    } 
    // %%%%%%%%%%%%%%%%%%%% END - STOP LISTENING %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%% RETRIEVE CURRENT TTS LANGUAGE %%%%%%%%%%%%%%%%%%%
    static Future<String> retrieveTtsLanguage () async {
        final pref = await SharedPreferences.getInstance();
        return pref.getString(ttsPreferenceKey) ?? Languages.english.formattedName;
    }
    // %%%%%%%%%%%%%%%% END - RETRIEVE CURRENT TTS LANGUAGE %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% SAVE CURRENT TTS LANGUAGE %%%%%%%%%%%%%%%
    static Future<void> saveTtsLanguage (String lang) async {
        final pref = await SharedPreferences.getInstance();
        await pref.setString(ttsPreferenceKey, lang);
    }
    // %%%%%%%%%%%%%%%%%% END - SAVE CURRENT TTS LANGUAGE %%%%%%%%%%%%%%%

}
// @@@@@@@@@@@@@@@@@@@@@ MAIN CLASS @@@@@@@@@@@@@@@@@@@@@@