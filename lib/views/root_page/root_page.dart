import 'package:first_project/core/themes/theme_viewmodel.dart';
import 'package:first_project/core/widgets/menu.dart';
import 'package:first_project/views/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
// import 'package:vector_math/vector_math_64.dart' show Matrix4;



// @@@@@@@@@@@@ STATEFUL @@@@@@@@@@@@@@@@

class RootPage extends StatefulWidget {

    const RootPage({super.key});

    // %%%%%%%%%%%%% CREATE STATE %%%%%%%%%%%%%%%%%
    @override State<RootPage> createState() => RootPageState();
    // %%%%%%%%%%%%% END - CREATE STATE %%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@ END - STATEFUL @@@@@@@@@@@@@@@@






// @@@@@@@@@@@@@@@@@@ STATE @@@@@@@@@@@@@@@@
class RootPageState extends State<RootPage> with SingleTickerProviderStateMixin {

    // %%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%
    List<MenuOption> myMenuMist = [];
    bool isMenuOpen = false;
    late final ThemeViewModel _themeViewModel;
    late final AnimationController _animationController;
    // late final Animation<double> _scaleAnimation;
    late final Animation<double> _translateYAnimation;
    late final double _translationYValue;
    late final int _animationDuration;
    double _borderRadius = 0.0;
    // %%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% INIT STATE %%%%%%%%%%%%%%%%%%%
    @override
    void initState() {
        super.initState();

        _themeViewModel = GetIt.instance<ThemeViewModel>();
        _translationYValue = 400.0;
        _animationDuration = 600;

        _animationController = AnimationController(
            vsync: this,
            duration: Duration(milliseconds: _animationDuration),
        );

        // _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
        //     CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
        // );

        _translateYAnimation = Tween<double>(begin: 0.0, end: _translationYValue).animate(
            CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
        );

        myMenuMist = [

            // oooooooooooooo CHANGE THEME ooooooooooooooooo
            MenuOption(
                icon: Icons.brightness_6,
                title: "Change Theme",

                action: () {
                    _themeViewModel.toggleTheme();
                    toggleMenu();
                },
            )
            // oooooooooooooo END - CHANGE THEME ooooooooooooooooo
        ];
  }
    // %%%%%%%%%%%%%%%%%%%% END - INIT STATE %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% TOGGLE MENU %%%%%%%%%%%%%%%%%
    void toggleMenu () {

        setState(() {
            isMenuOpen = !isMenuOpen;
            if (isMenuOpen) {
                _borderRadius = 15;
                _animationController.forward();
            } 
            else {
                _animationController.reverse();
                _borderRadius = 0;
            }
        });
    }
    // %%%%%%%%%%%%%%%%%% END - TOGGLE MENU %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%
    @override
    Widget build(BuildContext context) {

        return Scaffold(

            body: Stack(
                children: [
                    MyMenu(
                        menuList: myMenuMist,
                        onClose: toggleMenu,
                    ),
                    
                    AnimatedPositioned(
                        duration: Duration(milliseconds: _animationDuration),
                        curve: Curves.easeInOutCubic,
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: AnimatedBuilder(
                            animation: _animationController,

                            builder: (context, child) {
                                return Transform(
                                    transform: Matrix4.identity()
                                    // ..setEntry(3, 2, 1)
                                    // ..scale(_scaleAnimation.value)
                                    ..translate(0.0, _translateYAnimation.value),
                                    alignment: Alignment.center,
                                    child: child,
                                );
                            },

                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(_borderRadius),
                                child: HomePage(
                                    title: "CineBook",
                                    onMenuPressed: toggleMenu,
                                ),
                            ),
                        ),
                    ),
                ],
            ),
        );
    }
    // %%%%%%%%%%%%%%%% END - BUILD %%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@@@@@@@ END - STATE @@@@@@@@@@@@@@@@