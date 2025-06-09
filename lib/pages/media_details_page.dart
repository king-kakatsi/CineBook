import 'dart:io';
import 'dart:math';

import 'package:first_project/extensions/enum_extensions.dart';
import 'package:first_project/services/tts_service.dart';
import 'package:first_project/themes/color_palette.dart';
import 'package:first_project/controllers/media_controller.dart';
import 'package:first_project/models/media.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


// @@@@@@@@@@@@@@@@@@@@@@@@@@@@ STATEFUL WIDGET @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
/// **Media Details Page Widget**
/// 
/// A stateful widget that displays detailed information about a media item with
/// a draggable bottom sheet interface. Features include media image background,
/// interactive controls for editing/deleting, and text-to-speech functionality
/// for the synopsis.
/// 
/// The widget uses a custom draggable animation system where users can drag
/// the information panel up and down, with automatic snapping to open/closed positions.
class MediaDetailsPage extends StatefulWidget {

    // %%%%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%
    /// The media object containing all information to display
    final Media media;
    // %%%%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%%
    /// **Constructor for MediaDetailsPage**
    /// 
    /// Parameters:
    /// - key: Widget key for Flutter's widget tree
    /// - media: Required Media object containing the details to display
    const MediaDetailsPage ({
        super.key,
        required this.media
    });
    // %%%%%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%% CREATE STATE %%%%%%%%%%%%%%%%%
    @override State<MediaDetailsPage> createState() => MediaDetailsPageState();
    // %%%%%%%%%%%%%%%%% END - CREATE STATE %%%%%%%%%%%%%%%%%
}

// @@@@@@@@@@@@@@@@@@@@@@@@@@@@ END - STATEFUL WIDGET @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@





// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ STATE OF STATEFUL WIDGET @@@@@@@@@@@@@@@@@@@@@@@@@
/// **State class for MediaDetailsPage**
/// 
/// Manages the complex draggable bottom sheet animation system and text-to-speech
/// functionality. Uses SingleTickerProviderStateMixin for animation control.
class MediaDetailsPageState extends State<MediaDetailsPage> with SingleTickerProviderStateMixin {

    // %%%%%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%
    /// Animation controller for managing the draggable sheet animations
    late final AnimationController _animationController;
    /// Animation for the vertical translation of the bottom sheet
    late Animation<double> _bottomSheetTransalteYAnim;
    /// Animation for the opacity changes of the bottom sheet content
    late Animation<double> _bottomSheetOpacityAnim;
    /// Tween for position interpolation during animations
    late Tween<double> _positionTween;
    /// Tween for opacity interpolation during animations
    late Tween<double> _opacityTween;

    /// Factor determining the closed position relative to screen height (0.9 = 90% down)
    late double _closeSheetPositionFactor;
    /// Factor determining the open position relative to screen height (0.2 = 20% down)
    late double _openSheetPositionFactor;
    
    /// Absolute Y position when sheet is fully open
    late  final double _openBottomSheetPosY;
    /// Absolute Y position when sheet is fully closed
    late final double _closeBottomSheetPosY;

    /// Constant value that keeps the initial position of the draggable conatainer
    late double _initBottomSheetPosY; 
    /// Constant value that keeps the top limit the draggable container can't pass
    late final double _topLimitPos; 
    /// Indicates the distance between the top and the bottom limits of the daggable container
    late final double _bottomSheetMotionAreaHeight;

    /// Constant value that keeps the bottom limit the draggable container can't pass
    late final double _bottomLimitPos; 
    /// Current Y position of the draggable sheet during runtime
    late double _currentBottomSheetPosY;
    /// Current opacity value of the sheet content during runtime
    late double _currentBottomSheetOpacity;

    /// Flag indicating if the user is currently dragging the sheet
    bool _isDragging = false;
    
    /// Text-to-speech service instance for reading the synopsis
    late final TtsService _tts;
    /// Flag indicating if TTS is currently reading the synopsis
    bool _isReadingSynopsis = false;

    /// Duration of animations in milliseconds
    late final int _animationDuration;
    /// Global key for accessing the bottom sheet's render box
    final GlobalKey bottomSheetKey = GlobalKey();
    // %%%%%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%% INIT STATE %%%%%%%%%%%%%%%%%%%%%%
    @override
    void initState() {
        super.initState();
        initTts();
        initAnimations(context);
    }
    // %%%%%%%%%%%%%%%%%%% END - INIT STATE %%%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%% INIT ANIMATIONS %%%%%%%%%%%%%%%%%%%
    /// **Initializes the draggable animation system**
    /// 
    /// Sets up all animation controllers, position calculations, and constraints
    /// for the draggable bottom sheet. Uses post-frame callback to get accurate
    /// positioning after widget layout is complete.
    /// 
    /// Parameters:
    /// - context: BuildContext for accessing screen dimensions and theme
    void initAnimations (BuildContext context) {

        _animationDuration = 600;

        _closeSheetPositionFactor = .9;
        _openSheetPositionFactor = .2;

        _initBottomSheetPosY = 0;
        _currentBottomSheetOpacity = 1;

        // Wait for widget to be laid out before calculating positions
        WidgetsBinding.instance.addPostFrameCallback((_) {

            final RenderBox box = bottomSheetKey.currentContext!.findRenderObject() as RenderBox;
            final Offset position = box.localToGlobal(Offset.zero);

            _initBottomSheetPosY = position.dy;
            _currentBottomSheetPosY = _initBottomSheetPosY;

            _closeBottomSheetPosY = _closeSheetPositionFactor * (MediaQuery.of(context).size.height);
            var tempVar = _openSheetPositionFactor * (MediaQuery.of(context).size.height);
            _openBottomSheetPosY = tempVar > _initBottomSheetPosY ? _initBottomSheetPosY : tempVar;

            _topLimitPos = max(_openBottomSheetPosY - _initBottomSheetPosY, 0);
            _bottomLimitPos = max(_closeBottomSheetPosY - _initBottomSheetPosY, 0);

            _bottomSheetMotionAreaHeight = _bottomLimitPos - _topLimitPos;
        });

        _currentBottomSheetPosY = _initBottomSheetPosY;

        _animationController = AnimationController(
            vsync: this,
            duration: Duration(milliseconds: _animationDuration),
        );

        _bottomSheetTransalteYAnim = AlwaysStoppedAnimation(_currentBottomSheetPosY);
        _bottomSheetOpacityAnim = AlwaysStoppedAnimation(_currentBottomSheetOpacity);

        _animationController.addListener(() {
            setState(() {});
        });
    }
    // %%%%%%%%%%%%%%%%%%% END - INIT ANIMATIONS %%%%%%%%%%%%%%%%%%%



    
    // %%%%%%%%%%%%%%%%%% DRAG BOTTOM SHEET %%%%%%%%%%%%%%%%%
    /// **Handles dragging of the bottom sheet**
    /// 
    /// Updates the position and opacity of the bottom sheet in real-time as the user drags.
    /// Constrains movement within defined limits and calculates opacity based on position.
    /// 
    /// Parameters:
    /// - details: DragUpdateDetails containing delta movement information
    void dragBottomSheet (DragUpdateDetails details) {

        // Stop any running animation and capture current position
        if (!_isDragging) {
            _animationController.stop();
            _currentBottomSheetPosY = _bottomSheetTransalteYAnim.value;
        }

        var tempPosY = _currentBottomSheetPosY + details.delta.dy;

        // Calculate opacity based on position within motion area
        double newOpacity = _currentBottomSheetOpacity - (details.delta.dy / _bottomSheetMotionAreaHeight);

        setState(() {
            _isDragging = true;  
            _currentBottomSheetPosY = tempPosY.clamp(_topLimitPos, _bottomLimitPos);
            _currentBottomSheetOpacity = newOpacity.clamp(0.0, 1.0);
        });
    }
    // %%%%%%%%%%%%%%%%%% END - DRAG BOTTOM SHEET %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% END DRAGGING BOTTOM SHEET %%%%%%%%%%%%%%
    /// **Handles the end of bottom sheet dragging**
    /// 
    /// Called when user releases their finger after dragging. Resets the dragging flag
    /// and triggers the snap animation to the nearest position (open/closed).
    /// 
    /// Parameters:
    /// - details: DragEndDetails containing velocity and other end-drag information
    void endDraggingBottomSheet (DragEndDetails details) {
        setState(() {
          _isDragging = false;
        });
        animateDraggableSheet();
    }
    // %%%%%%%%%%%%%%%%%% END - END DRAGGING BOTTOM SHEET %%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% ANIMATE DRAGGABLE BOTTOM SHEET %%%%%%%%%%%%%%%%
    /// **Animates the bottom sheet to its target position**
    /// 
    /// Determines whether to snap to open or closed position based on current location
    /// relative to the middle point. Creates smooth animations for both position and opacity.
    /// 
    /// Parameters:
    /// - wasDragged: Boolean indicating if this animation was triggered by drag end (default: true)
    void animateDraggableSheet({bool wasDragged = true}) {

        // Calculate middle point to determine snap direction
        double middleY = _openBottomSheetPosY + ((_closeBottomSheetPosY - _openBottomSheetPosY) / 2);  
        middleY = (middleY - _initBottomSheetPosY).clamp(_topLimitPos, _bottomLimitPos);

        // Determine target position and opacity based on current position relative to middle
        double targetPosY = middleY >= _currentBottomSheetPosY ? _openBottomSheetPosY : _closeBottomSheetPosY;
        double targetOpacity = middleY >= _currentBottomSheetPosY ? 1.0 : 0.0;

        // Setup position animation
        _positionTween = Tween<double>(
            begin: _currentBottomSheetPosY,
            end: (targetPosY - _initBottomSheetPosY).clamp(_topLimitPos, _bottomLimitPos),
        );

        _bottomSheetTransalteYAnim = _positionTween.animate(
            CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeInOut,
            ),
        );

        // Setup opacity animation
        _opacityTween = Tween<double>(
            begin: _currentBottomSheetOpacity,
            end: targetOpacity,
        );
        
        _bottomSheetOpacityAnim = _opacityTween.animate(
            CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeInOut,
            ),
        );

        _animationController.forward();
        _currentBottomSheetPosY = targetPosY;
        _currentBottomSheetOpacity = targetOpacity;
    }
    // %%%%%%%%%%%%%%%%%% END - ANIMATE DRAGGABLE BOTTOM SHEET %%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%% INIT TTS %%%%%%%%%%%%%%%%%
    /// **Initializes the Text-to-Speech service**
    /// 
    /// Sets up TTS with callback handlers for start, completion, and cancellation events.
    /// Updates the UI state accordingly when TTS status changes.
    void initTts () {
        _tts = TtsService(
            onStart: () => setState(() {_isReadingSynopsis = true;}),
            onCompletion: () => setState(() {_isReadingSynopsis = false;}),
            onCancel: () => setState(() {_isReadingSynopsis = false;}),
        );
    }
    // %%%%%%%%%%%%%%%%%%% END - INIT TTS %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%% READ OR STOP SYNOPSIS %%%%%%%%%%%%%%%%%
    /// **Toggles Text-to-Speech for the media synopsis**
    /// 
    /// If TTS is currently reading, stops it. If not reading, starts reading
    /// the media description using the TTS service.
    void readOrStopSynopsis () async {

        if (_isReadingSynopsis) {
            _tts.stop();
        } else {
            _tts.read(widget.media.description);
        }      
    }
    // %%%%%%%%%%%%%%%%%%% END - READ OR STOP SYNOPSIS %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%%% DISPOSE %%%%%%%%%%%%%%%%%%
    @override void dispose() {
        _animationController.dispose();
        _tts.stop();
        super.dispose();
    }
    // %%%%%%%%%%%%%%%%%%%%%%%%% END - DISPOSE %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%%%%%
    @override
    Widget build(BuildContext context) {
        final MediaController controller = Provider.of<MediaController>(context);

        return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,

            // °°°°°°°°°°°°°°°°° IMAGE AS BACKGROUND FOR THE CONTAINER °°°°°°°°°°°
            decoration: BoxDecoration(
                image: DecorationImage(
                    // Use local image if available, otherwise use network image
                    image: widget.media.imagePath.isEmpty? 
                        NetworkImage(widget.media.imageUrl) as ImageProvider : 
                        FileImage(File(widget.media.imagePath)),

                    fit: BoxFit.cover
                )
            ),
            // °°°°°°°°°°°°°°°°° END - IMAGE AS BACKGROUND FOR THE CONTAINER °°°°°°°°°°°

            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                    // °°°°°°°°°°°°°°°°°° POP BUTTON °°°°°°°°°°°°°°°°°
                    Container(
                        margin: EdgeInsets.only(
                            top: 50,
                            left: 15,
                        ),

                        padding: EdgeInsets.only(
                            left: 10,
                            top: 3,
                            bottom: 3,
                            ),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: .8),
                            borderRadius: BorderRadius.circular(15),
                        ),

                        child: IconButton(
                            onPressed: () => Navigator.of(context).pop(), 

                            icon: Icon(
                                Icons.arrow_back_ios,
                                size: 30,
                                color: Theme.of(context).colorScheme.onPrimary,
                            ),
                        ),
                    ),
                    // °°°°°°°°°°°°°°°°°° END - POP BUTTON °°°°°°°°°°°°°°°°°

                    Expanded(child: SizedBox()),

                    // °°°°°°°°°°°°°°° INFORATIONS °°°°°°°°°°°°°°°°°°
                    Transform(
                        key: bottomSheetKey,
                        // Apply translation transform based on current drag state or animation
                        transform: Matrix4.identity()
                            ..translate(
                                0.0, 
                                _isDragging? _currentBottomSheetPosY : _bottomSheetTransalteYAnim.value
                            ),

                        child: GestureDetector(
                            onPanUpdate: dragBottomSheet,
                            onPanEnd: endDraggingBottomSheet,

                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.start,

                                        children: [
                                            // ============== TITLE ===============
                                            Container(
                                                width: MediaQuery.of(context).size.width * .5,
                                                padding: EdgeInsets.only(
                                                    left: 15,
                                                    top: 10,
                                                    right: 20,
                                                    bottom: 10
                                                ),

                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(
                                                        topRight: Radius.circular(40),
                                                        bottomRight: Radius.circular(40),
                                                    ),
                                                    
                                                    color: Theme.of(context).colorScheme.primary,

                                                    boxShadow: [

                                                        BoxShadow(
                                                            blurRadius: 1,
                                                            offset: Offset(5, 5),
                                                            color: Colors.black38,
                                                        ),
                                                    ],
                                                ),

                                                child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,

                                                    child: Text(
                                                        widget.media.title,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Theme.of(context).colorScheme.onPrimary,
                                                            decoration: TextDecoration.none,
                                                        ),
                                                    ),
                                                ),
                                            ),
                                            // ============== END - TITLE ===============

                                            SizedBox(width: 10,),

                                            // ================ ACTION BUTTONS =============
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [

                                                    // ---------- MODIFY -------------- 
                                                    Container(
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
                                                            onPressed: () => controller.goToEditMedia(context, widget.media),

                                                            icon: Icon(
                                                                Icons.edit, 
                                                                color: Colors.white,
                                                            ),
                                                        ),
                                                    ),
                                                    // ---------- END - MODIFY ------------- 

                                                    SizedBox(width: 10,),

                                                    // ---------- READ/STOP SYNOPSIS -------------- 
                                                    Container(
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
                                                            onPressed: () => readOrStopSynopsis(),

                                                            icon: Icon(
                                                                // Show stop icon when reading, play icon when not
                                                                _isReadingSynopsis ? 
                                                                    Icons.stop_rounded : 
                                                                    Icons.play_arrow_rounded, 

                                                                color: Colors.white,
                                                            ),
                                                        ),
                                                    ),
                                                    // ---------- END - READ/STOP SYNOPSIS --------- 

                                                    SizedBox(width: 10,),

                                                    // ---------- DELETE ---------------- 
                                                    Container(
                                                        decoration: BoxDecoration(

                                                            color: AppColors.deepVineRed,

                                                            borderRadius: BorderRadius.circular(100),

                                                            boxShadow: [

                                                                BoxShadow(
                                                                    blurRadius: 1,
                                                                    offset: Offset(5, 5),
                                                                    color: Colors.black38,
                                                                ),
                                                            ],
                                                        ),
                                                        // backgroundColor: AppColors.deepVineRed,

                                                        child: IconButton(
                                                            onPressed: () => controller.deleteFromDetailsPage(context, widget.media), 

                                                            icon: Icon(
                                                                Icons.delete,
                                                                color: Colors.white,
                                                            ),
                                                        ),
                                                    ), 
                                                    // ------------- END - DELETE -----------
                                                ],
                                            ),      
                                            // ================ END - ACTION BUTTONS =============
                                        ],
                                    ),
                                

                                    // =============== DESCRIPTION _ RATE _ CURRENT SEASON AND EPISODE ===============
                                    AnimatedOpacity(
                                        // Use current opacity during drag, animation value otherwise
                                        opacity: _isDragging? 
                                        _currentBottomSheetOpacity : 
                                        _bottomSheetOpacityAnim.value, 

                                        duration: Duration(milliseconds:  _animationDuration),

                                        child: Container(
                                            width: double.infinity,
                                            height: MediaQuery.of(context).size.height * .6,
                                            margin: EdgeInsets.only(top: 10),

                                            padding: EdgeInsets.symmetric(
                                                vertical: 30,
                                                horizontal: 15
                                            ),

                                            decoration: BoxDecoration(

                                                borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(80),
                                                ),

                                                // Use gradient from primary to surface container
                                                gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                        Theme.of(context).colorScheme.primary,
                                                        Theme.of(context).colorScheme.surfaceContainer,
                                                        Theme.of(context).colorScheme.surfaceContainer,
                                                    ],
                                                    stops: [0.0, 0.4, 1.0],
                                                ),
                                            ),

                                            child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,

                                                child: Column(

                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,

                                                    children: [

                                                        // --------------- GENRE ---------------
                                                        if (widget.media.mediaGenre != null)
                                                            Text(
                                                                "Genre: ${widget.media.mediaGenre?.formattedName}",
                                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                    color: Theme.of(context).colorScheme.onPrimary,
                                                                    fontWeight: FontWeight.w600,
                                                                ), 
                                                            ),
                                                        // --------------- END - GENRE ---------------

                                                        // --------------- WATCH STATUS ---------------
                                                        if (widget.media.watchStatus != null)
                                                            Text(
                                                                "Status: ${widget.media.watchStatus?.formattedName}",
                                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                    color: Theme.of(context).colorScheme.onPrimary,
                                                                    fontWeight: FontWeight.w600,
                                                                ), 
                                                            ),
                                                        // --------------- END - WATCH STATUS ---------------

                                                        SizedBox(height: 20),

                                                        // --------------- RATE ---------------
                                                        Text(
                                                            "Your rating: ${widget.media.rate ?? 'N/A'}",
                                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                color: Theme.of(context).colorScheme.onPrimary
                                                            ), 
                                                        ),
                                                        // --------------- END - RATE ---------------

                                                        SizedBox(height: 20),

                                                        // ---------- CURRENT SEASON AND EPISODE ---------
                                                        if (widget.media.currentSeasonIndex != null || widget.media.currentEpisodeIndex != null)
                                                            Text(
                                                                "Where you are:",
                                                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                                    fontSize: 14
                                                                ), 
                                                            ),

                                                        // ________ CURENT SEASON
                                                        if (widget.media.currentSeasonIndex != null)
                                                            Text(
                                                                "Season ${widget.media.currentSeasonIndex ?? '--'}",
                                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                    color: Theme.of(context).colorScheme.onSurface
                                                                ), 
                                                            ),
                                                        // ________ END - CURENT SEASON

                                                        // _________ CURRENT EPISODE 
                                                        if (widget.media.currentEpisodeIndex != null)
                                                            Text(
                                                                "Episode: ${widget.media.currentEpisodeIndex ?? '--'}",
                                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                    color: Theme.of(context).colorScheme.onSurface
                                                                ), 
                                                            ),
                                                        // _________ END - CURRENT EPISODE 

                                                        // ---------- CURRENT SEASON AND EPISODE ---------

                                                        SizedBox(height: 20),

                                                        // ---------- DESCRIPTION -------------
                                                        Text(
                                                            widget.media.description,
                                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                color: Theme.of(context).colorScheme.onSurface,
                                                            ), 
                                                        ),
                                                        // ---------- END - DESCRIPTION -------------
                                                    ],
                                                ),
                                            ),
                                        ),
                                    ) 
                                    // =============== END - DESCRIPTION _ RATE _ CURRENT SEASON AND EPISODE ===============
                                ],
                            ),
                        ),
                    ),
                    // °°°°°°°°°°°°°°° END - INFORATIONS °°°°°°°°°°°°°°°°°°
                ],
            ),   
        );
    }
    // %%%%%%%%%%%%%%%%%%% END - BUILD %%%%%%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ END - STATE OF STATEFUL WIDGET @@@@@@@@@@@@@@@@@@@@@@@@@