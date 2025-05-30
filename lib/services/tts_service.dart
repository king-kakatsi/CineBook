import 'package:first_project/extensions/enum_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// @@@@@@@@@@@@@@@@@@ ENUMS @@@@@@@@@@@@@@@@

// %%%%%%%%%%%%%%%%%%%%%%%% TTS LANG %%%%%%%%%%%%%%%%%%%%%%%%
/// 𝐄𝐧𝐮𝐦 𝐝𝐞𝐟𝐢𝐧𝐢𝐧𝐠 𝐚𝐯𝐚𝐢𝐥𝐚𝐛𝐥𝐞 𝐓𝐓𝐒 𝐥𝐚𝐧𝐠𝐮𝐚𝐠𝐞𝐬 𝐟𝐨𝐫 𝐭𝐡𝐞 𝐚𝐩𝐩𝐥𝐢𝐜𝐚𝐭𝐢𝐨𝐧.
///
/// Contains all supported languages for Text-to-Speech functionality.
/// Used in conjunction with enum extensions to get formatted names.
///
/// Available languages:
/// - `english` : English language support (en-US)
/// - `french` : French language support (fr-FR)
enum Languages {
    english,
    french
}
// %%%%%%%%%%%%%%%%%%%%%%%% END - TTS LANG %%%%%%%%%%%%%%%%%%%%%%%%

// @@@@@@@@@@@@@@@@@@ END - ENUMS @@@@@@@@@@@@@@@@




// @@@@@@@@@@@@@@@@@@@@@ TTS SERVICE @@@@@@@@@@@@@@@@@@@

/// 𝐒𝐞𝐫𝐯𝐢𝐜𝐞 𝐜𝐥𝐚𝐬𝐬 𝐟𝐨𝐫 𝐡𝐚𝐧𝐝𝐥𝐢𝐧𝐠 𝐓𝐞𝐱𝐭-𝐭𝐨-𝐒𝐩𝐞𝐞𝐜𝐡 𝐟𝐮𝐧𝐜𝐭𝐢𝐨𝐧𝐚𝐥𝐢𝐭𝐲.
///
/// This service provides a comprehensive wrapper around Flutter TTS functionality,
/// managing language preferences, speech settings, and callback handlers.
/// It persists language preferences using SharedPreferences and supports
/// English and French languages with customizable speech parameters.
class TtsService {
    
    // %%%%%%%%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%%
    /// 𝐊𝐞𝐲 𝐮𝐬𝐞𝐝 𝐟𝐨𝐫 𝐬𝐭𝐨𝐫𝐢𝐧𝐠 𝐓𝐓𝐒 𝐥𝐚𝐧𝐠𝐮𝐚𝐠𝐞 𝐩𝐫𝐞𝐟𝐞𝐫𝐞𝐧𝐜𝐞 𝐢𝐧 𝐒𝐡𝐚𝐫𝐞𝐝𝐏𝐫𝐞𝐟𝐞𝐫𝐞𝐧𝐜𝐞𝐬.
    static const String ttsPreferenceKey = "currentTtsLang";
    
    /// 𝐅𝐥𝐮𝐭𝐭𝐞𝐫 𝐓𝐓𝐒 𝐢𝐧𝐬𝐭𝐚𝐧𝐜𝐞 𝐟𝐨𝐫 𝐡𝐚𝐧𝐝𝐥𝐢𝐧𝐠 𝐬𝐩𝐞𝐞𝐜𝐡 𝐨𝐩𝐞𝐫𝐚𝐭𝐢𝐨𝐧𝐬.
    final FlutterTts _tts = FlutterTts();
    
    /// 𝐂𝐚𝐥𝐥𝐛𝐚𝐜𝐤 𝐞𝐱𝐞𝐜𝐮𝐭𝐞𝐝 𝐰𝐡𝐞𝐧 𝐓𝐓𝐒 𝐬𝐭𝐚𝐫𝐭𝐬 𝐬𝐩𝐞𝐚𝐤𝐢𝐧𝐠.
    final VoidCallback? onStart;
    
    /// 𝐂𝐚𝐥𝐥𝐛𝐚𝐜𝐤 𝐞𝐱𝐞𝐜𝐮𝐭𝐞𝐝 𝐰𝐡𝐞𝐧 𝐓𝐓𝐒 𝐜𝐨𝐦𝐩𝐥𝐞𝐭𝐞𝐬 𝐬𝐩𝐞𝐚𝐤𝐢𝐧𝐠.
    final VoidCallback? onCompletion;
    
    /// 𝐂𝐚𝐥𝐥𝐛𝐚𝐜𝐤 𝐞𝐱𝐞𝐜𝐮𝐭𝐞𝐝 𝐰𝐡𝐞𝐧 𝐓𝐓𝐒 𝐢𝐬 𝐜𝐚𝐧𝐜𝐞𝐥𝐥𝐞𝐝.
    final VoidCallback? onCancel;
    // %%%%%%%%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%%%%%
    /// 𝐂𝐨𝐧𝐬𝐭𝐫𝐮𝐜𝐭𝐨𝐫 𝐟𝐨𝐫 𝐢𝐧𝐢𝐭𝐢𝐚𝐥𝐢𝐳𝐢𝐧𝐠 𝐓𝐓𝐒 𝐬𝐞𝐫𝐯𝐢𝐜𝐞 𝐰𝐢𝐭𝐡 𝐜𝐮𝐬𝐭𝐨𝐦 𝐜𝐚𝐥𝐥𝐛𝐚𝐜𝐤𝐬.
    ///
    /// Sets up TTS with predefined speech parameters and registers callback handlers.
    /// Default settings: speech rate 0.62, pitch 1.2, volume 1.0.
    ///
    /// Parameters:
    /// - `onStart` : Optional callback triggered when TTS starts speaking
    /// - `onCompletion` : Optional callback triggered when TTS finishes speaking
    /// - `onCancel` : Optional callback triggered when TTS is cancelled
    ///
    /// Example usage:
    /// ```dart
    /// final ttsService = TtsService(
    ///   onStart: () => print('TTS started'),
    ///   onCompletion: () => print('TTS completed'),
    /// );
    /// ```
    TtsService ({
        this.onStart,
        this.onCompletion,
        this.onCancel,
    }) {
        // Configure default TTS speech parameters
        _tts.setSpeechRate(.62);    // Slightly slower than normal for clarity
        _tts.setPitch(1.2);         // Slightly higher pitch for better listening
        _tts.setVolume(1.0);        // Maximum volume
        
        // Register callback handlers if provided
        if (onStart != null) _tts.setStartHandler(onStart!);
        if (onCompletion != null) _tts.setCompletionHandler(onCompletion!);
        if (onCancel != null) _tts.setCancelHandler(onCancel!);
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%% RETRIEVE CURRENT TTS LANGUAGE %%%%%%%%%%%%%%%%%%%%%%%%
    /// 𝐑𝐞𝐭𝐫𝐢𝐞𝐯𝐞𝐬 𝐭𝐡𝐞 𝐜𝐮𝐫𝐫𝐞𝐧𝐭 𝐓𝐓𝐒 𝐥𝐚𝐧𝐠𝐮𝐚𝐠𝐞 𝐟𝐫𝐨𝐦 𝐥𝐨𝐜𝐚𝐥 𝐬𝐭𝐨𝐫𝐚𝐠𝐞.
    ///
    /// This static method retrieves the previously saved TTS language preference
    /// from SharedPreferences. If no preference is found, defaults to English.
    ///
    /// Returns:
    /// - `Future<String>` : The saved language string or default English language name
    ///
    /// Example usage:
    /// ```dart
    /// String currentLang = await TtsService.retrieveTtsLanguage();
    /// print('Current TTS language: $currentLang');
    /// ```
    static Future<String> retrieveTtsLanguage () async {
        final pref = await SharedPreferences.getInstance();
        return pref.getString(ttsPreferenceKey) ?? Languages.english.formattedName;
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - RETRIEVE CURRENT TTS LANGUAGE %%%%%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%% SAVE CURRENT TTS LANGUAGE %%%%%%%%%%%%%%%%%%%%%%%%
    /// 𝐒𝐚𝐯𝐞𝐬 𝐭𝐡𝐞 𝐜𝐮𝐫𝐫𝐞𝐧𝐭 𝐓𝐓𝐒 𝐥𝐚𝐧𝐠𝐮𝐚𝐠𝐞 𝐩𝐫𝐞𝐟𝐞𝐫𝐞𝐧𝐜𝐞 𝐭𝐨 𝐥𝐨𝐜𝐚𝐥 𝐬𝐭𝐨𝐫𝐚𝐠𝐞.
    ///
    /// This static method persists the user's TTS language preference
    /// to SharedPreferences for future app sessions.
    ///
    /// Parameters:
    /// - `lang` : The language string to save (should match Languages enum values)
    ///
    /// Returns:
    /// - `Future<void>` : Completes when the language is successfully saved
    ///
    /// Example usage:
    /// ```dart
    /// await TtsService.saveTtsLanguage(Languages.french.formattedName);
    /// ```
    static Future<void> saveTtsLanguage (String lang) async {
        final pref = await SharedPreferences.getInstance();
        await pref.setString(ttsPreferenceKey, lang);
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - SAVE CURRENT TTS LANGUAGE %%%%%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%% SET TTS LANGUAGE %%%%%%%%%%%%%%%%%%%%%%%%
    /// 𝐒𝐞𝐭𝐬 𝐭𝐡𝐞 𝐓𝐓𝐒 𝐥𝐚𝐧𝐠𝐮𝐚𝐠𝐞 𝐟𝐨𝐫 𝐬𝐩𝐞𝐞𝐜𝐡 𝐨𝐮𝐭𝐩𝐮𝐭.
    ///
    /// This method configures the TTS engine language. If no language is provided,
    /// it retrieves the saved preference and applies appropriate locale codes.
    /// Supports French (fr-FR) and English (en-US) with fallback to English.
    ///
    /// Parameters:
    /// - `language` : Optional language string. If null, uses saved preference
    ///
    /// Returns:
    /// - `Future<void>` : Completes when language is set
    ///
    /// Language mapping:
    /// - French → 'fr-FR'
    /// - English (default) → 'en-US'
    ///
    /// Example usage:
    /// ```dart
    /// await ttsService.setTtsLanguage(language: 'fr-FR');
    /// await ttsService.setTtsLanguage(); // Uses saved preference
    /// ```
    Future<void> setTtsLanguage ({String? language}) async {
        try{
            // If specific language code provided, use it directly
            if (language != null && language.trim().isNotEmpty) {
                await _tts.setLanguage(language);
                return;
            } 

            // Retrieve saved language preference
            language = await retrieveTtsLanguage();
            
            // Set appropriate locale based on saved preference
            if (language == Languages.french.formattedName || language == Languages.french.name) {
                await _tts.setLanguage('fr-FR');

            } else {
                // Default to English for any other case
                await _tts.setLanguage('en-US');
            }
        } catch (_) {
            // Silently handle any language setting errors
        }
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - SET TTS LANGUAGE %%%%%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%% READ %%%%%%%%%%%%%%%%%%%%%%%%
    /// 𝐑𝐞𝐚𝐝𝐬 𝐭𝐡𝐞 𝐩𝐫𝐨𝐯𝐢𝐝𝐞𝐝 𝐭𝐞𝐱𝐭 𝐚𝐥𝐨𝐮𝐝 𝐮𝐬𝐢𝐧𝐠 𝐓𝐓𝐒.
    ///
    /// This method first ensures the correct language is set, then speaks the provided text.
    /// It stops any ongoing speech before starting new speech to prevent overlapping.
    /// Empty or whitespace-only text is ignored.
    ///
    /// Parameters:
    /// - `text` : The text content to be spoken aloud
    ///
    /// Returns:
    /// - `Future<void>` : Completes when speech operation is initiated
    ///
    /// Example usage:
    /// ```dart
    /// await ttsService.read("Hello, this is a test message");
    /// await ttsService.read("Bonjour, ceci est un message de test");
    /// ```
    Future<void> read (String text) async {
        // Ensure correct language is set before speaking
        await setTtsLanguage();
        
        // Skip empty or whitespace-only text
        if (text.trim().isEmpty) return;
        
        try{
            // Stop any ongoing speech to prevent overlapping
            await _tts.stop();
            
            // Start speaking the provided text
            await _tts.speak(text);
        } catch (_) {
            // Silently handle any speech errors
        }
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - READ %%%%%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%% STOP %%%%%%%%%%%%%%%%%%%%%%%%
    /// 𝐒𝐭𝐨𝐩𝐬 𝐚𝐧𝐲 𝐨𝐧𝐠𝐨𝐢𝐧𝐠 𝐓𝐓𝐒 𝐬𝐩𝐞𝐞𝐜𝐡.
    ///
    /// This method immediately stops any current speech output.
    /// Can be used to interrupt long text readings or when the user
    /// wants to cancel speech playback.
    ///
    /// Returns:
    /// - `Future<void>` : Completes when speech is stopped
    ///
    /// Example usage:
    /// ```dart
    /// await ttsService.stop(); // Immediately stops current speech
    /// ```
    Future<void> stop () async {
        await _tts.stop();
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - STOP %%%%%%%%%%%%%%%%%%%%%%%%

}
// @@@@@@@@@@@@@@@@@@@@@ END - TTS SERVICE @@@@@@@@@@@@@@@@@@@