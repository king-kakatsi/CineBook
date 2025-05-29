import 'package:first_project/controllers/media_controller.dart';
import 'package:first_project/extensions/enum_extensions.dart';
import 'package:first_project/services/tts_service.dart';
import 'package:first_project/themes/theme_viewmodel.dart';
import 'package:first_project/widgets/lottie_animator.dart';
import 'package:first_project/widgets/menu.dart';
import 'package:first_project/pages/home_page.dart';
import 'package:first_project/widgets/picker_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';




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
    late final Animation<double> _translateYAnimation;
    late final double _translationYValue;
    late final int _animationDuration;
    double _borderRadius = 0.0;
    final LottieAnimator _lottieAnimator = LottieAnimator();
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

        _translateYAnimation = Tween<double>(begin: 0.0, end: _translationYValue).animate(
            CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
        );

        final mediaController = GetIt.instance<MediaController>();

        myMenuMist = [

            // oooooooooooooo CHANGE THEME ooooooooooooooooo
            MenuOption(
                icon: Icons.brightness_6,
                title: "Change Theme",

                action: () {
                    _themeViewModel.toggleTheme();
                    toggleMenu();
                },
            ),
            // oooooooooooooo END - CHANGE THEME ooooooooooooooooo


            // oooooooooooooo IMPORT BACKUP ooooooooooooooooo
            MenuOption(
                icon: Icons.download_for_offline_rounded,
                title: "Import Backup",

                action: () async => await mediaController.tryImportBackupAndInitialize(
                    context, 
                    _lottieAnimator.play, 
                    _lottieAnimator.stop,
                    checkIsFirstLaunch: false
                ),
            ),
            // oooooooooooooo END - IMPORT BACKUP ooooooooooooooooo


            // oooooooooooooo EXPORT BACKUP ooooooooooooooooo
            MenuOption(
                icon: Icons.send_and_archive_rounded,
                title: "Export Backup",

                action: () async => await mediaController.exportBackup(
                    context, 
                    _lottieAnimator.play, 
                    _lottieAnimator.stop
                ),
            ),
            // oooooooooooooo END - EXPORT BACKUP ooooooooooooooooo


            // oooooooooooooo CHANGE SPEECH LANGUAGE ooooooooooooooooo
            MenuOption(
                icon: Icons.multitrack_audio,
                title: "Change Speech Language",

                action: () async => await chooseSpeechLang("Speech Language"),
            ),
            // oooooooooooooo END - CHANGE SPEECH LANGUAGE ooooooooooooooooo
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




    // %%%%%%%%%%%%%%%%%%% CHOOSE TTS LANGUAGE %%%%%%%%%%%%%%%%%%%
    Future<String?> chooseSpeechLang (
        String title,
    ) async {

        String currentTtsLang = await TtsService.retrieveTtsLanguage();
        return showDialog<String>(
            context: context, 
            barrierDismissible: true,

            builder: (context) => AlertDialog(

                title: Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface
                    ),     
                ),

                content: PickerField(
                    label: "Choose Speech language", 
                    hintText: currentTtsLang, 
                    options: Languages.values.map((lang) => lang.formattedName).toList(),

                    onChanged: (lang) async {
                        currentTtsLang = lang;
                        await TtsService.saveTtsLanguage(lang);
                    },
                ),

                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(currentTtsLang), 
                        child: Text(
                            "OK",
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface
                            ),
                        )
                    ),
                ],

            ),
        );
    }
    // %%%%%%%%%%%%%%%%%%% END - CHOOSE TTS LANGUAGE %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%%%%% DISPOSE %%%%%%%%%%%%%%%%%%
    @override void dispose() {
    _animationController.dispose();
    super.dispose();
  }
    // %%%%%%%%%%%%%%%%%%%%%%%%% END - DISPOSE %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%
    @override
    Widget build(BuildContext context) {

        return Scaffold(

            body: Stack(
                children: [
                    _lottieAnimator.builder(
                        lottieFilePath: "assets/lottie/loading_anim.json",  
                        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                        backgroundOpacity: .5, 
                        width: 100, 
                        height: 100,
                        pushTop: 200,
                        alignment: Alignment.topCenter,

                        child: MyMenu(
                            menuList: myMenuMist,
                            onClose: toggleMenu,
                        ),
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