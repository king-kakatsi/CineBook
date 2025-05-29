import 'package:first_project/extensions/enum_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// @@@@@@@@@@@@@@@@@@ ENUMS @@@@@@@@@@@@@@@@

// %%%%%%%%%%%%%%%%% TTS LANG %%%%%%%%%%%%%%
enum Languages {
    english,
    french
}
// %%%%%%%%%%%%%%%%% END - TTS LANG %%%%%%%%%%%%%%

// @@@@@@@@@@@@@@@@@@ END - ENUMS @@@@@@@@@@@@@@@@




// @@@@@@@@@@@@@@@@@@@@@ TTS SERVICE @@@@@@@@@@@@@@@@@@@

class TtsService {
    
    // %%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%
    /// Contains the key to get or set from sharedPreference
    static const String ttsPreferenceKey = "currentTtsLang";
    final FlutterTts _tts = FlutterTts();
    final VoidCallback? onStart;
    final VoidCallback? onCompletion;
    final VoidCallback? onCancel;
    // %%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%%
    TtsService ({
        this.onStart,
        this.onCompletion,
        this.onCancel,
    }) {
        _tts.setSpeechRate(.62);
        _tts.setPitch(1.2);
        _tts.setVolume(1.0);
        if (onStart != null) _tts.setStartHandler(onStart!);
        if (onCompletion != null) _tts.setCompletionHandler(onCompletion!);
        if (onCancel != null) _tts.setCancelHandler(onCancel!);
    }
    // %%%%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%%




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




    // %%%%%%%%%%%%%%%%%%%%%% SET TTS LANGUAGE %%%%%%%%%%%%%%%%%
    Future<void> setTtsLanguage ({String? language}) async {
        try{
            if (language != null && language.trim().isNotEmpty) {
                await _tts.setLanguage(language);
                return;
            } 

            language = await retrieveTtsLanguage();
            if (language == Languages.french.formattedName || language == Languages.french.name) {
                await _tts.setLanguage('fr-FR');

            } else {
                await _tts.setLanguage('en-US');
            }
        } catch (_) {}
    }
    // %%%%%%%%%%%%%%%%%%%%%% END - SET TTS LANGUAGE %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% READ %%%%%%%%%%%%%%%%%
    Future<void> read (String text) async {
        await setTtsLanguage();
        if (text.trim().isEmpty) return;
        try{
            await _tts.stop();
            await _tts.speak(text);
        } catch (_) {}
    }
    // %%%%%%%%%%%%%%%%%% END - READ %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%% STOP %%%%%%%%%%%%%%%%%%
    Future<void> stop () async {
        await _tts.stop();
    }
    // %%%%%%%%%%%%%%%% END - STOP %%%%%%%%%%%%%%%%%%

}
// @@@@@@@@@@@@@@@@@@@@@ END - TTS SERVICE @@@@@@@@@@@@@@@@@@@