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

class MediaDetailsPage extends StatefulWidget {

    // %%%%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%
    final Media media;
    // %%%%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%%
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
class MediaDetailsPageState extends State<MediaDetailsPage> with SingleTickerProviderStateMixin {

    // %%%%%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%
    late final AnimationController _animationController;
    late Animation<double> _bottomSheetTransalteYAnim;
    late Animation<double> _bottomSheetOpacityAnim;
    late Tween<double> _positionTween;
    late Tween<double> _opacityTween;


    late double _closeSheetPositionFactor;
    late double _openSheetPositionFactor;
    
    late  final double _openBottomSheetPosY;
    late final double _closeBottomSheetPosY;

    /// Constant value that keeps the initial position of the draggable conatainer
    late double _initBottomSheetPosY; 
    /// Constant value that keeps the top limit the draggable container can't pass
    late final double _topLimitPos; 
    /// Indicates the distance between the top and the bottom limits of the daggable container
    late final double _bottomSheetMotionAreaHeight;

    /// Constant value that keeps the bottom limit the draggable container can't pass
    late final double _bottomLimitPos; 
    late double _currentBottomSheetPosY;
    late double _currentBottomSheetOpacity;

    bool _isDragging = false;
    
    late final TtsService _tts;
    bool _isReadingSynopsis = false;

    late final int _animationDuration;
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
    void initAnimations (BuildContext context) {

        _animationDuration = 600;

        _closeSheetPositionFactor = .9;
        _openSheetPositionFactor = .2;

        _initBottomSheetPosY = 0;
        _currentBottomSheetOpacity = 1;

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
    void dragBottomSheet (DragUpdateDetails details) {

        if (!_isDragging) {
            _animationController.stop();
            _currentBottomSheetPosY = _bottomSheetTransalteYAnim.value;
        }

        var tempPosY = _currentBottomSheetPosY + details.delta.dy;

        double newOpacity = _currentBottomSheetOpacity - (details.delta.dy / _bottomSheetMotionAreaHeight);

        setState(() {
            _isDragging = true;  
            _currentBottomSheetPosY = tempPosY.clamp(_topLimitPos, _bottomLimitPos);
            _currentBottomSheetOpacity = newOpacity.clamp(0.0, 1.0);
        });
    }
    // %%%%%%%%%%%%%%%%%% END - DRAG BOTTOM SHEET %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% END DRAGGING BOTTOM SHEET %%%%%%%%%%%%%%
    void endDraggingBottomSheet (DragEndDetails details) {
        setState(() {
          _isDragging = false;
        });
        animateDraggableSheet();
    }
    // %%%%%%%%%%%%%%%%%% END - END DRAGGING BOTTOM SHEET %%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% ANIMATE DRAGGABLE BOTTOM SHEET %%%%%%%%%%%%%%%%
    void animateDraggableSheet({bool wasDragged = true}) {

        double middleY = _openBottomSheetPosY + ((_closeBottomSheetPosY - _openBottomSheetPosY) / 2);  
        middleY = (middleY - _initBottomSheetPosY).clamp(_topLimitPos, _bottomLimitPos);

        double targetPosY = middleY >= _currentBottomSheetPosY ? _openBottomSheetPosY : _closeBottomSheetPosY;

        double targetOpacity = middleY >= _currentBottomSheetPosY ? 1.0 : 0.0;

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
    void initTts () {
        _tts = TtsService(
            onStart: () => setState(() {_isReadingSynopsis = true;}),
            onCompletion: () => setState(() {_isReadingSynopsis = false;}),
            onCancel: () => setState(() {_isReadingSynopsis = false;}),
        );
    }
    // %%%%%%%%%%%%%%%%%%% END - INIT TTS %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%% READ OR STOP SYNOPSIS %%%%%%%%%%%%%%%%%
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

                                                // color: Theme.of(context).colorScheme.primary,
                                                gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                        Theme.of(context).colorScheme.primary,
                                                        Theme.of(context).colorScheme.surfaceContainer
                                                    ],
                                                    stops: [0.0, 1.0],
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
                                                                    color: Theme.of(context).colorScheme.onSurface,
                                                                    fontWeight: FontWeight.w600,
                                                                ), 
                                                            ),
                                                        // --------------- END - GENRE ---------------

                                                        // --------------- WATCH STATUS ---------------
                                                        if (widget.media.watchStatus != null)
                                                            Text(
                                                                "Status: ${widget.media.watchStatus?.formattedName}",
                                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                    color: Theme.of(context).colorScheme.onSurface,
                                                                    fontWeight: FontWeight.w600,
                                                                ), 
                                                            ),
                                                        // --------------- END - WATCH STATUS ---------------

                                                        SizedBox(height: 20),

                                                        // --------------- RATE ---------------
                                                        Text(
                                                            "Your rating: ${widget.media.rate ?? 'N/A'}",
                                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                color: Theme.of(context).colorScheme.onSurface
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