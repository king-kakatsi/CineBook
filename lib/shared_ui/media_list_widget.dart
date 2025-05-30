import 'dart:io';
import 'dart:math';
import 'package:first_project/extensions/enum_extensions.dart';
import 'package:first_project/services/tts_service.dart';
import 'package:first_project/widgets/lottie_animator.dart';
import 'package:first_project/widgets/media_carousel_card.dart';
import 'package:first_project/widgets/toggle_button_group.dart';
import 'package:first_project/models/media.dart';
import 'package:first_project/controllers/media_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';


// @@@@@@@@@@@@@@@@@@$ STATEFUL @@@@@@@@@@@@@@@@@@@@@@
/// A stateful widget that displays a list of media items (e.g. anime or series)
/// based on the given [mediaType]. It uses a Hive box to store and retrieve
/// the list, and shows a page title at the top of the screen.
///
/// 🧠 Why use this?
/// - To create reusable media pages like "My Anime List" or "My Series List"
/// - Data persistence via Hive
/// - Fully dynamic depending on the type of media passed
///
/// ⚠️ Note:
/// Passing [BuildContext] directly to the constructor is unusual and should only be used
/// when absolutely necessary (e.g. theme or navigator access outside of build context).
class MediaListWidget extends StatefulWidget {

    // %%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%
    
    /// The type of media displayed (Anime or Series).
    final Mediatype mediaType;

    /// The title displayed on the top of the screen.
    final String pageTitle;

    /// The Hive box name used to store and retrieve media items.
    final String hiveBoxName;

    /// The parent context (⚠️ use with caution).
    final BuildContext context;

    // %%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%
    /// Main constructor to inject mediaType, page title, Hive box name,
    /// and optionally a parent context if needed for advanced logic.
    const MediaListWidget({
        super.key, 
        required this.context,
        required this.mediaType, 
        required this.pageTitle,
        required this.hiveBoxName,
    });
    // %%%%%%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%



    
    // %%%%%%%%%%%%%%%%%%%% CREATE STATE %%%%%%%%%%%%%%%%%%%%%%
    /// Creates the state for MediaListWidget.
    @override
    State<StatefulWidget> createState() => MediaListWidgetState();
    // %%%%%%%%%%%%%%%%%%%% END - CREATE STATE %%%%%%%%%%%%%%%%%%%%%%

}

// @@@@@@@@@@@@@@@@@@$ END - STATEFUL @@@@@@@@@@@@@@@@@@@@@@





// @@@@@@@@@@@@@@@@@@@@ STATE @@@@@@@@@@@@@@@@@@@@@@@@@@@@
/// The state class for [MediaListWidget], responsible for:
/// - Initializing TTS and animations
/// - Managing media import and image reload after the first frame
/// - Holding internal states for reading mode and selected media
///
/// 🎯 Core features:
/// - Lottie animation handling via [_lottieAnimator]
/// - Two distinct animation controllers for UI effects:
///   - [_inverseAnimationController] for list inversions
///   - [_refreshAnimationController] for list refresh feedback
/// - TTS support via [_tts]
/// - Tracking reading states for each media item
///
/// ⚠️ Depends heavily on [MediaController] from Provider.
/// ⚠️ [context] is used inside `initState`, so this assumes the widget
/// is fully inserted in the widget tree.
class MediaListWidgetState extends State<MediaListWidget> with TickerProviderStateMixin {


    // %%%%%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%
    /// Controls the animation for inverting the list.
    late final AnimationController _inverseAnimationController;

    /// Controls the animation for refreshing the list.
    late final AnimationController _refreshAnimationController;

    /// Defines the actual inverse animation for the list rotation.
    late final Animation<double> _inverseListRotationAnim;

    /// Defines the refresh animation for the list rotation.
    late final Animation<double> _refreshListRotationAnim;

    /// Handles Lottie animation playback like play/stop.
    final LottieAnimator _lottieAnimator = LottieAnimator();

    /// The Text-To-Speech service used to read media descriptions.
    late final TtsService _tts;

    /// Tracks whether each media item is currently being read.
    late final Map<String, bool> _isReadingStates = {};

    /// Holds the media item currently selected for reading via TTS.
    late Media? _selectedMediaForReading;
    // %%%%%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%% INIT %%%%%%%%%%%%%%%%%%%%%
    /// Initializes the state:
    /// - Sets up TTS service
    /// - Injects the correct Hive box into [MediaController]
    /// - Triggers media import (with optional backup logic)
    /// - Reloads images after the first frame
    /// - Initializes UI animations
    @override
    void initState() {
        super.initState();
        initTts();

        final MediaController mediaController = Provider.of<MediaController>(context, listen: false);
        mediaController.hiveBoxName = widget.hiveBoxName;

        WidgetsBinding.instance.addPostFrameCallback((_) async {
            await mediaController.tryImportBackupAndInitialize(
                context,
                _lottieAnimator.play,
                _lottieAnimator.stop,
            );

            mediaController.reloadMediaImages();
        });
        initAnimations();
    }
    // %%%%%%%%%%%%%%%%%%%%%% END - INIT %%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%% INIT ANIMATIONS %%%%%%%%%%%%%%%%%%%
    /// Initializes both animation controllers and their respective [Animation<double>] instances.
    /// 
    /// 🎞 Animations :
    /// - [_inverseListRotationAnim] animates from 0° to 180°
    ///   → Used to rotate the inverse button when the list order is changed.
    /// - [_refreshListRotationAnim] animates from 0° to 360°
    ///   → Used to rotate the refresh button when the list is reloaded.
    ///
    /// Both animations are linked to their respective [AnimationController]s,
    /// which trigger a [setState()] on every tick to refresh the UI frame.
    ///
    /// ⚠️ Duration is hardcoded (600ms) for both animations.
    /// ⚠️ `vsync` is provided by [TickerProviderStateMixin].
    void initAnimations () {

        _inverseAnimationController = AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 600),
        );
        
        _refreshAnimationController = AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 600),
        );

        _inverseListRotationAnim = Tween<double>(begin: 0, end: 180)
            .animate(CurvedAnimation(
                parent: _inverseAnimationController, 
                curve: Curves.easeInOut,
            ));
        
        _refreshListRotationAnim = Tween<double>(begin: 0, end: 360)
            .animate(CurvedAnimation(
                parent: _refreshAnimationController, 
                curve: Curves.easeInOut,
            ));

        _inverseAnimationController.addListener(() {
            setState(() {}); // Forces widget to rebuild during animation
        });
        
        _refreshAnimationController.addListener(() {
            setState(() {}); // Same for refresh animation
        });
    }
    // %%%%%%%%%%%%%%%%%%% END - INIT ANIMATIONS %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% ANIMATE BUTTON AND REVERSE THE LIST %%%%%%%%%%%%%%
    /// Animates the "invert list" button and reverses the media list content.
    ///
    /// 🌀 If the animation is already playing or completed → it reverses.
    /// 🔁 Otherwise → it plays forward.
    ///
    /// After toggling the animation, it updates the list via [MediaController.reverseList()].
    ///
    /// ✅ Smooth transition ensured by the animation.
    /// ✅ List content instantly reversed from controller logic.
    void animateButonAndReverseTheList () {

        if (_inverseAnimationController.isForwardOrCompleted) {
            _inverseAnimationController.reverse();
        } else {
            _inverseAnimationController.forward();
        }

        final MediaController mediaController = Provider.of<MediaController>(context, listen: false);
        mediaController.reverseList();
    }
    // %%%%%%%%%%%%%%%%%%%% END - ANIMATE BUTTON AND REVERSE THE LIST %%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% ANIMATE BUTTON AND REFRESH THE LIST %%%%%%%%%%%%%%
    /// 𝐀𝐧𝐢𝐦𝐚𝐭𝐞𝐬 𝐭𝐡𝐞 "𝐫𝐞𝐟𝐫𝐞𝐬𝐡" 𝐛𝐮𝐭𝐭𝐨𝐧 𝐚𝐧𝐝 𝐫𝐞𝐥𝐨𝐚𝐝𝐬 𝐭𝐡𝐞 𝐦𝐞𝐝𝐢𝐚 𝐥𝐢𝐬𝐭.
    ///
    /// This method triggers the refresh animation and reinitializes the media list.
    ///
    /// Internally:
    /// - Resets and plays the `_refreshAnimationController` to display a spinning icon.
    /// - Calls `MediaController.initialize` to re-fetch or reload media items.
    /// - Then calls `reloadMediaImages()` to reload thumbnails or cover images from disk.
    ///
    /// Parameters: None
    ///
    /// Returns: void
    ///
    /// Notes:
    /// - The `initialize` method accepts callbacks to control a loading animation.
    /// - This action is typically bound to a refresh button or pull-to-refresh gesture.
    ///
    /// Usage example:
    /// ```dart
    /// animateButtonAndRefreshTheList();
    /// ```
    void animateButtonAndRefreshTheList () {
        _refreshAnimationController.reset();
        _refreshAnimationController.forward();

        final MediaController mediaController = Provider.of<MediaController>(context, listen: false);

        mediaController.initialize(
            playAnimation: _lottieAnimator.play,
            stopAnimation: _lottieAnimator.stop,
        );

        mediaController.reloadMediaImages();
    }
    // %%%%%%%%%%%%%%%%%%%% END - ANIMATE BUTTON AND REFRESH THE LIST %%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%% GET APPROPRIATE IMAGE WIDGET %%%%%%%%%%%%%%%%%%%
    /// 𝐑𝐞𝐭𝐮𝐫𝐧𝐬 𝐭𝐡𝐞 𝐚𝐩𝐩𝐫𝐨𝐩𝐫𝐢𝐚𝐭𝐞 𝐰𝐢𝐝𝐠𝐞𝐭 𝐟𝐨𝐫 𝐫𝐞𝐧𝐝𝐞𝐫𝐢𝐧𝐠 𝐚 𝐌𝐞𝐝𝐢𝐚 𝐢𝐦𝐚𝐠𝐞.
///
/// Checks whether the image file exists at the specified `Media.imagePath`.
/// If the file exists, it displays it using an `Image.file`.  
/// Otherwise, a fallback icon is shown.
///
/// Parameters:
/// - `media` : The `Media` object containing the image path to check.
///
/// Returns:
/// - `Widget` : Either an `Image.file` widget (when path is valid),
///              or a fallback `Icon` when the file does not exist.
///
/// Usage example:
/// ```dart
/// Widget cover = getAppropriateImageWidget(media);
/// ```
    Widget getAppropriateImageWidget (Media media) {
        final file = File(media.imagePath);

        if (file.existsSync()) {
            return Image.file(
                File(media.imagePath),
                fit: BoxFit.cover,
            );
        } else {
            return Align(
                alignment: Alignment.center,
                child: Icon(
                    Icons.image_not_supported_rounded, 
                    size: 100,
                ),
            );
        }
    }
    // %%%%%%%%%%%%%%%%%%%%% END - GET APPROPRIATE IMAGE WIDGET %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%% INIT TTS %%%%%%%%%%%%%%%%%
    /// 𝐈𝐧𝐢𝐭𝐢𝐚𝐥𝐢𝐳𝐞𝐬 𝐭𝐡𝐞 𝐓𝐓𝐒 𝐬𝐞𝐫𝐯𝐢𝐜𝐞 𝐚𝐧𝐝 𝐬𝐞𝐭𝐬 𝐮𝐩 𝐬𝐭𝐚𝐭𝐞 𝐡𝐚𝐧𝐝𝐥𝐞𝐫𝐬.
    ///
    /// This method initializes the `TtsService` and defines the behavior
    /// for `onStart`, `onCompletion`, and `onCancel` callbacks.
    ///
    /// These callbacks manipulate the `_isReadingStates` map to reflect
    /// whether a media item is currently being read.
    ///
    /// Parameters: None
    ///
    /// Returns: void
    ///
    /// Notes:
    /// - Uses `GetIt` to retrieve the current `MediaController` instance.
    /// - Updates UI via `setState` when reading starts/stops.
    ///
    /// Usage example:
    /// ```dart
    /// initTts(); // typically called in initState
    /// ```
    void initTts () {
        final MediaController mediaController = GetIt.instance<MediaController>();
        _tts = TtsService(

            onStart: () => setState(() {
                for (var media in mediaController.mediaList) {
                    _isReadingStates[media.uniqueId] = (_selectedMediaForReading != null && _selectedMediaForReading?.uniqueId == media.uniqueId);
                }
            }),

            onCompletion: () => setState(() {
                for (var media in mediaController.mediaList) {
                    _isReadingStates[media.uniqueId] = false;
                }
            }),

            onCancel: () => setState(() {
                for (var media in mediaController.mediaList) {
                    _isReadingStates[media.uniqueId] = false;
                }
            }),
        );
    }
    // %%%%%%%%%%%%%%%%%%% END - INIT TTS %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%% READ OR STOP SYNOPSIS %%%%%%%%%%%%%%%%%
    /// 𝐒𝐭𝐚𝐫𝐭𝐬 𝐨𝐫 𝐬𝐭𝐨𝐩𝐬 𝐫𝐞𝐚𝐝𝐢𝐧𝐠 𝐭𝐡𝐞 𝐬𝐲𝐧𝐨𝐩𝐬𝐢𝐬 𝐨𝐟 𝐚 𝐦𝐞𝐝𝐢𝐚.
    ///
    /// This method toggles the TTS playback for the selected media description.
    ///
    /// - If the media is currently being read, TTS is stopped.
    /// - Otherwise, TTS starts reading its description.
    ///
    /// Parameters:
    /// - `media` : The `Media` object whose synopsis should be read or stopped.
    ///
    /// Returns: void
    ///
    /// Notes:
    /// - This method updates `_selectedMediaForReading` before acting.
    /// - TTS feedback and UI state changes are handled via `TtsService` callbacks.
    ///
    /// Usage example:
    /// ```dart
    /// readOrStopSynopsis(myMedia);
    /// ```
    void readOrStopSynopsis (Media media) async {
        _selectedMediaForReading = media;
        if (_isReadingStates[media.uniqueId] == true) {
            _tts.stop();
        } else {
            _tts.read(media.description);
        }
    }
    // %%%%%%%%%%%%%%%%%%% END - READ OR STOP SYNOPSIS %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%%% DISPOSE %%%%%%%%%%%%%%%%%%
    @override void dispose() {
        _inverseAnimationController.dispose();
        _refreshAnimationController.dispose();
        _tts.stop();
        super.dispose();
    }
    // %%%%%%%%%%%%%%%%%%%%%%%%% END - DISPOSE %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%%%%%%
    @override
    Widget build(BuildContext context) {

        final MediaController mediaController = Provider.of<MediaController>(context);

        return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(

                // oooooooooooooooooooo BODY oooooooooooooooooo
                body: Padding(
                    
                    padding: EdgeInsets.fromLTRB(15, 20, 15, 0), 

                    child: Column(
                        spacing: 20,
                        children: [

                            // :::::-:::::-:-- SEARCH BAR :::::-:::::-:--
                            TextField(
                                onChanged: (value) => mediaController.search(value),
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                    fontSize: 14,
                                ),
                                cursorColor: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.5),

                                decoration: InputDecoration(
                                    hintText: "Search here...",

                                    labelStyle: TextStyle(
                                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha:1.0),
                                        fontSize: 12,
                                    ),

                                    hintStyle: TextStyle(
                                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.6),
                                        fontSize: 12,
                                    ),

                                    prefixIcon: Icon(
                                        Icons.search,
                                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                        size: 20,
                                    ),

                                    filled: true,
                                    fillColor: Theme.of(context).colorScheme.surfaceContainer.withValues(alpha:0.6),
                                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),

                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(70),
                                        borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                                            width: 0.5,
                                        ),
                                    ),

                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(70),
                                        borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                            width: 0.5,
                                        ),
                                    ),

                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(70),
                                        borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 1.0),
                                            width: 0.5,
                                        ),
                                    ),
                                ),
                            ),
                            // :::::-:::::-:-- END - SEARCH BAR :::::-:::::-:--


                            // ::--::::::-::-::--::: LIST ACTION BUTTONS ::--::::::-::-::--:::
                            Row(
                                spacing: 5,
                                children: [
                                    Text(
                                        "Sort by",
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: Theme.of(context).colorScheme.onSurface,
                                            fontWeight: FontWeight.w600
                                        ),
                                    ),

                                    SizedBox(width: 5),

                                    // °°°°°°°°°°°°°° SORT BUTTONS °°°°°°°°°°°°°°°°°
                                    Flexible(
                                        fit: FlexFit.loose, 
                                        child: ToggleButtonGroup(
                                            buttons: mediaController.sortButtons,
                                            onChanged: (selectedIndex, buttons) => mediaController.sortBy(selectedIndex, buttons),
                                        ),
                                    ),
                                    // °°°°°°°°°°°°°° END - SORT BUTTONS °°°°°°°°°°°°°°°°°

                                    // SizedBox(width: 5),
                                    Container(
                                        width: 2,
                                        height: 30,
                                        color: Theme.of(context).colorScheme.surfaceContainerHigh,
                                    ),

                                    // °°°°°°°°°°°°°°°° REVERSE BUTTON °°°°°°°°°°°°°°°°°°°
                                    Transform.rotate(
                                        angle: _inverseListRotationAnim.value * pi / 180,

                                        child: IconButton(
                                            onPressed: animateButonAndReverseTheList, 
                                            iconSize: 30,

                                            icon: Icon(
                                                Icons.swap_vertical_circle, 
                                                color: Theme.of(context).colorScheme.surfaceContainerHigh,          
                                            ),
                                        ),
                                    ),
                                    // °°°°°°°°°°°°°°°° END - REVERSE BUTTON °°°°°°°°°°°°°°°°°°°

                                    // SizedBox(width: 5),

                                    // °°°°°°°°°°°°°°°° REFRESH BUTTON °°°°°°°°°°°°°°°°°°°
                                    Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.identity()
                                            ..scale(-1.0, 1.0)
                                            ..rotateZ(-_refreshListRotationAnim.value * pi / 180),

                                        child: IconButton(
                                            onPressed: animateButtonAndRefreshTheList, 
                                            iconSize: 30,
                                            icon: Icon(
                                                Icons.replay_circle_filled_rounded,
                                                color: Theme.of(context).colorScheme.surfaceContainerHigh, 
                                            ),
                                        ),
                                    ),
                                    // °°°°°°°°°°°°°°°° END - REFRESH BUTTON °°°°°°°°°°°°°°°°°°° 
                                ],
                            ),
                            // ::--::::::-::-::--::: END - LIST ACTION BUTTONS ::--::::::-::-::--:::


                            // ::--::::::-::-::--::: LIST VIEW ::--::::::-::-::--:::
                            Expanded(

                                child: _lottieAnimator.builder(
                                    lottieFilePath: "assets/lottie/loading_anim.json",  
                                    backgroundColor: Theme.of(context).colorScheme.surfaceContainer, 
                                    backgroundOpacity: .5,
                                    width: 100, 
                                    height: 100,

                                    child: ListView.builder(
                                        itemCount: mediaController.mediaList.length,
                                    
                                        itemBuilder: (context, index) {
                                          final media = mediaController.mediaList[index];
                                  
                                            return Stack(
                                                children: [
                                                    InkWell(
                                                                                
                                                        // °°°°°°°°°°°°° ON MEDIA SELECTED °°°°°°°°°°°°°°°°°
                                                        onTap: () => Navigator.of(context).pushNamed(
                                                            "/mediaDetails",
                                                            arguments: {'media': media,},
                                                        ),
                                                        // °°°°°°°°°°°°° END - ON MEDIA SELECTED °°°°°°°°°°°°°°°°°
                                                        
                                                        child: Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                                                                                    
                                                            // °°°°°°°°°°°°° CARD MADE UP OF SLIDES WITH AUTO-SWITCH °°°°°°°°°°°°°°°°°
                                                            child: MediaCarouselCard(
                                                                title: media.title,
                                                                height: 400,
                                                                                    
                                                                slides: [
                                                                    // ============= IMAGE ===================
                                                                    MediaCarouselCardSlide(
                                                                        heightFactor: 1.0,
                                                                        content: SizedBox.expand(
                                                                            child: getAppropriateImageWidget(media), 
                                                                            // child: Image.file(File(media.imagePath), fit: BoxFit.cover), 
                                                                        ),    
                                                                    ),
                                                                    // ============= END - IMAGE ===================
                                                                                    
                                                                    // ================ SYNOPSIS _ RATE _ CURRENT SEASON AND EPISODE ==============
                                                                    MediaCarouselCardSlide(
                                                                        heightFactor: 1,
                                                                        content: Container(
                                                                                    
                                                                            padding: const EdgeInsets.only(
                                                                                left: 10,
                                                                                top: 10,
                                                                                right: 10,
                                                                                bottom: 60,
                                                                            ),
                                                                                    
                                                                            color: Theme.of(context).colorScheme.surfaceContainer,
                                                                                    
                                                                            child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        
                                                                                children: [
                                                                                    // ---------- DESCRIPTION -------------
                                                                                    Text(
                                                                                        media.description,
                                                                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                                            color: Theme.of(context).colorScheme.onSurface,
                                                                                        ), 
                                                                                        
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        maxLines: 4,
                                                                                    ),
                                                                                    // ---------- END - DESCRIPTION -------------
                                                                                        
                                                                                    SizedBox(height: 20),
                                                    
                                                                                    // --------------- GENRE ---------------
                                                                                    if (media.mediaGenre != null)
                                                                                        Text(
                                                                                            "Genre: ${media.mediaGenre?.formattedName}",
                                                                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                                                color: Theme.of(context).colorScheme.onSurface,
                                                                                                fontWeight: FontWeight.w600,
                                                                                            ), 
                                                                                        ),
                                                                                    // --------------- END - GENRE ---------------
                                                    
                                                                                    // --------------- WATCH STATUS ---------------
                                                                                    if (media.watchStatus != null)
                                                                                        Text(
                                                                                            "Status: ${media.watchStatus?.formattedName}",
                                                                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                                                color: Theme.of(context).colorScheme.onSurface,
                                                                                                fontWeight: FontWeight.w600,
                                                                                            ), 
                                                                                        ),
                                                                                    // --------------- END - WATCH STATUS ---------------
                                                    
                                                                                    SizedBox(height: 20),
                                                                                        
                                                                                    // --------------- RATE ---------------
                                                                                    Text(
                                                                                        "Your rating: ${media.rate ?? 'N/A'}",
                                                                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                                            color: Theme.of(context).colorScheme.onSurface
                                                                                        ), 
                                                                                    ),
                                                                                    // --------------- END - RATE ---------------
                                                                                        
                                                                                    SizedBox(height: 20),
                                                                                        
                                                                                    // ---------- CURRENT SEASON AND EPISODE ---------
                                                                                    if (media.currentSeasonIndex != null || media.currentEpisodeIndex != null)
                                                                                        Text(
                                                                                            "Where you are:",
                                                                                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                                                                fontSize: 14
                                                                                            ), 
                                                                                        ),
                                                                                        
                                                                                    // ________ CURENT SEASON
                                                                                    if (media.currentSeasonIndex != null)
                                                                                        Text(
                                                                                            "Season ${media.currentSeasonIndex ?? '--'}",
                                                                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                                                color: Theme.of(context).colorScheme.onSurface
                                                                                            ), 
                                                                                        ),
                                                                                    // ________ END - CURENT SEASON
                                                                                        
                                                                                    // _________ CURRENT EPISODE 
                                                                                    if (media.currentEpisodeIndex != null)
                                                                                        Text(
                                                                                            "Episode: ${media.currentEpisodeIndex ?? '--'}",
                                                                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                                                color: Theme.of(context).colorScheme.onSurface
                                                                                            ), 
                                                                                        ),
                                                                                    // _________ END - CURRENT EPISODE 
                                                                                        
                                                                                    // ---------- CURRENT SEASON AND EPISODE ---------
                                                                                ],
                                                                            ),
                                                                        ),    
                                                                    ),
                                                                    // ================ END - SYNOPSIS _ RATE _ CURRENT SEASON AND EPISODE ==============
                                                                ],
                                                                                    
                                                                // °°°°°°°°°°°°° END - CARD MADE UP OF SLIDES WITH AUTO-SWITCH °°°°°°°°°°°°°°°°°
                                                                                    
                                                                                    
                                                                // °°°°°°°°°°°°°°°°° EDIT THE MEDIA °°°°°°°°°°°°°°°°°°°°
                                                                onEdit: () => mediaController.goToEditMedia(context, media),
                                                                
                                                                // °°°°°°°°°°°° END - EDIT THE MEDIA °°°°°°°°°°°°°°°°°°°°
                                                                                    
                                                                                    
                                                                // °°°°°°°°°°°°°° DELETE THE MEDIA °°°°°°°°°°°°°°°°°°
                                                                onDelete: () => mediaController.deleteInList(context, media),
                                                                // °°°°°°°°°°°° END - DELETE THE MEDIA °°°°°°°°°°°°°°°°°°
                                                            )
                                                        )
                                                    ),

                                                    
                                                    // °°°°°°°°°°°°°°°°° READ/STOP SYNOPSIS °°°°°°°°°°°°°°°°°
                                                    Positioned(
                                                        bottom: 120,
                                                        right: 15,
                                                        
                                                        child: Container(
                                                            decoration: BoxDecoration(
                                                                color: Theme.of(context).colorScheme.primary,
                                                                borderRadius: BorderRadius.circular(100),

                                                                boxShadow: [
                                                                    BoxShadow(
                                                                        blurRadius: 1,
                                                                        offset: Offset(5, 5),
                                                                        color: Colors.black38,
                                                                    ),
                                                                ],
                                                            ),

                                                            child: IconButton(
                                                            onPressed: () => readOrStopSynopsis(media),

                                                            icon: Icon(
                                                                _isReadingStates[media.uniqueId] == true ? 
                                                                    Icons.stop_rounded : 
                                                                    Icons.play_arrow_rounded, 

                                                                color: Colors.white,
                                                            ),
                                                        ),
                                                    ),
                                                    )
                                                    // °°°°°°°°°°°°°°°°° END - READ/STOP SYNOPSIS °°°°°°°°°°°°°°°°°
                                                ],
                                            );
                                      }
                                    ),
                                ),
                                
                            ),
                                // ::--::::::-::-::--::: END - LIST VIEW ::--::::::-::-::--:::
                        ],
                    ),
                )
            ),
                // oooooooooooooooooooo END - BODY oooooooooooooooooo
        );
    }
    // %%%%%%%%%%%%%%%%%% END - BUILD %%%%%%%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@@@@@@@@@ END - STATE @@@@@@@@@@@@@@@@@@@@@@@@@@@@