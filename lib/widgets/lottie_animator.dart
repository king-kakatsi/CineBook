import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';



// @@@@@@@@@@@@@@@@@@@ CONTROLLER @@@@@@@@@@@@@@@@@
class LottieAnimator {

    // %%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%
    final GlobalKey<_LottieAnimatorWidgetState> _animaterStateKey = GlobalKey<_LottieAnimatorWidgetState>();
    // %%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% BUILDER %%%%%%%%%%%%%%%%%%%
    Widget builder ({
        required String lottieFilePath,
        required Color backgroundColor,
        required double width,
        required double height,
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
    void play () => _animaterStateKey.currentState?._play();
    // %%%%%%%%%%%%%%%% END - PLAY %%%%%%%%%%%%%%%%%%%%
    
    
    
    
    // %%%%%%%%%%%%%%%% STOP %%%%%%%%%%%%%%%%%%%%
    void stop () => _animaterStateKey.currentState?._stop();
    // %%%%%%%%%%%%%%%% END - STOP %%%%%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@@@@@@@@ END - CONTROLLER @@@@@@@@@@@@@@@@@





// @@@@@@@@@@@@@@@@ THE STATEFUL WIDGET @@@@@@@@@@@@@@@@@

class _LottieAnimatorWidget extends StatefulWidget {


    // %%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%
    final String lottieFilePath;
    final Widget child;
    final double borderRadius;
    final Color backgroundColor;
    final double boxOpacity;
    final Alignment alignment;
    final double width;
    final double height;
    final double pushLeft;
    final double pushTop;
    final double pushRight;
    final double pushBottom;
    // %%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%
    const _LottieAnimatorWidget ({
        super.key, 
        required this.lottieFilePath,
        required this.backgroundColor,
        required this.width,
        required this.height,
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
class _LottieAnimatorWidgetState extends State<_LottieAnimatorWidget> {

    // %%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%
    bool _isPlaying = false;
    // %%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%% PLAY %%%%%%%%%%%%%%%%%
    void _play () => setState(() => _isPlaying = true);
    // %%%%%%%%%%%%%%% END - PLAY %%%%%%%%%%%%%%%%%
    
    
    
    
    // %%%%%%%%%%%%%%% STOP %%%%%%%%%%%%%%%%%
    void _stop () => setState(() => _isPlaying = false);
    // %%%%%%%%%%%%%%% END - STOP %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%%
    @override Widget build(BuildContext context) {
        
        return Stack(
            children: [
                widget.child,

                // °°°°°°°°°°°°°°° ANIMATION CONATINER °°°°°°°°°°°°°°
                if (_isPlaying)
                    Container(
                        color: widget.backgroundColor.withValues(alpha: .5),
                        padding: EdgeInsets.only(
                            left: widget.pushLeft,
                            top: widget.pushTop,
                            right: widget.pushRight,
                            bottom: widget.pushBottom,
                        ),

                        child: Align(
                            alignment: widget.alignment,
                            child: Container(
                            
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(widget.borderRadius),
                                    color: widget.backgroundColor.withValues(alpha: widget.boxOpacity),
                                ),
                            
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