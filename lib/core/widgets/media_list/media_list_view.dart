import 'dart:io';
import 'dart:math';
import 'package:first_project/core/widgets/media_carousel_card.dart';
import 'package:first_project/core/widgets/toggle_button_group.dart';
import 'package:first_project/models/media.dart';
import 'package:first_project/core/widgets/media_list/media_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


// $$$$$$$$$$$$$$$$$$$ STATEFUL $$$$$$$$$$$$$$$$$$$$$$
class MediaListPage extends StatefulWidget {

    // %%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%
    final Mediatype mediaType;
    final String pageTitle;
    final String hiveBoxName;
    // %%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%
    const MediaListPage({

        super.key, 
        required this.mediaType, 
        required this.pageTitle,
        required this.hiveBoxName
    });
    // %%%%%%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% CREATE STATE %%%%%%%%%%%%%%%%%%%%%%
    @override
    State<StatefulWidget> createState() => MediaListPageState();
    // %%%%%%%%%%%%%%%%%%%% END - CREATE STATE %%%%%%%%%%%%%%%%%%%%%%
}
// $$$$$$$$$$$$$$$$$$$ END - STATEFUL $$$$$$$$$$$$$$$$$$$$$$







// $$$$$$$$$$$$$$$$$$$$ STATE $$$$$$$$$$$$$$$$$$$$$$$$$$$$

class MediaListPageState extends State<MediaListPage> with SingleTickerProviderStateMixin{

    // %%%%%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%
    late final AnimationController _animationController;
    late  final Animation<double> _inverseListRotationAnim;
    // %%%%%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%% INIT %%%%%%%%%%%%%%%%%%%%%
    @override void initState() {
        super.initState();

        // _controller = MediaListController(widget.mediaType);
        final MediaListController controller = Provider.of<MediaListController>(context, listen: false);
        controller.hiveBoxName = widget.hiveBoxName;
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.initialize();
        });

        initAnimations();
    }
    // %%%%%%%%%%%%%%%%%%%%%% END - INIT %%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%% INIT ANIMATIONS %%%%%%%%%%%%%%%%%%%
    void initAnimations () {

        _animationController = AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 600),
        );

        _inverseListRotationAnim = Tween<double>(begin: 0,end: 180,)
        .animate(CurvedAnimation(
            parent: _animationController, 
            curve: Curves.easeInOut,
        ));

        _animationController.addListener(() {
            setState(() {});
        });
    }
    // %%%%%%%%%%%%%%%%%%% END - INIT ANIMATIONS %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% ANIMATE BUTTON AND REVERSE THE LIST %%%%%%%%%%%%%%
    void animateButonAndReverseTheList () {

        if (_animationController.isForwardOrCompleted) {
                _animationController.reverse();

            } else{
                _animationController.forward();
            }
        // _animationController.forward();
        final MediaListController listController = Provider.of<MediaListController>(context, listen: false);
        listController.reverseList();
    }
    // %%%%%%%%%%%%%%%%%%%% END - ANIMATE BUTTON AND REVERSE THE LIST %%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%%% DISPOSE %%%%%%%%%%%%%%%%%%
    @override void dispose() {
    _animationController.dispose();
    super.dispose();
  }
    // %%%%%%%%%%%%%%%%%%%%%%%%% END - DISPOSE %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%%%%%%
    @override
    Widget build(BuildContext context) {

        final MediaListController controller = Provider.of<MediaListController>(context);

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
                                onChanged: (value) => controller.search(value),

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

                                    SizedBox(width: 10),

                                    // °°°°°°°°°°°°°° SORT BUTTONS °°°°°°°°°°°°°°°°°
                                    Flexible(
                                        fit: FlexFit.loose, 
                                        child: ToggleButtonGroup(
                                            buttons: controller.sortButtons,
                                            onChanged: (selectedIndex, buttons) => controller.sortBy(selectedIndex, buttons),
                                        ),
                                    ),
                                    // °°°°°°°°°°°°°° END - SORT BUTTONS °°°°°°°°°°°°°°°°°

                                    SizedBox(width: 5),

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
                                ],
                            ),
                            // ::--::::::-::-::--::: END - LIST ACTION BUTTONS ::--::::::-::-::--:::


                            // ::--::::::-::-::--::: LIST VIEW ::--::::::-::-::--:::
                            Expanded(

                                child: ListView.builder(
                                    itemCount: controller.mediaList.length,

                                    itemBuilder: (context, index) {
                                        final media = controller.mediaList[index];

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
                                                                child: media.imagePath.isEmpty? Image.network(media.imageUrl, fit: BoxFit.cover) : Image.file(File(media.imagePath), fit: BoxFit.cover), 
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
                                                    onEdit: () => controller.goToEditMedia(context, media),
                                                    
                                                    // °°°°°°°°°°°° END - EDIT THE MEDIA °°°°°°°°°°°°°°°°°°°°


                                                    // °°°°°°°°°°°°°° DELETE THE MEDIA °°°°°°°°°°°°°°°°°°
                                                    onDelete: () => controller.deleteInList(context, media),
                                                    // °°°°°°°°°°°° END - DELETE THE MEDIA °°°°°°°°°°°°°°°°°°
                                                )
                                            )
                                        );
                                    }
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