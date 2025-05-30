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

/// **Root Page - Main application container with animated slide menu**
///
/// The root page serves as the main container for the entire application.
/// It manages a slide-out menu system with smooth animations and provides
/// access to core application features like theme switching, backup management,
/// and TTS language configuration.
///
/// Key features:
/// - Animated slide menu with customizable menu options
/// - Theme switching functionality
/// - Backup import/export capabilities
/// - Text-to-Speech language selection
/// - Smooth animations with curve transitions
/// - Loading animations via LottieAnimator
///
/// The page uses a Stack layout where the menu slides behind the main content
/// (HomePage) with translation and border radius animations.
class RootPage extends StatefulWidget {

    // %%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%
    const RootPage({super.key});
    // %%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%% CREATE STATE %%%%%%%%%%%%%%%%%
    @override State<RootPage> createState() => RootPageState();
    // %%%%%%%%%%%%% END - CREATE STATE %%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@ END - STATEFUL @@@@@@@@@@@@@@@@





// @@@@@@@@@@@@@@@@@@ STATE @@@@@@@@@@@@@@@@
/// **RootPage State - Manages menu animations and application-wide actions**
///
/// This state class handles:
/// - Menu toggle animations with translation and border radius effects
/// - Theme switching through ThemeViewModel
/// - Backup import/export operations
/// - TTS language selection dialog
/// - Animation controller lifecycle management
///
/// Uses SingleTickerProviderStateMixin for animation controller optimization.
class RootPageState extends State<RootPage> with SingleTickerProviderStateMixin {

    // %%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%
    /// **List of menu options displayed in the slide menu**
    /// 
    /// Contains MenuOption objects with icons, titles, and action callbacks.
    /// Populated in initState with theme, backup, and TTS options.
    List<MenuOption> myMenuMist = [];
    
    /// **Menu visibility state**
    /// 
    /// Controls whether the slide menu is currently open or closed.
    /// Used to trigger animations and UI state changes.
    bool isMenuOpen = false;
    
    /// **Theme management service**
    /// 
    /// Injected ThemeViewModel instance for handling theme switching.
    /// Retrieved from GetIt dependency injection container.
    late final ThemeViewModel _themeViewModel;
    
    /// **Animation controller for menu slide transitions**
    /// 
    /// Controls the timing and lifecycle of menu animations.
    /// Configured with custom duration and curve settings.
    late final AnimationController _animationController;
    
    /// **Y-axis translation animation for menu slide effect**
    /// 
    /// Animates the vertical translation of the HomePage when menu opens/closes.
    /// Creates the sliding effect that reveals the menu underneath.
    late final Animation<double> _translateYAnimation;
    
    /// **Translation distance for menu animation**
    /// 
    /// Defines how far the HomePage slides down when menu opens.
    /// Set to 400.0 pixels for optimal visual effect.
    late final double _translationYValue;
    
    /// **Animation duration in milliseconds**
    /// 
    /// Controls the speed of menu open/close animations.
    /// Set to 600ms for smooth, responsive feel.
    late final int _animationDuration;
    
    /// **Border radius for HomePage during menu animation**
    /// 
    /// Creates rounded corners effect when menu is open.
    /// Animates between 0 (closed) and 15 (open) for visual polish.
    double _borderRadius = 0.0;
    
    /// **Lottie animation handler for loading states**
    /// 
    /// Manages loading animations during backup operations.
    /// Provides play/stop controls for animated feedback.
    final LottieAnimator _lottieAnimator = LottieAnimator();
    // %%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% INIT STATE %%%%%%%%%%%%%%%%%%%
    /// **Initializes state and sets up animations and menu options**
    /// 
    /// This method:
    /// - Retrieves ThemeViewModel from dependency injection
    /// - Configures animation parameters and controllers
    /// - Sets up translation animation with easing curves
    /// - Populates menu options with their respective actions
    /// 
    /// Menu options include:
    /// - Theme switching (light/dark mode toggle)
    /// - Backup import with loading animation
    /// - Backup export with loading animation  
    /// - TTS language selection dialog
    @override
    void initState() {
        super.initState();

        // Initialize theme service and animation parameters
        _themeViewModel = GetIt.instance<ThemeViewModel>();
        _translationYValue = 400.0;
        _animationDuration = 600;

        // Set up animation controller with custom duration
        _animationController = AnimationController(
            vsync: this,
            duration: Duration(milliseconds: _animationDuration),
        );

        // Configure translation animation with smooth easing
        _translateYAnimation = Tween<double>(begin: 0.0, end: _translationYValue).animate(
            CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
        );

        // Get media controller for backup operations
        final mediaController = GetIt.instance<MediaController>();

        // Build menu options list
        myMenuMist = [

            // oooooooooooooo CHANGE THEME ooooooooooooooooo
            // Theme toggle option - switches between light and dark modes
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
            // Backup import option - restores data from file with loading animation
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
            // Backup export option - saves data to file with loading animation
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
            // TTS language option - opens dialog to select speech language
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
    /// **Toggles menu visibility with smooth animations**
    /// 
    /// This method handles the menu open/close state transitions:
    /// - Flips the isMenuOpen boolean state
    /// - Starts forward animation (open) or reverse animation (close)
    /// - Updates border radius for visual polish during transition
    /// 
    /// When opening:
    /// - Sets border radius to 15 for rounded HomePage corners
    /// - Starts forward animation to slide HomePage down
    /// 
    /// When closing:
    /// - Resets border radius to 0 for sharp corners
    /// - Starts reverse animation to slide HomePage back up
    /// 
    /// The setState call triggers a rebuild with the new animation values.
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
    /// **Displays TTS language selection dialog**
    /// 
    /// Shows an AlertDialog with a PickerField containing available TTS languages.
    /// The user can select from predefined language options, and the choice is
    /// immediately saved to persistent storage via TtsService.
    /// 
    /// Parameters:
    /// - title: String title displayed in the dialog header
    /// 
    /// Returns:
    /// - Future<String?>: Selected language string, or null if canceled
    /// 
    /// Dialog features:
    /// - Current TTS language shown as hint text
    /// - Dropdown picker with formatted language names
    /// - Immediate persistence of language selection
    /// - Themed UI matching app appearance
    /// - Barrier dismissible for easy cancellation
    /// 
    /// Example usage:
    /// ```dart
    /// String? selectedLang = await chooseSpeechLang("Choose Language");
    /// ```
    Future<String?> chooseSpeechLang (String title) async {

        // Get current TTS language for display
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
    /// **Builds the root page UI with animated menu system**
    /// 
    /// Creates a layered interface using Stack:
    /// 
    /// Bottom layer: LottieAnimator with MyMenu
    /// - Handles loading animations during backup operations
    /// - Contains the slide-out menu with options
    /// - Semi-transparent background overlay
    /// 
    /// Top layer: AnimatedPositioned HomePage
    /// - Main application content (CineBook interface)
    /// - Animated translation and border radius effects  
    /// - Responds to menu toggle animations
    /// 
    /// Animation system:
    /// - Uses AnimationController for smooth transitions
    /// - Matrix4 transform for Y-axis translation
    /// - ClipRRect for animated border radius
    /// - Coordinated timing with easeInOutCubic curve
    /// 
    /// Parameters:
    /// - context: BuildContext for theme and navigation access
    /// 
    /// Returns:
    /// - Widget: Scaffold containing the complete animated interface
    @override
    Widget build(BuildContext context) {

        return Scaffold(

            body: Stack(
                children: [
                    // Background layer: Lottie animator with menu
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
                    
                    // Foreground layer: Animated main content
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
                                // Apply Y-axis translation transform
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