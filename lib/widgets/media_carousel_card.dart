import 'dart:async';

import 'package:first_project/themes/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// @@@@@@@@@@@@@@@@@@@@@ CAROUSEL CARD SLIDE @@@@@@@@@@@@@@@@@@@

class MediaCarouselCardSlide {

    // °°°°°°°°°°°°°°°° PROPERTIES °°°°°°°°°°°°°°°°°°°°
    final Widget content;
    final double? heightFactor;
    final double? widthFactor;
    // °°°°°°°°°°°°°°°° END - PROPERTIES °°°°°°°°°°°°°°°°°°°°




    // °°°°°°°°°°°°°°°°° CONSTRUCTOR °°°°°°°°°°°°°°°°°°°°°
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
// ignore: must_be_immutable
class MediaCarouselCard extends StatefulWidget {

    // °°°°°°°°°°°°°°°°°°°°°°°° PROPERTIES °°°°°°°°°°°°°°°°°°°°°°°°°
    final String title;
    final List<MediaCarouselCardSlide> slides;
    double height;
    double borderRadius;
    final VoidCallback? onEdit;
    final VoidCallback? onDelete;
    int autoSlideDuration;
    int animationDuration;
    // °°°°°°°°°°°°°°°°°°°°°°°° END - PROPERTIES °°°°°°°°°°°°°°°°°°°°°°°°°



    // °°°°°°°°°°°°°°°°°° CONSTRUCTOR °°°°°°°°°°°°°°°°°°°°°°
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

    class MediaCarouselCardState extends State<MediaCarouselCard> {

    // °°°°°°°°°°°°°°°°°°°° PROPERTIES °°°°°°°°°°°°°°°°°°°°°
    late int _currentPageIndex;
    late PageController _pageController;
    Timer? _autoSlideTimer;
    bool _isUserScrolling = false;
    // °°°°°°°°°°°°°°°°°°°° END - PROPERTIES °°°°°°°°°°°°°°°°°°°°




    // °°°°°°°°°°°°°°°°°°° INIT STATE °°°°°°°°°°°°°°°°°°°°°
    @override void initState() {
        super.initState();

        _currentPageIndex = 0;
        _pageController = PageController();
        _startAutoSlide();
    }
    // °°°°°°°°°°°°°°°°°°° END - INIT STATE °°°°°°°°°°°°°°°°°°°°°




    // °°°°°°°°°°°°°°°°°°°° START AUTO SCROLLING °°°°°°°°°°°°°°°°°°°°
    void _startAutoSlide () {
        _autoSlideTimer?.cancel();

        _autoSlideTimer = Timer.periodic(
            Duration(seconds: widget.autoSlideDuration), 
            (_) {
                if (_isUserScrolling) return;
                var nextIndex = (_currentPageIndex + 1) % widget.slides.length;

                _pageController.animateToPage(
                    nextIndex, 
                    duration: Duration(milliseconds: widget.animationDuration), 
                    curve: Curves.easeInOut
                );

                setState(() {
                  _currentPageIndex = nextIndex;
                });
            }
        );
    }
    // °°°°°°°°°°°°°°°°°°°° END - START AUTO SCROLLING °°°°°°°°°°°°°°°°°°°°




    // °°°°°°°°°°°°°°°° STOP AUTO SLIDE °°°°°°°°°°°°°°°°°°°°
    void _stopAutoSlide () {
        _autoSlideTimer?.cancel();
        _autoSlideTimer = null;
    }
    // °°°°°°°°°°°°°°°° END - STOP AUTO SLIDE °°°°°°°°°°°°°°°°°°°°




    // °°°°°°°°°°°°°°°°°°°° DISPOSE °°°°°°°°°°°°°°°°°°°°
    @override void dispose() {
        _autoSlideTimer?.cancel();
        _pageController.dispose();
        super.dispose();
    }
    // °°°°°°°°°°°°°°°°°°°° END - DISPOSE °°°°°°°°°°°°°°°°°°°°




    // °°°°°°°°°°°°°°°°°°°°°°° BUILD °°°°°°°°°°°°°°°°°°°°°°
    @override
  Widget build(BuildContext context) {
    
    return NotificationListener<ScrollNotification>(

        // °°°°°°°°°°°°°° GET USER SCROLL ALERT °°°°°°°°°°°°°°°°°°
        onNotification: (notification) {
            if (notification is UserScrollNotification) {

                if (notification.direction != ScrollDirection.idle){
                    _isUserScrolling = true;
                    _stopAutoSlide();

                } else {

                    _isUserScrolling = false;
                    _startAutoSlide();
                }
            }
            return false;
        },
        // °°°°°°°°°°°°°° END - GET USER SCROLL ALERT °°°°°°°°°°°°°°°°°°


        child: Stack(
            children: [

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
