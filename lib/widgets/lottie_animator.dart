import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';



// @@@@@@@@@@@@@@@@@@@ CONTROLLER @@@@@@@@@@@@@@@@@

/// **Controller class for managing Lottie animation overlay functionality**
/// 
/// This class provides a convenient interface to control Lottie animations
/// that can be displayed as overlays on top of other widgets in Cinebook.
/// It manages the animation state and provides methods to play/stop animations.
class LottieAnimator {

   // %%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%
   /// Global key to access the state of the LottieAnimatorWidget
   final GlobalKey<_LottieAnimatorWidgetState> _animaterStateKey = GlobalKey<_LottieAnimatorWidgetState>();
   // %%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%




   // %%%%%%%%%%%%%%%%%% BUILDER %%%%%%%%%%%%%%%%%%%
   /// **Creates a LottieAnimatorWidget with customizable overlay properties**
   /// 
   /// This method builds a widget that can display Lottie animations as overlays
   /// on top of child content. The animation can be positioned, styled, and
   /// controlled through the provided parameters.
   /// 
   /// Parameters:
   /// - lottieFilePath: Path to the Lottie animation asset file
   /// - backgroundColor: Background color for the overlay and animation container
   /// - width: Width of the Lottie animation
   /// - height: Height of the Lottie animation  
   /// - backgroundOpacity: Opacity of the full-screen overlay background (default: 0.5)
   /// - boxOpacity: Opacity of the animation container box (default: 1.0)
   /// - pushLeft: Left padding/offset for animation positioning (default: 0.0)
   /// - pushTop: Top padding/offset for animation positioning (default: 0.0)
   /// - pushRight: Right padding/offset for animation positioning (default: 0.0)
   /// - pushBottom: Bottom padding/offset for animation positioning (default: 0.0)
   /// - alignment: Alignment of the animation within the overlay (default: center)
   /// - borderRadius: Corner radius for the animation container (default: 15.0)
   /// - child: The widget to display behind the animation overlay
   /// 
   /// Returns:
   /// - Widget: The configured LottieAnimatorWidget
   Widget builder ({
       required String lottieFilePath,
       required Color backgroundColor,
       required double width,
       required double height,
       double backgroundOpacity = .5,
       double boxOpacity = 1.0,
       double pushLeft = 0.0,
       double pushTop = 0.0,
       double pushRight = 0.0,
       double pushBottom = 0.0,
       Alignment alignment = Alignment.center,
       double borderRadius = 15.0,
       required Widget child,
   }) {

       return _LottieAnimatorWidget(
           key: _animaterStateKey,
           lottieFilePath: lottieFilePath,
           backgroundColor: backgroundColor,
           backgroundOpacity: backgroundOpacity,
           boxOpacity: boxOpacity,
           alignment: alignment,
           borderRadius: borderRadius,
           width: width,
           height: height,
           pushLeft: pushLeft,
           pushTop: pushTop,
           pushRight: pushRight,
           pushBottom: pushBottom,
           child: child,
       );
   }
   // %%%%%%%%%%%%%%%%%% END - BUILDER %%%%%%%%%%%%%%%%%%%




   // %%%%%%%%%%%%%%%% PLAY %%%%%%%%%%%%%%%%%%%%
   /// **Starts playing the Lottie animation overlay**
   /// 
   /// This method triggers the animation to become visible and start playing.
   /// The overlay will appear on top of the child widget with the configured styling.
   void play () => _animaterStateKey.currentState?._play();
   // %%%%%%%%%%%%%%%% END - PLAY %%%%%%%%%%%%%%%%%%%%
   
   
   
   
   // %%%%%%%%%%%%%%%% STOP %%%%%%%%%%%%%%%%%%%%
   /// **Stops and hides the Lottie animation overlay**
   /// 
   /// This method stops the animation and removes the overlay, making only
   /// the child widget visible again.
   void stop () => _animaterStateKey.currentState?._stop();
   // %%%%%%%%%%%%%%%% END - STOP %%%%%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@@@@@@@@ END - CONTROLLER @@@@@@@@@@@@@@@@@





// @@@@@@@@@@@@@@@@ THE STATEFUL WIDGET @@@@@@@@@@@@@@@@@

/// **Private StatefulWidget that handles Lottie animation overlay display**
/// 
/// This widget creates a Stack layout with the child widget as the base layer
/// and conditionally displays a Lottie animation overlay on top based on the
/// playing state controlled by the LottieAnimator class.
class _LottieAnimatorWidget extends StatefulWidget {


   // %%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%
   /// Path to the Lottie animation asset file
   final String lottieFilePath;
   /// Child widget to display behind the animation
   final Widget child;
   /// Corner radius for the animation container
   final double borderRadius;
   /// Background color for overlay and container
   final Color backgroundColor;
   /// Opacity of the full-screen background overlay
   final double backgroundOpacity;
   /// Opacity of the animation container box
   final double boxOpacity;
   /// Alignment of animation within the overlay
   final Alignment alignment;
   /// Width of the Lottie animation
   final double width;
   /// Height of the Lottie animation
   final double height;
   /// Left padding/offset for animation positioning
   final double pushLeft;
   /// Top padding/offset for animation positioning
   final double pushTop;
   /// Right padding/offset for animation positioning
   final double pushRight;
   /// Bottom padding/offset for animation positioning
   final double pushBottom;
   // %%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%




   // %%%%%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%
   /// **Constructor for _LottieAnimatorWidget with all configuration parameters**
   /// 
   /// Creates the private widget with all necessary properties for displaying
   /// and positioning the Lottie animation overlay.
   const _LottieAnimatorWidget ({
       super.key, 
       required this.lottieFilePath,
       required this.backgroundColor,
       required this.width,
       required this.height,
       required this.backgroundOpacity,
       required this.boxOpacity,
       required this.alignment,
       required this.borderRadius,
       required this.pushLeft,
       required this.pushTop,
       required this.pushRight,
       required this.pushBottom,
       required this.child,
   });
   // %%%%%%%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%




   // %%%%%%%%%%%%%%%% CREATE STATE %%%%%%%%%%%%%%%%%
   @override State<StatefulWidget> createState() => _LottieAnimatorWidgetState();
   // %%%%%%%%%%%%%%%% END - CREATE STATE %%%%%%%%%%%%%%%%%
}

// @@@@@@@@@@@@@@@@ END - THE STATEFUL WIDGET @@@@@@@@@@@@@@@@@





// @@@@@@@@@@@@@@@@@@@ STATE OF THE WIDGET @@@@@@@@@@@@@@@@@

/// **State class managing the animation visibility and playback control**
/// 
/// This class handles the internal state of the Lottie animation overlay,
/// controlling when the animation is visible and playing through boolean state management.
class _LottieAnimatorWidgetState extends State<_LottieAnimatorWidget> {

   // %%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%
   /// Boolean flag controlling whether the animation overlay is currently visible/playing
   bool _isPlaying = false;
   // %%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%




   // %%%%%%%%%%%%%%% PLAY %%%%%%%%%%%%%%%%%
   /// **Internal method to start animation playback**
   /// 
   /// Sets the playing state to true, which triggers a rebuild and makes
   /// the animation overlay visible in the UI.
   void _play () => setState(() => _isPlaying = true);
   // %%%%%%%%%%%%%%% END - PLAY %%%%%%%%%%%%%%%%%
   
   
   
   
   // %%%%%%%%%%%%%%% STOP %%%%%%%%%%%%%%%%%
   /// **Internal method to stop animation playback**
   /// 
   /// Sets the playing state to false, which triggers a rebuild and hides
   /// the animation overlay from the UI.
   void _stop () => setState(() => _isPlaying = false);
   // %%%%%%%%%%%%%%% END - STOP %%%%%%%%%%%%%%%%%




   // %%%%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%%
   /// **Builds the Stack layout with child widget and conditional animation overlay**
   /// 
   /// Creates a Stack with the child widget as the base layer and conditionally
   /// adds the Lottie animation overlay on top when _isPlaying is true.
   /// The overlay includes background dimming and a styled container for the animation.
   @override Widget build(BuildContext context) {
       
       return Stack(
           children: [
               // Base layer - always visible child widget
               widget.child,

               // °°°°°°°°°°°°°°° ANIMATION CONATINER °°°°°°°°°°°°°°
               // Conditional overlay layer - only visible when playing
               if (_isPlaying)
                   Container(
                       // Full-screen semi-transparent background
                       color: widget.backgroundColor.withValues(alpha: widget.backgroundOpacity),
                       padding: EdgeInsets.only(
                           left: widget.pushLeft,
                           top: widget.pushTop,
                           right: widget.pushRight,
                           bottom: widget.pushBottom,
                       ),

                       child: Align(
                           alignment: widget.alignment,
                           child: Container(
                           
                               // Styled container for the animation
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(widget.borderRadius),
                                   color: widget.backgroundColor.withValues(alpha: widget.boxOpacity),
                               ),
                           
                               // Lottie animation widget
                               child: Lottie.asset(
                                   widget.lottieFilePath, 
                                   width: widget.width,
                                   height: widget.height,
                                   alignment: Alignment.center,
                               ),
                           ),
                       ),
                   ),
               // °°°°°°°°°°°°°°° END - ANIMATION CONATINER °°°°°°°°°°°°°°
           ], // Stack children
       );
   }
   // %%%%%%%%%%%%%%%%%% END - BUILD %%%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@@@@@@@@ END - STATE OF THE WIDGET @@@@@@@@@@@@@@@@@