import 'dart:io';
import 'dart:math';
import 'package:first_project/widgets/lottie_animator.dart';
import 'package:first_project/widgets/media_carousel_card.dart';
import 'package:first_project/widgets/toggle_button_group.dart';
import 'package:first_project/models/media.dart';
import 'package:first_project/controllers/media_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


// $$$$$$$$$$$$$$$$$$$ STATEFUL $$$$$$$$$$$$$$$$$$$$$$
class MediaListWidget extends StatefulWidget {

    // %%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%
    final Mediatype mediaType;
    final String pageTitle;
    final String hiveBoxName;
    final BuildContext context;
    // %%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%
    const MediaListWidget({

        super.key, 
        required this.context,
        required this.mediaType, 
        required this.pageTitle,
        required this.hiveBoxName
    });
    // %%%%%%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% CREATE STATE %%%%%%%%%%%%%%%%%%%%%%
    @override
    State<StatefulWidget> createState() => MediaListWidgetState();
    // %%%%%%%%%%%%%%%%%%%% END - CREATE STATE %%%%%%%%%%%%%%%%%%%%%%
}
// $$$$$$$$$$$$$$$$$$$ END - STATEFUL $$$$$$$$$$$$$$$$$$$$$$







// $$$$$$$$$$$$$$$$$$$$ STATE $$$$$$$$$$$$$$$$$$$$$$$$$$$$

class MediaListWidgetState extends State<MediaListWidget> with TickerProviderStateMixin{

    // %%%%%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%
    late final AnimationController _inverseAnimationController;
    late final AnimationController _refreshAnimationController;
    late  final Animation<double> _inverseListRotationAnim;
    late  final Animation<double> _refreshListRotationAnim;
    final LottieAnimator _lottieAnimator = LottieAnimator();
    // %%%%%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%% INIT %%%%%%%%%%%%%%%%%%%%%
    @override void initState() {
        super.initState();

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
    void initAnimations () {

        _inverseAnimationController = AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 600),
        );
        
        _refreshAnimationController = AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 600),
        );

        _inverseListRotationAnim = Tween<double>(begin: 0,end: 180,)
        .animate(CurvedAnimation(
            parent: _inverseAnimationController, 
            curve: Curves.easeInOut,
        ));
        
        _refreshListRotationAnim = Tween<double>(begin: 0,end: 360,)
        .animate(CurvedAnimation(
            parent: _refreshAnimationController, 
            curve: Curves.easeInOut,
        ));

        _inverseAnimationController.addListener(() {
            setState(() {});
        });
        
        _refreshAnimationController.addListener(() {
            setState(() {});
        });
    }
    // %%%%%%%%%%%%%%%%%%% END - INIT ANIMATIONS %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% ANIMATE BUTTON AND REVERSE THE LIST %%%%%%%%%%%%%%
    void animateButonAndReverseTheList () {

        if (_inverseAnimationController.isForwardOrCompleted) {
                _inverseAnimationController.reverse();
        } else{
            _inverseAnimationController.forward();
        }

        final MediaController mediaController = Provider.of<MediaController>(context, listen: false);
        mediaController.reverseList();
    }
    // %%%%%%%%%%%%%%%%%%%% END - ANIMATE BUTTON AND REVERSE THE LIST %%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% ANIMATE BUTTON AND REFRESH THE LIST %%%%%%%%%%%%%%
    void animateButonAndRefreshTheList () {
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
    Widget getAppropriateImageWidget (Media media) {

        final file = File(media.imagePath);

        if (file.existsSync()) {
            return Image.file(File(media.imagePath), fit: BoxFit.cover);

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




    // %%%%%%%%%%%%%%%%%%%%%%%%% DISPOSE %%%%%%%%%%%%%%%%%%
    @override void dispose() {
        _inverseAnimationController.dispose();
        _refreshAnimationController.dispose();
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

                                decoration: InputDecoration(

                                    hintText: "Search here...",
                                    prefixIcon: Icon(Icons.search),
                                    filled: true,
                                    fillColor: Theme.of(context).colorScheme.surfaceContainer,
                                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),

                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(70),
                                        borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.onSurface,
                                            width: .02,
                                        ),
                                    )

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
                                            onPressed: animateButonAndRefreshTheList, 
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
                                    backgroundColor: Theme.of(context).colorScheme.onSurface, 
                                    width: 100, 
                                    height: 100,

                                    child: ListView.builder(
                                        itemCount: mediaController.mediaList.length,
                                    
                                        itemBuilder: (context, index) {
                                          final media = mediaController.mediaList[index];
                                  
                                          return InkWell(
                                  
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
                                                                              maxLines: 6,
                                                                          ),
                                                                          // ---------- END - DESCRIPTION -------------
                                  
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
// $$$$$$$$$$$$$$$$$$$$ END - STATE $$$$$$$$$$$$$$$$$$$$$$$$$$$$