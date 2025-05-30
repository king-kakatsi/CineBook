import 'package:first_project/extensions/enum_extensions.dart';
import 'package:first_project/services/stt_service.dart';
import 'package:first_project/widgets/display_alert.dart';
import 'package:first_project/widgets/dynamic_form.dart';
import 'package:first_project/widgets/lottie_animator.dart';
import 'package:first_project/models/media.dart';
import 'package:first_project/controllers/media_controller.dart';
import 'package:first_project/services/media_getter.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

/// **Defines the possible actions for the MediaEditPage**
/// 
/// This enum determines whether the page is used for creating or editing
/// series or anime content, affecting the form behavior and media type assignment.
enum EditPageAction {
    createSeries,
    editSeries,

    createAnime,
    editAnime,
}



// @@@@@@@@@@@@ STATEFUL @@@@@@@@@@@@@@@@
/// **Media Edit Page Widget**
/// 
/// A comprehensive form page for creating and editing media entries (series/anime).
/// Supports voice input via speech-to-text functionality and dynamic form generation.
/// 
/// Features:
/// - Create new media entries or edit existing ones
/// - Voice input with long-press microphone button
/// - Dynamic form with various field types (text, textarea, picker, number)
/// - Image fetching and local storage
/// - Real-time form validation
/// 
/// Parameters:
/// - title: The page title displayed in the app bar
/// - editPageAction: Determines the action type (create/edit series/anime)
/// - media: Optional existing media object for editing (null for creation)
class MediaEditPage extends StatefulWidget {

    // %%%%%%%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%
    /// **Page title displayed in the app bar**
    final String title;
    
    /// **Action type that determines form behavior and media type**
    final EditPageAction editPageAction;
    
    /// **Optional media object for editing (null when creating new media)**
    final Media? media;
    // %%%%%%%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%%
    const MediaEditPage({
        super.key,
        required this.title,
        required this.editPageAction,
        this.media,
    });
    // %%%%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%% CREATE STATE %%%%%%%%%%%%%%%%%
    @override State<MediaEditPage> createState() => MediaEditPageState();
    // %%%%%%%%%%%%% END - CREATE STATE %%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@ END - STATEFUL @@@@@@@@@@@@@@@@





// @@@@@@@@@@@@@@@@@@ STATE @@@@@@@@@@@@@@@@
class MediaEditPageState extends State<MediaEditPage> {

    // %%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%
    /// **List of form field objects that define the dynamic form structure**
    late final List<FormObject> _formObjects;
    
    /// **Initial values for form fields, populated from existing media data**
    late final Map<String, String?> _initialValues;
    
    /// **Lottie animator for loading and voice recording animations**
    final LottieAnimator _lottieAnimator = LottieAnimator();

    /// **Speech-to-text service for voice input functionality**
    final SttService _speechToText = SttService();
    
    /// **Flag to track if the microphone is currently listening**
    bool _isListening = false;
    
    /// **Global key to access dynamic form state and controllers**
    final GlobalKey<DynamicFormPageState> _formKey = GlobalKey<DynamicFormPageState>();
    
    /// **Stores previous text in field before voice input to enable text appending**
    String _previousTextInField = '';
    // %%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% INIT STATE %%%%%%%%%%%%%%%%%%%
    @override
    void initState() {
        super.initState();
        // Initialize speech-to-text service
        _speechToText.init();

        // Populate initial values from existing media data
        _initialValues = {
            'mediaType': widget.media?.mediaType.name,
            'title': widget.media?.title,
            'description': widget.media?.description,
            'imageUrl': widget.media?.imageUrl,
            'rate': widget.media?.rate.toString(),
            'currentSeasonIndex': widget.media?.currentSeasonIndex.toString(),
            'currentEpisodeIndex': widget.media?.currentEpisodeIndex.toString(),
        };

        // Handle optional enum fields with formatted names
        if (widget.media != null && widget.media!.mediaGenre != null) _initialValues['mediaGenre'] = widget.media!.mediaGenre!.formattedName;

        if (widget.media != null && widget.media!.watchStatus != null) _initialValues['watchStatus'] = widget.media!.watchStatus!.formattedName;
        

        // Define dynamic form structure with all required fields
        _formObjects = [
            FormObject(
                id: 'title',
                title: 'Title',
                hint: 'Enter the media title',
                type: FormFieldType.text,
                widthFactor: 1.0,
                initialValue: _initialValues['title'],
                isRequired: true,
            ),
            FormObject(
                id: 'mediaGenre',
                title: 'Genre',
                hint: 'Select the genre',
                type: FormFieldType.picker,
                options: MediaGenre.values.map((val) => val.formattedName).toList(),
                widthFactor: 1.0,
                initialValue: _initialValues['mediaGenre'],
                isRequired: false,
            ),
            FormObject(
                id: 'description',
                title: 'Description',
                hint: 'Enter the media description',
                type: FormFieldType.textarea,
                widthFactor: 1.0,
                initialValue: _initialValues['description'],
                isRequired: true,
            ),
            FormObject(
                id: 'watchStatus',
                title: 'Watch Status',
                hint: 'Select the watch status',
                type: FormFieldType.picker,
                options: WatchStatus.values.map((val) => val.formattedName).toList(),
                widthFactor: 1.0,
                initialValue: _initialValues['watchStatus'],
                isRequired: false,
            ),
            FormObject(
                id: 'imageUrl',
                title: 'Image URL',
                hint: 'Enter the image URL',
                type: FormFieldType.text,
                widthFactor: 1.0,
                initialValue: _initialValues['imageUrl'],
                isRequired: false,
            ),
            FormObject(
                id: 'rate',
                title: 'Rate',
                hint: 'Enter the rate (0-5)',
                type: FormFieldType.number,
                widthFactor: 1.0,
                initialValue: _initialValues['rate'],
                isRequired: false,
            ),
            FormObject(
                id: 'currentSeasonIndex',
                title: 'Current Season',
                hint: 'Season you are currently on',
                type: FormFieldType.number,
                widthFactor: 1.0,
                initialValue: _initialValues['currentSeasonIndex'],
                isRequired: false,
            ),
            FormObject(
                id: 'currentEpisodeIndex',
                title: 'Current Episode',
                hint: 'Episode you are currently on',
                type: FormFieldType.number,
                widthFactor: 1.0,
                initialValue: _initialValues['currentEpisodeIndex'],
                isRequired: false,
            ),
        ];
    }
    // %%%%%%%%%%%%%%%%%%%% END - INIT STATE %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%% VALIDATE SPEECH TO TEXT AVAILABILITY %%%%%%%%%%%%%%%%%% 
    /// **Pre-listening validation and setup for speech-to-text functionality**
    /// 
    /// This method is called on tap down before starting voice recording.
    /// It validates that speech-to-text service is available and that a form field is focused.
    /// 
    /// Parameters:
    /// - _: TapDownDetails (unused but required by gesture detector)
    /// 
    /// Validation checks:
    /// - Speech-to-text service availability
    /// - Form field focus state
    /// - Stores current field text for appending new voice input
    /// 
    /// Shows appropriate error alerts if validation fails.
    void _justBeforeListening (TapDownDetails _) {

        if (!_speechToText.isAvailable) {
            Alert.display(
                context, 
                "Unavailable Service", 
                "Sorry, this service is unavailable on your device."
            );
        }

        if (_formKey.currentState != null && _formKey.currentState!.currentlyFocusedController != null) {
            // Store current text to append new voice input
            _previousTextInField = _formKey.currentState!.currentlyFocusedController!.text;

        } else {
            Alert.display(
                context, 
                "Operation Failed", 
                "Please click on a field before start recording."
            );
        }
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - VALIDATE SPEECH TO TEXT AVAILABILITY %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%% START VOICE RECORDING %%%%%%%%%%%%%%%%%% 
    /// **Initiates speech-to-text recording session**
    /// 
    /// This method starts the voice recording process when user long-presses the microphone button.
    /// It updates the UI state, starts animations, and begins listening for speech input.
    /// 
    /// Parameters:
    /// - _: LongPressStartDetails (unused but required by gesture detector)
    /// 
    /// Returns:
    /// - Future<void>: Completes when recording session is initiated
    /// 
    /// Process:
    /// - Validates speech-to-text availability
    /// - Updates listening state and starts animation
    /// - Configures speech service with current field text for appending
    /// - Sets up real-time text update callback
    Future<void> _startListening (LongPressStartDetails _) async {

        if (!_speechToText.isAvailable) return;
            
        setState(() {
            _isListening = true;
        });
        // Start recording animation
        _lottieAnimator.play();

        _speechToText.startListening(
            beforeSpeech: _previousTextInField,

            // Real-time text update callback
            (text) {
                if (_formKey.currentState != null && _formKey.currentState!.currentlyFocusedController != null) {
                    _formKey.currentState!.currentlyFocusedController!.text = text;
                }
            },
        );
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - START VOICE RECORDING %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%% STOP VOICE RECORDING %%%%%%%%%%%%%%%%%% 
    /// **Stops speech-to-text recording session**
    /// 
    /// This method ends the voice recording when user releases the long-press.
    /// It cleans up the recording state and stops all related animations.
    /// 
    /// Parameters:
    /// - details: LongPressEndDetails containing gesture information
    /// 
    /// Process:
    /// - Updates listening state to false
    /// - Stops speech-to-text service
    /// - Stops Lottie animation
    /// - Clears previous text storage
    void _endListening (LongPressEndDetails details) {
        setState(() {
            _isListening = false;
        });
        _speechToText.stopListening();
        _lottieAnimator.stop();
        if (_formKey.currentState != null && _formKey.currentState!.currentlyFocusedController != null) {
            _previousTextInField = '';
        }
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - STOP VOICE RECORDING %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%% HANDLE FORM SUBMISSION %%%%%%%%%%%%%%%%%% 
    /// **Processes form submission for media creation or editing**
    /// 
    /// This method handles the complete flow of creating new media or updating existing media.
    /// It validates form data, fetches images, and saves to local storage via MediaController.
    /// 
    /// Parameters:
    /// - results: Map<String, String?> containing all form field values
    /// 
    /// Returns:
    /// - Future<void>: Completes when submission process is finished
    /// 
    /// Process:
    /// - Determines media type based on edit action
    /// - Creates new Media object or updates existing one
    /// - Fetches and stores images from URLs
    /// - Saves to Hive database via MediaController
    /// - Shows success/error feedback and navigates back
    /// 
    /// Example usage:
    /// ```dart
    /// Map<String, String?> formData = {'title': 'New Series', 'description': '...'};
    /// await _handleSubmit(formData);
    /// ```
    void _handleSubmit (Map<String, String?> results) async {

        // Play await Anim
        _lottieAnimator.play();

        // °°°°°°°°°°°°°°° INIT MEDIA TYPE °°°°°°°°°°°°°°°
        // Determine media type based on current action
        Mediatype mediaType;
        switch (widget.editPageAction) {
            case EditPageAction.createSeries:
            case EditPageAction.editSeries:
                mediaType = Mediatype.series;
                break;
            case EditPageAction.createAnime:
            case EditPageAction.editAnime:
                mediaType = Mediatype.anime;
                break;
        }
        // °°°°°°°°°°°°°°° END - INIT MEDIA TYPE °°°°°°°°°°°°°°°

        bool done = true;
        try{

            final mediaController = GetIt.instance<MediaController>();

            if (widget.media == null) {
                // °°°°°°°°°°°°°°° CREATE NEW MEDIA °°°°°°°°°°°°°°°° 
                final newMedia = Media(
                    mediaType: mediaType,
                    title: results['title'] ?? '',
                );
                // Set optional fields if available
                newMedia.uniqueId = Uuid().v4();
                newMedia.currentSeasonIndex = int.tryParse(results['currentSeasonIndex'] ?? "");
                newMedia.currentEpisodeIndex = int.tryParse(results['currentEpisodeIndex'] ?? '');

                // Convert formatted enum names back to enum values
                newMedia.mediaGenre = enumFromFormatted<MediaGenre>(MediaGenre.values, results['mediaGenre'] ?? '');
                newMedia.watchStatus = enumFromFormatted<WatchStatus>(WatchStatus.values, results['watchStatus'] ?? '');

                newMedia.description = results['description'] ?? '';
                newMedia.rate = double.tryParse(results['rate'] ?? '');

                // ============ FETCH THE IMAGE ================
                newMedia.imageUrl = results['imageUrl'] ?? '';
                newMedia.imagePath = '';
                if (newMedia.imageUrl != '' && newMedia.imageUrl.isNotEmpty){
                    // Download image from URL and store locally
                    final tempPath = await MediaGetter.fetchImageFromUrl(newMedia.imageUrl);
                    newMedia.imagePath = tempPath ?? '';
                }
                // ============ END - FETCH THE IMAGE ================

                // Set timestamps and generate search data
                newMedia.creationDate = DateTime.now();
                newMedia.lastModificationDate = DateTime.now();
                newMedia.generateSearchFinder();
                
                done = await mediaController.addInList(newMedia);

                // °°°°°°°°°°°°°°° END - CREATE NEW MEDIA °°°°°°°°°°°°°°°° 

            } else {
                // °°°°°°°°°°°°°° MODIFY EXISTING MEDIA °°°°°°°°°°°°°°°°°°
                // Store previous image info for cleanup
                final prevUrl = widget.media!.imageUrl;
                final prevPath = widget.media!.imagePath;
                
                // Update all fields with form data
                widget.media!
                    ..title = results['title'] ?? widget.media!.title
                    ..description = results['description'] ?? widget.media!.description
                    ..imageUrl = results['imageUrl'] ?? widget.media!.imageUrl
                    ..rate = double.tryParse(results['rate'] ?? '')

                    ..currentSeasonIndex = int.tryParse(results['currentSeasonIndex'] ?? "")
                    ..currentEpisodeIndex = int.tryParse(results['currentEpisodeIndex'] ?? '')

                    ..mediaGenre = enumFromFormatted<MediaGenre>(MediaGenre.values, results['mediaGenre'] ?? '')
                    ..watchStatus = enumFromFormatted<WatchStatus>(WatchStatus.values, results['watchStatus'] ?? '')

                    ..mediaType = mediaType;
                
                widget.media!.lastModificationDate = DateTime.now();

                // ============ FETCH THE IMAGE ================
                widget.media!.imageUrl = results['imageUrl'] ?? '';
                // Only fetch new image if URL changed
                if (prevUrl != widget.media!.imageUrl){

                    if (widget.media!.imageUrl != '' && widget.media!.imageUrl.isNotEmpty) {
                        final tempPath = await MediaGetter.fetchImageFromUrl(widget.media!.imageUrl);
                        widget.media!.imagePath = tempPath ?? '';
                    }
                    // Clean up old image file
                    MediaGetter.deleteFromLocalDir(prevPath);
                }
                // ============ END - FETCH THE IMAGE ================

                widget.media!.generateSearchFinder();
                done = await mediaController.updateInList(widget.media!);
                // °°°°°°°°°°°°°° END - MODIFY EXISTING MEDIA °°°°°°°°°°°°°°°°°°
            }

        } catch (e) {
            done = false;
        }

        // Stop await Anim
        await Future.delayed(Duration(seconds: 1));
        _lottieAnimator.stop();

        if (done) {
            // Show success message and navigate back
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text("Successfully done"),
                )
            );
            await Future.delayed(Duration(seconds: 1));
            Navigator.of(context).pop();

        } else {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text("Something went wrong. Try again later"),
                )
            );
        }
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - HANDLE FORM SUBMISSION %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%
    @override
    Widget build(BuildContext context) {

        return GestureDetector(
            // Dismiss keyboard and clear focus when tapping outside form fields
            onTap: () { 
                FocusScope.of(context).unfocus();
                _formKey.currentState!.currentlyFocusedController = null;
            },

            child: Scaffold(

                // ooooooooooooo APP BAR ooooooooooooooooo
                appBar: AppBar(
                    title: Text(
                        widget.title,
                        style: Theme.of(context).textTheme.headlineLarge,
                    ),

                    leading: IconButton(
                        onPressed: () => Navigator.pop(context), 
                        icon: Icon(Icons.arrow_back_ios_new),
                    ),
                ),
                // ooooooooooooo END - APP BAR ooooooooooooooooo


                // ooooooooooooooo BODY ooooooooooooooooooo
                body: _lottieAnimator.builder(
                    lottieFilePath: "assets/lottie/loading_anim.json",  
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainer, 
                    backgroundOpacity: .3,

                    width: 100, 
                    height: 100,

                    // Position animation based on listening state
                    alignment: _isListening ? Alignment.bottomCenter : Alignment.center,
                    pushBottom: _isListening ? 100 : 0,

                    child: DynamicFormPage(
                        key: _formKey,
                        formObjects: _formObjects,
                        onSubmit: _handleSubmit,
                        leftPadding: 15,
                        topPadding: 30,
                        rightPadding: 15,
                        bottomPadding: 100,
                    ),            
                ), 
                // ooooooooooooooo END - BODY ooooooooooooooooooo


                // oooooooooooooooooo FLOATING BUTTON oooooooooooooo
                floatingActionButton: GestureDetector(
                    // Handle voice input gestures
                    onTapDown: _justBeforeListening,
                    onLongPressStart: _startListening,
                    onLongPressEnd: _endListening,

                    child: FloatingActionButton(
                        onPressed: (){}, // Empty onPressed required for FloatingActionButton
                        child: Icon(Icons.mic_none_sharp)
                    )
                )
                // oooooooooooooooooo END - FLOATING BUTTON oooooooooooooo
            ),
        );
    }
    // %%%%%%%%%%%%%%%% END - BUILD %%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@@@@@@@ END - STATE @@@@@@@@@@@@@@@@