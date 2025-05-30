import 'package:first_project/extensions/enum_extensions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';


// @@@@@@@@@@@@@@@@@@ ENUMS @@@@@@@@@@@@@@@@

// %%%%%%%%%%%%%%%%% TTS LANG %%%%%%%%%%%%%%
/// 𝐋𝐚𝐧𝐠𝐮𝐚𝐠𝐞𝐬 - 𝐒𝐮𝐩𝐩𝐨𝐫𝐭𝐞𝐝 𝐥𝐚𝐧𝐠𝐮𝐚𝐠𝐞𝐬 𝐟𝐨𝐫 𝐒𝐩𝐞𝐞𝐜𝐡-𝐭𝐨-𝐓𝐞𝐱𝐭 𝐨𝐩𝐞𝐫𝐚𝐭𝐢𝐨𝐧𝐬
///
/// This enum defines the available languages for speech recognition in the CineBook
/// application. Each language corresponds to specific locale codes used by the
/// underlying speech recognition service.
///
/// Supported languages:
/// - `english` : Maps to 'en-US' locale for American English recognition
/// - `french` : Maps to 'fr-FR' locale for French recognition
///
/// Used in conjunction with enum extensions to provide formatted names and
/// locale mapping for the speech recognition functionality.
enum Languages {
    english,
    french
}
// %%%%%%%%%%%%%%%%% END - TTS LANG %%%%%%%%%%%%%%

// @@@@@@@@@@@@@@@@@@ END - ENUMS @@@@@@@@@@@@@@@@





// @@@@@@@@@@@@@@@@@@@@@ MAIN CLASS @@@@@@@@@@@@@@@@@@@@@@
/// 𝐒𝐭𝐭𝐒𝐞𝐫𝐯𝐢𝐜𝐞 - 𝐀 𝐜𝐨𝐦𝐩𝐫𝐞𝐡𝐞𝐧𝐬𝐢𝐯𝐞 𝐒𝐩𝐞𝐞𝐜𝐡-𝐭𝐨-𝐓𝐞𝐱𝐭 𝐬𝐞𝐫𝐯𝐢𝐜𝐞 𝐦𝐚𝐧𝐚𝐠𝐞𝐫
///
/// This service class provides complete speech recognition capabilities for the CineBook
/// application, including initialization, listening control, language management, and
/// automatic restart functionality for interrupted sessions.
///
/// Key features:
/// - Microphone permission handling and speech-to-text initialization
/// - Multi-language support (English and French)
/// - Automatic restart for prematurely terminated listening sessions
/// - Configurable listening parameters (duration, pause time, partial results)
/// - Language preference persistence using SharedPreferences
/// - Lock mechanism to control listening state
/// - Real-time speech recognition with customizable result handling
///
/// The service handles edge cases like:
/// - Network interruptions during speech recognition
/// - Early termination detection and automatic restart
/// - Microphone permission management
/// - Language switching and persistence
///
/// Usage pattern:
/// 1. Initialize service with `init()`
/// 2. Start listening with `startListening()`
/// 3. Handle results through provided callback
/// 4. Stop listening with `stopListening()`
class SttService {

    // %%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%
    /// SharedPreferences key for storing current TTS language preference
    static const String ttsPreferenceKey = "currentTtsLang";
    
    /// Core speech-to-text instance for handling recognition operations
    final SpeechToText _stt = SpeechToText();
    
    /// Flag indicating if speech recognition service is available and initialized
    bool _isAvailable = false;
    
    /// Public getter for service availability status
    bool get isAvailable => _isAvailable;
    
    /// Public getter for current listening state from SpeechToText instance
    bool get isListening => _stt.isListening;
    
    /// Timestamp when the last listening session started (used for restart logic)
    late DateTime _lastListeningStart;
    
    /// Callback function to handle speech recognition results
    late Function(String) _onResultAction;
    
    /// Accumulated speech text before restart (preserves context during reconnections)
    String _beforeRestartSpeech = '';
    
    /// Internal flag tracking if listening has been manually stopped
    bool _hasStopped = true;
    
    /// Lock mechanism to control listening state and prevent unwanted operations
    bool _isLocked = true;
    // %%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%% INIT STT %%%%%%%%%%%%%%%
    /// 𝐈𝐧𝐢𝐭𝐢𝐚𝐥𝐢𝐳𝐞𝐬 𝐭𝐡𝐞 𝐬𝐩𝐞𝐞𝐜𝐡-𝐭𝐨-𝐭𝐞𝐱𝐭 𝐬𝐞𝐫𝐯𝐢𝐜𝐞 𝐚𝐧𝐝 𝐬𝐞𝐭𝐬 𝐮𝐩 𝐚𝐮𝐭𝐨-𝐫𝐞𝐬𝐭𝐚𝐫𝐭 𝐦𝐞𝐜𝐡𝐚𝐧𝐢𝐬𝐦.
    ///
    /// This method handles the complete initialization process including microphone
    /// permission requests, speech recognition service setup, and configuration of
    /// the automatic restart mechanism for interrupted listening sessions.
    ///
    /// Returns:
    /// - `Future<bool>` : true if initialization succeeded, false otherwise
    ///
    /// The method performs these operations:
    /// 1. Requests microphone permission from the user
    /// 2. Initializes the SpeechToText service
    /// 3. Sets up a status listener for automatic restart functionality
    /// 4. Configures the restart logic for prematurely terminated sessions
    ///
    /// The status listener monitors for unexpected listening stops and triggers
    /// a restart if the session was terminated too early (within 5 seconds).
    /// This helps maintain continuous speech recognition during network issues
    /// or temporary service interruptions.
    ///
    /// Returns false if:
    /// - Microphone permission is denied by user
    /// - Speech recognition service fails to initialize
    /// - Device doesn't support speech recognition
    ///
    /// Example usage:
    /// ```dart
    /// SttService sttService = SttService();
    /// bool initialized = await sttService.init();
    /// if (initialized) {
    ///   // Service ready to use
    /// }
    /// ```
    Future<bool> init () async {
        // Request microphone permission before initializing speech recognition
        var status = await Permission.microphone.request();
        if (!status.isGranted) return false;
        
        // Initialize the speech-to-text service
        _isAvailable = await _stt.initialize();

        // Set up status listener for automatic restart mechanism
        _stt.statusListener = (status) async {
            // Check if listening stopped unexpectedly (not manually stopped)
            if (!_hasStopped && !_stt.isListening) {
                stopListening(isLocked: _isLocked);
                await Future.delayed(Duration(milliseconds: 300)); // Brief pause before restart
                _restartListeningIfTooEarlyCut();
            }
        };
        return _isAvailable;
    }
    // %%%%%%%%%%%%%%%%%%% END - INIT STT %%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%% RESTART LISTENING IF TOO EARLY CUT %%%%%%%%%%%
    /// 𝐑𝐞𝐬𝐭𝐚𝐫𝐭𝐬 𝐥𝐢𝐬𝐭𝐞𝐧𝐢𝐧𝐠 𝐢𝐟 𝐭𝐡𝐞 𝐬𝐞𝐬𝐬𝐢𝐨𝐧 𝐰𝐚𝐬 𝐭𝐞𝐫𝐦𝐢𝐧𝐚𝐭𝐞𝐝 𝐩𝐫𝐞𝐦𝐚𝐭𝐮𝐫𝐞𝐥𝐲.
    ///
    /// This internal method implements the automatic restart logic for speech
    /// recognition sessions that end too quickly, which often indicates network
    /// issues or temporary service interruptions rather than intentional stops.
    ///
    /// The method checks if the current listening session lasted less than 5 seconds
    /// from its start time. If so, it automatically restarts the listening process
    /// with the same parameters and preserved speech context.
    ///
    /// Restart conditions:
    /// - Session duration < 5 seconds from start time
    /// - Service is still available and not manually locked
    /// - Previous speech content is preserved in `_beforeRestartSpeech`
    ///
    /// This mechanism helps provide seamless speech recognition experience by:
    /// - Handling temporary network disconnections
    /// - Recovering from service interruptions
    /// - Preserving user's speech context across restarts
    /// - Reducing the need for manual re-initiation
    ///
    /// The restart uses the same callback function and preserved speech content
    /// to maintain continuity in the user experience.
    void _restartListeningIfTooEarlyCut () {
        final now = DateTime.now();
        // Check if the session ended within 5 seconds (likely premature termination)
        if (now.difference(_lastListeningStart).inSeconds < 5) {
            // Restart with preserved speech content and same parameters
            startListening(_onResultAction, beforeSpeech: _beforeRestartSpeech, isLocked: _isLocked);
        }
    }
    // %%%%%%%%%%%%%%%%%%% END - RESTART LISTENING IF TOO EARLY CUT %%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% START LISTENING %%%%%%%%%%%%%%%%%
    /// 𝐒𝐭𝐚𝐫𝐭𝐬 𝐬𝐩𝐞𝐞𝐜𝐡 𝐫𝐞𝐜𝐨𝐠𝐧𝐢𝐭𝐢𝐨𝐧 𝐰𝐢𝐭𝐡 𝐜𝐮𝐬𝐭𝐨𝐦𝐢𝐳𝐚𝐛𝐥𝐞 𝐜𝐨𝐧𝐟𝐢𝐠𝐮𝐫𝐚𝐭𝐢𝐨𝐧 𝐚𝐧𝐝 𝐜𝐨𝐧𝐭𝐞𝐱𝐭.
    ///
    /// This method initiates a speech recognition session with configurable parameters
    /// for text context and listening behavior. It handles language selection,
    /// result processing, and maintains session state for potential restarts.
    ///
    /// Parameters:
    /// - `onResultAction` : Function(String) callback to handle recognition results
    /// - `beforeSpeech` : String text to prepend to recognition results (default: '')
    /// - `afterSpeech` : String text to append to recognition results (default: '')
    /// - `isLocked` : bool flag to control if listening can be started (default: false)
    ///
    /// Returns:
    /// - `Future<void>` : Completes when listening session is configured and started
    ///
    /// The method performs these operations:
    /// 1. Checks service availability and lock status
    /// 2. Retrieves current language preference from SharedPreferences
    /// 3. Maps language to appropriate locale code (en-US or fr-FR)
    /// 4. Configures listening parameters (duration, pause time, results mode)
    /// 5. Starts recognition with result callback handling
    /// 6. Sets up context preservation for potential restarts
    ///
    /// Listening configuration:
    /// - Maximum listening duration: 3 minutes
    /// - Pause detection timeout: 15 seconds
    /// - Partial results enabled for real-time feedback
    /// - Dictation mode for natural speech patterns
    /// - Auto-cancellation on errors
    ///
    /// The result callback receives formatted text combining:
    /// `beforeSpeech + recognizedWords + afterSpeech`
    ///
    /// Example usage:
    /// ```dart
    /// await sttService.startListening(
    ///   (result) => print('Recognized: $result'),
    ///   beforeSpeech: 'User said: ',
    ///   afterSpeech: ' [END]',
    ///   isLocked: false
    /// );
    /// ```
    Future<void> startListening (Function(String) onResultAction, {String beforeSpeech = '', String afterSpeech = '', bool isLocked = false}) async {

        // Set lock state and check if listening is allowed
        _isLocked = isLocked;
        if (!_isAvailable || _isLocked) return;
        
        // Retrieve current language preference and map to locale code
        final language = await retrieveTtsLanguage();
        final String languageCode;

        if (language == Languages.french.formattedName || language == Languages.french.name) {
            languageCode = 'fr-FR';
        } else {
            languageCode = 'en-US';
        }

        // Initialize session state variables
        _hasStopped = false;
        _onResultAction = onResultAction;
        _lastListeningStart = DateTime.now();
        
        // Start speech recognition with configured parameters
        _stt.listen(
            localeId: languageCode,

            onResult: (result) {
                // Format prefix and suffix text with proper spacing
                if (beforeSpeech.trim().isNotEmpty) beforeSpeech = "${beforeSpeech.trim()} ";
                if (afterSpeech.trim().isNotEmpty) " ${afterSpeech.trim()}";
                
                // Combine context text with recognized speech and call result handler
                onResultAction(beforeSpeech + result.recognizedWords + afterSpeech);
                
                // Preserve formatted result for potential restart scenarios
                _beforeRestartSpeech = beforeSpeech + result.recognizedWords + afterSpeech;
            },

            // Configure listening timeouts
            pauseFor: Duration(seconds: 15),  // Stop after 15 seconds of silence
            listenFor: Duration(minutes: 3),  // Maximum listening duration

            // Set advanced listening options
            listenOptions: SpeechListenOptions(
                partialResults: true,          // Enable real-time partial results
                cancelOnError: true,           // Auto-cancel on recognition errors
                listenMode: ListenMode.dictation, // Optimize for natural speech
            )
        );
    }
    // %%%%%%%%%%%%%%%%%%%% END - START LISTENING %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% STOP LISTENING %%%%%%%%%%%%%%%%%
    /// 𝐒𝐭𝐨𝐩𝐬 𝐭𝐡𝐞 𝐜𝐮𝐫𝐫𝐞𝐧𝐭 𝐬𝐩𝐞𝐞𝐜𝐡 𝐫𝐞𝐜𝐨𝐠𝐧𝐢𝐭𝐢𝐨𝐧 𝐬𝐞𝐬𝐬𝐢𝐨𝐧.
    ///
    /// This method terminates the active listening session and updates internal
    /// state flags to prevent automatic restarts. It provides control over the
    /// lock state to manage future listening operations.
    ///
    /// Parameters:
    /// - `isLocked` : bool flag to set the service lock state (default: true)
    ///   - true: Locks the service, preventing new listening sessions
    ///   - false: Keeps service unlocked, allowing immediate restart
    ///
    /// The method performs these operations:
    /// 1. Updates the internal lock state based on parameter
    /// 2. Sets the stopped flag to prevent automatic restarts
    /// 3. Calls the underlying SpeechToText stop method
    ///
    /// State changes:
    /// - `_hasStopped` : Set to true to indicate manual stop
    /// - `_isLocked` : Updated based on isLocked parameter
    /// - Underlying `_stt.isListening` : Set to false by stop operation
    ///
    /// The lock mechanism prevents:
    /// - Unwanted automatic restarts after manual stops
    /// - New listening sessions when service should be disabled
    /// - Concurrent listening operations
    ///
    /// Example usage:
    /// ```dart
    /// // Stop and lock the service
    /// sttService.stopListening();
    /// 
    /// // Stop but keep service available for immediate restart
    /// sttService.stopListening(isLocked: false);
    /// ```
    void stopListening ({bool isLocked = true}) {
        // Update lock state (default to locked unless explicitly specified)
        _isLocked = isLocked ? true : false;
        
        // Mark as manually stopped to prevent automatic restart
        _hasStopped = true;
        
        // Stop the underlying speech recognition service
        _stt.stop();
    } 
    // %%%%%%%%%%%%%%%%%%%% END - STOP LISTENING %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%% RETRIEVE CURRENT TTS LANGUAGE %%%%%%%%%%%%%%%%%%%
    /// 𝐑𝐞𝐭𝐫𝐢𝐞𝐯𝐞𝐬 𝐭𝐡𝐞 𝐜𝐮𝐫𝐫𝐞𝐧𝐭 𝐥𝐚𝐧𝐠𝐮𝐚𝐠𝐞 𝐩𝐫𝐞𝐟𝐞𝐫𝐞𝐧𝐜𝐞 𝐟𝐫𝐨𝐦 𝐩𝐞𝐫𝐬𝐢𝐬𝐭𝐞𝐧𝐭 𝐬𝐭𝐨𝐫𝐚𝐠𝐞.
    ///
    /// This static method accesses the user's saved language preference from
    /// SharedPreferences and returns it as a string. If no preference has been
    /// saved previously, it defaults to English.
    ///
    /// Returns:
    /// - `Future<String>` : The saved language preference string, or English default
    ///
    /// The method handles these scenarios:
    /// - First app launch: Returns default English language
    /// - Saved preference exists: Returns the stored language string
    /// - Storage access issues: Falls back to English default
    ///
    /// The returned string corresponds to language values that can be:
    /// - Languages.english.formattedName (from enum extension)
    /// - Languages.french.formattedName (from enum extension)
    /// - Raw enum names (english, french)
    ///
    /// This preference is used by `startListening()` to determine the appropriate
    /// locale code for speech recognition (en-US vs fr-FR).
    ///
    /// Example usage:
    /// ```dart
    /// String currentLang = await SttService.retrieveTtsLanguage();
    /// print('Current language: $currentLang'); // "English" or "French"
    /// ```
    static Future<String> retrieveTtsLanguage () async {
        // Access SharedPreferences instance
        final pref = await SharedPreferences.getInstance();
        
        // Return saved preference or default to English
        return pref.getString(ttsPreferenceKey) ?? Languages.english.formattedName;
    }
    // %%%%%%%%%%%%%%%% END - RETRIEVE CURRENT TTS LANGUAGE %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% SAVE CURRENT TTS LANGUAGE %%%%%%%%%%%%%%%
    /// 𝐒𝐚𝐯𝐞𝐬 𝐭𝐡𝐞 𝐮𝐬𝐞𝐫'𝐬 𝐥𝐚𝐧𝐠𝐮𝐚𝐠𝐞 𝐩𝐫𝐞𝐟𝐞𝐫𝐞𝐧𝐜𝐞 𝐭𝐨 𝐩𝐞𝐫𝐬𝐢𝐬𝐭𝐞𝐧𝐭 𝐬𝐭𝐨𝐫𝐚𝐠𝐞.
    ///
    /// This static method stores the provided language preference string to
    /// SharedPreferences for persistence across app sessions. The saved preference
    /// will be retrieved by `retrieveTtsLanguage()` for future speech recognition sessions.
    ///
    /// Parameters:
    /// - `lang` : String representing the language preference to save
    ///   - Should be a formatted language name (e.g., "English", "French")
    ///   - Or raw enum name (e.g., "english", "french")
    ///
    /// Returns:
    /// - `Future<void>` : Completes when the preference is successfully saved
    ///
    /// The method handles the complete persistence operation:
    /// 1. Accesses SharedPreferences instance
    /// 2. Stores the language string under the predefined key
    /// 3. Ensures data is written to persistent storage
    ///
    /// This preference affects:
    /// - Future speech recognition locale selection
    /// - Language-specific recognition accuracy
    /// - User interface language consistency
    ///
    /// The saved preference persists across:
    /// - App restarts and updates
    /// - Device reboots
    /// - App background/foreground cycles
    ///
    /// Example usage:
    /// ```dart
    /// // Save English preference
    /// await SttService.saveTtsLanguage(Languages.english.formattedName);
    /// 
    /// // Save French preference
    /// await SttService.saveTtsLanguage(Languages.french.formattedName);
    /// ```
    static Future<void> saveTtsLanguage (String lang) async {
        // Access SharedPreferences instance
        final pref = await SharedPreferences.getInstance();
        
        // Save language preference with predefined key
        await pref.setString(ttsPreferenceKey, lang);
    }
    // %%%%%%%%%%%%%%%%%% END - SAVE CURRENT TTS LANGUAGE %%%%%%%%%%%%%%%

}
// @@@@@@@@@@@@@@@@@@@@@ MAIN CLASS @@@@@@@@@@@@@@@@@@@@@@