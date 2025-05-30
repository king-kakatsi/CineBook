import 'dart:async';

import 'package:first_project/themes/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// @@@@@@@@@@@@@@@@@@@@@ CAROUSEL CARD SLIDE @@@@@@@@@@@@@@@@@@@

/// **Data model for carousel slide configuration**
///
/// This class represents a single slide within a MediaCarouselCard.
/// It contains the widget content to display and optional sizing factors.
///
/// Properties:
/// - content : The Widget to be displayed in this slide
/// - heightFactor : Optional height multiplier (0.0 to 1.0) for the slide content
/// - widthFactor : Optional width multiplier (0.0 to 1.0) for the slide content
///
/// Example usage:
/// ```dart
/// MediaCarouselCardSlide slide = MediaCarouselCardSlide(
///   content: Image.network('https://example.com/image.jpg'),
///   heightFactor: 0.8,
///   widthFactor: 1.0,
/// );
/// ```
class MediaCarouselCardSlide {

    // °°°°°°°°°°°°°°°° PROPERTIES °°°°°°°°°°°°°°°°°°°°
    /// Widget content to be displayed in the slide
    final Widget content;
    /// Optional height factor for content sizing (0.0 to 1.0)
    final double? heightFactor;
    /// Optional width factor for content sizing (0.0 to 1.0)
    final double? widthFactor;
    // °°°°°°°°°°°°°°°° END - PROPERTIES °°°°°°°°°°°°°°°°°°°°




    // °°°°°°°°°°°°°°°°° CONSTRUCTOR °°°°°°°°°°°°°°°°°°°°°
    /// Creates a new MediaCarouselCardSlide with required content and optional sizing factors
    MediaCarouselCardSlide ({
        required this.content,
        this.heightFactor,
        this.widthFactor,
    });
    // °°°°°°°°°°°°°°°°° END - CONSTRUCTOR °°°°°°°°°°°°°°°°°°°°°
}
// @@@@@@@@@@@@@@@@@@@@@ EBD -  CAROUSEL CARD SLIDE @@@@@@@@@@@@@@@@@@@





// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ CAROUSEL CARD @@@@@@@@@@@@@@@@@@@@@@@@@

// %%%%%%%%%%%%%%%%%%%%%%% STATEFUL WIDGET %%%%%%%%%%%%%%%%%%%%%%%%%%
/// **Customizable carousel card widget with auto-sliding functionality**
///
/// This widget creates a carousel card that displays multiple slides with automatic
/// sliding functionality. It includes edit/delete actions and pagination indicators.
///
/// Features:
/// - Auto-sliding with configurable duration
/// - User scroll detection that pauses auto-slide
/// - Edit and delete action buttons
/// - Pagination indicator showing current slide
/// - Customizable height, border radius, and animation duration
///
/// Parameters:
/// - title : Display title shown at the bottom of the card
/// - slides : List of MediaCarouselCardSlide objects to display
/// - height : Height of the carousel card (default: 300.0)
/// - borderRadius : Corner radius of the card (default: 15.0)
/// - onEdit : Optional callback for edit action
/// - onDelete : Optional callback for delete action
/// - autoSlideDuration : Auto-slide interval in seconds (default: 3)
/// - animationDuration : Slide transition duration in milliseconds (default: 600)
///
/// Example usage:
/// ```dart
/// MediaCarouselCard(
///   title: "My Media Collection",
///   slides: [slide1, slide2, slide3],
///   height: 250.0,
///   onEdit: () => print("Edit pressed"),
///   onDelete: () => print("Delete pressed"),
/// )
/// ```
// ignore: must_be_immutable
class MediaCarouselCard extends StatefulWidget {

    // °°°°°°°°°°°°°°°°°°°°°°°° PROPERTIES °°°°°°°°°°°°°°°°°°°°°°°°°
    /// Title displayed at the bottom of the carousel card
    final String title;
    /// List of slides to display in the carousel
    final List<MediaCarouselCardSlide> slides;
    /// Height of the carousel card
    double height;
    /// Border radius for rounded corners
    double borderRadius;
    /// Callback function when edit button is pressed
    final VoidCallback? onEdit;
    /// Callback function when delete button is pressed
    final VoidCallback? onDelete;
    /// Duration between auto-slides in seconds
    int autoSlideDuration;
    /// Animation duration for slide transitions in milliseconds
    int animationDuration;
    // °°°°°°°°°°°°°°°°°°°°°°°° END - PROPERTIES °°°°°°°°°°°°°°°°°°°°°°°°°



    // °°°°°°°°°°°°°°°°°° CONSTRUCTOR °°°°°°°°°°°°°°°°°°°°°°
    /// Creates a MediaCarouselCard with customizable properties and default values
    MediaCarouselCard ({
        super.key,
        required this.title,
        required this.slides,
        this.height = 300.0,
        this.borderRadius = 15.0,
        this.onEdit,
        this.onDelete,
        this.autoSlideDuration = 3,
        this.animationDuration = 600,
    });
    // °°°°°°°°°°°°°°°°°° END - CONSTRUCTOR °°°°°°°°°°°°°°°°°°°°°°



    // °°°°°°°°°°°°°°°°°°°° CREATE STATE °°°°°°°°°°°°°°°°°°°°
    @override State<StatefulWidget> createState() => MediaCarouselCardState();
    // °°°°°°°°°°°°°°°°°°°° END - CREATE STATE °°°°°°°°°°°°°°°°°°°°
}
// %%%%%%%%%%%%%%%%%%%%%%% END -  STATEFUL WIDGET %%%%%%%%%%%%%%%%%%%%%%%%%%





// %%%%%%%%%%%%%%%%%%%%%%% STATE OF STATEFUL WIDGET %%%%%%%%%%%%%%%%%%%%%%

/// **State management for MediaCarouselCard widget**
///
/// Handles the carousel functionality including auto-sliding, user interaction detection,
/// page controller management, and timer lifecycle.
class MediaCarouselCardState extends State<MediaCarouselCard> {

    // °°°°°°°°°°°°°°°°°°°° PROPERTIES °°°°°°°°°°°°°°°°°°°°°
    /// Current active slide index
    late int _currentPageIndex;
    /// Controller for PageView widget to handle sliding
    late PageController _pageController;
    /// Timer for automatic sliding functionality
    Timer? _autoSlideTimer;
    /// Flag to track if user is currently scrolling manually
    bool _isUserScrolling = false;
    // °°°°°°°°°°°°°°°°°°°° END - PROPERTIES °°°°°°°°°°°°°°°°°°°°




    // °°°°°°°°°°°°°°°°°°° INIT STATE °°°°°°°°°°°°°°°°°°°°°
    @override void initState() {
        super.initState();

        // Initialize carousel to first slide
        _currentPageIndex = 0;
        _pageController = PageController();
        // Start automatic sliding
        _startAutoSlide();
    }
    // °°°°°°°°°°°°°°°°°°° END - INIT STATE °°°°°°°°°°°°°°°°°°°°°




    // °°°°°°°°°°°°°°°°°°° START AUTO SLIDE TIMER °°°°°°°°°°°°°°°°°°°
    /// **Starts the automatic slide timer**
    ///
    /// This method sets up a periodic timer that automatically advances the carousel
    /// to the next slide at the configured interval. The timer respects user interaction
    /// by checking the _isUserScrolling flag before advancing.
    ///
    /// The method:
    /// - Cancels any existing timer to prevent duplicates
    /// - Creates a new periodic timer with widget.autoSlideDuration interval
    /// - Calculates next slide index with circular wrapping
    /// - Animates to next page with smooth transition
    /// - Updates current page index state
    ///
    /// Timer is paused when user is actively scrolling to avoid interference.
    void _startAutoSlide () {
        _autoSlideTimer?.cancel();

        _autoSlideTimer = Timer.periodic(
            Duration(seconds: widget.autoSlideDuration), 
            (_) {
                // Skip auto-slide if user is currently scrolling
                if (_isUserScrolling) return;
                // Calculate next slide index with wraparound
                var nextIndex = (_currentPageIndex + 1) % widget.slides.length;

                // Animate to next slide
                _pageController.animateToPage(
                    nextIndex, 
                    duration: Duration(milliseconds: widget.animationDuration), 
                    curve: Curves.easeInOut
                );

                // Update current page index
                setState(() {
                  _currentPageIndex = nextIndex;
                });
            }
        );
    }
    // °°°°°°°°°°°°°°°°°°° END - START AUTO SLIDE TIMER °°°°°°°°°°°°°°°°°°°




    // °°°°°°°°°°°°°°°°°°° STOP AUTO SLIDE TIMER °°°°°°°°°°°°°°°°°°°
    /// **Stops the automatic slide timer**
    ///
    /// This method cancels the current auto-slide timer and sets it to null.
    /// Called when user starts manual scrolling to prevent interference
    /// between automatic and manual navigation.
    void _stopAutoSlide () {
        _autoSlideTimer?.cancel();
        _autoSlideTimer = null;
    }
    // °°°°°°°°°°°°°°°°°°° END - STOP AUTO SLIDE TIMER °°°°°°°°°°°°°°°°°°°




    // °°°°°°°°°°°°°°°°°°°° DISPOSE °°°°°°°°°°°°°°°°°°°°
    @override void dispose() {
        // Clean up timer to prevent memory leaks
        _autoSlideTimer?.cancel();
        // Clean up page controller
        _pageController.dispose();
        super.dispose();
    }
    // °°°°°°°°°°°°°°°°°°°° END - DISPOSE °°°°°°°°°°°°°°°°°°°°




    // °°°°°°°°°°°°°°°°°°°°°°° BUILD °°°°°°°°°°°°°°°°°°°°°°
    @override
     Widget build(BuildContext context) {
    
        return NotificationListener<ScrollNotification>(

            // =================== GET USER SCROLL ALERT ===================
            // Listen for user scroll events to pause/resume auto-sliding
            onNotification: (notification) {
                if (notification is UserScrollNotification) {

                    // User started scrolling - pause auto-slide
                    if (notification.direction != ScrollDirection.idle){
                        _isUserScrolling = true;
                        _stopAutoSlide();

                    } else {
                        // User stopped scrolling - resume auto-slide
                        _isUserScrolling = false;
                        _startAutoSlide();
                    }
                }
                return false;
            },
            // =================== END - GET USER SCROLL ALERT ===================


            child: Stack(
                children: [

                    // Main carousel container with PageView
                    Container(
                        height: widget.height,
                        clipBehavior: Clip.antiAlias,

                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(widget.borderRadius),
                            color: Theme.of(context).colorScheme.surface,
                            boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 4),
                            ),
                            ],
                        ),

                        child: PageView.builder(
                            controller: _pageController,
                            itemCount: widget.slides.length,
                            
                            // Update current page index when user swipes
                            onPageChanged: (index) => setState(() => _currentPageIndex = index),

                            itemBuilder: (context, index) {
                                final slide = widget.slides[index];
                                return Align(
                                    alignment: Alignment.topCenter,
                                    child: FractionallySizedBox(
                                    heightFactor: slide.heightFactor ?? 1.0,
                                    widthFactor: slide.widthFactor ?? 1.0,
                                    child: slide.content,
                                    ),
                                );
                            },
                        ),
                    ),

                    // Bottom overlay with title and action buttons
                    Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,

                        child: Container(
                            padding: const EdgeInsets.all(12),

                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.zero, 
                                    topRight: Radius.zero, 
                                    bottomLeft: Radius.circular(widget.borderRadius), 
                                    bottomRight: Radius.circular(widget.borderRadius)
                                    ),
                                color: Theme.of(context).colorScheme.surfaceContainer,
                            ),

                            child: Row(
                                children: [ 

                                    // oooooooooooooo TITLE oooooooooooooooo
                                    Expanded(
                                        
                                        child: Align(
                                            alignment: Alignment.centerLeft, 

                                            child: Text(
                                                widget.title,
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                                        fontWeight: FontWeight.bold,
                                                    ),
                                                textAlign: TextAlign.start,
                                            ),
                                        ),
                                    ),
                                    // oooooooooooooo END - TITLE oooooooooooooooo

                                    // oooooooooooooo MODIFY oooooooooooooo 
                                    IconButton(
                                        onPressed: widget.onEdit, 
                                        icon: Icon(Icons.edit)
                                    ),
                                    // oooooooooooooo END - MODIFY oooooooooooooo 


                                    // oooooooooooooo DELETE oooooooooooooo 
                                    IconButton(
                                        onPressed: widget.onDelete, 
                                        icon: Icon(Icons.delete),
                                        color: AppColors.deepVineRed,
                                    ),
                                    // oooooooooooooo END - DELETE oooooooooooooo

                                ],
                            ),
                        ),
                    ),


                    // oooooooooooo Pagination indicator ooooooooooooooo
                    // Shows current slide number out of total slides
                    Positioned(
                        top: 8,
                        right: 8,
                        
                        child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(20),
                            ),

                            child: Text(
                                '${_currentPageIndex + 1}/${widget.slides.length}',
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                        ),
                    ),
                    // oooooooooooo END - Pagination indicator ooooooooooooooo
                ],
            )
        );
  }
    // °°°°°°°°°°°°°°°°°°°°°°° END - BUILD °°°°°°°°°°°°°°°°°°°°°°
}
// %%%%%%%%%%%%%%%%%%%%%%% STATE OF STATEFUL WIDGET %%%%%%%%%%%%%%%%%%%%%%

// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ END - CAROUSEL CARD @@@@@@@@@@@@@@@@@@@@@@@@@