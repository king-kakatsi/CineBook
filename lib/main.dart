import 'package:first_project/themes/app_theme.dart';
import 'package:first_project/themes/theme_viewmodel.dart';
import 'package:first_project/models/media.dart';
import 'package:first_project/pages/media_details_page.dart';
import 'package:first_project/pages/media_edit_page.dart';
import 'package:first_project/controllers/media_controller.dart';
import 'package:first_project/pages/root_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';


// @@@@@@@@@@@@@@@@@@@ MAIN @@@@@@@@@@@@@@@@@@@@@@@@
/// **Application entry point**
/// 
/// Initializes all required services and dependencies before launching the app.
/// Sets up dependency injection, database initialization, and runs the Flutter app.
/// 
/// Initialization sequence:
/// 1. Ensures Flutter widget binding is initialized
/// 2. Configures GetIt dependency injection container
/// 3. Initializes Hive database with adapters and boxes
/// 4. Launches the app with AppRoot widget
void main() async {

    WidgetsFlutterBinding.ensureInitialized();
    initGetIt();
    await initHive();
    runApp(AppRoot());
}



    // %%%%%%%%%%%%%%%%%%%%%%%% INITIALIZE DEPENDENCY INJECTION %%%%%%%%%%%%%%%%%% 
    /// **Configures GetIt dependency injection container**
    /// 
    /// Registers all application-wide singletons for dependency injection.
    /// These instances are accessible throughout the app via GetIt.instance<T>().
    /// 
    /// Registered services:
    /// - MediaController: Manages media data operations and state
    /// - ThemeViewModel: Handles theme switching and persistence
    /// 
    /// Example usage:
    /// ```dart
    /// final mediaController = GetIt.instance<MediaController>();
    /// final themeViewModel = GetIt.instance<ThemeViewModel>();
    /// ```
    void initGetIt() {
        final getIt = GetIt.instance;
        getIt.registerSingleton<MediaController>(MediaController());
        getIt.registerSingleton<ThemeViewModel>(ThemeViewModel());
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - INITIALIZE DEPENDENCY INJECTION %%%%%%%%%%%%%%%%%%



    // %%%%%%%%%%%%%%%%%%%%%%%% INITIALIZE HIVE DATABASE %%%%%%%%%%%%%%%%%% 
    /// **Sets up Hive database with adapters and storage boxes**
    /// 
    /// Configures Hive NoSQL database for local data persistence.
    /// Registers type adapters for custom objects and opens storage boxes.
    /// 
    /// Returns:
    /// - Future<void>: Completes when database initialization is finished
    /// 
    /// Setup process:
    /// 1. Gets application documents directory for database storage
    /// 2. Initializes Hive with the directory path
    /// 3. Registers custom type adapters for serialization
    /// 4. Opens separate boxes for series and anime data
    /// 
    /// Registered adapters:
    /// - MediatypeAdapter: For MediaType enum serialization
    /// - MediaGenreAdapter: For MediaGenre enum serialization
    /// - WatchStatusAdapter: For WatchStatus enum serialization
    /// - SeasonAdapter: For Season object serialization
    /// - MediaAdapter: For Media object serialization
    /// 
    /// Storage boxes:
    /// - series: Stores all series-type media entries
    /// - anime: Stores all anime-type media entries
    Future<void> initHive() async {
        final appDocDir = await getApplicationDocumentsDirectory();
        Hive.init(appDocDir.path);

        // Register type adapters for custom object serialization
        Hive.registerAdapter(MediatypeAdapter());
        Hive.registerAdapter(MediaGenreAdapter());
        Hive.registerAdapter(WatchStatusAdapter());
        Hive.registerAdapter(SeasonAdapter());
        Hive.registerAdapter(MediaAdapter());

        // Debug: Uncomment to clear database boxes during development
        // await Hive.deleteBoxFromDisk(Mediatype.series.name);
        // await Hive.deleteBoxFromDisk(Mediatype.anime.name);
        
        // Open storage boxes for media data
        await Hive.openBox<Media>(Mediatype.series.name);
        await Hive.openBox<Media>(Mediatype.anime.name);
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - INITIALIZE HIVE DATABASE %%%%%%%%%%%%%%%%%%

// @@@@@@@@@@@@@@@@@@@ END - MAIN @@@@@@@@@@@@@@@@@@@@@@@@





// @@@@@@@@@@@@@@@@ APP ROOT @@@@@@@@@@@@@@@@@@@@@
/// **Root application wrapper with dependency injection providers**
/// 
/// Sets up the Provider pattern for state management by wrapping the main app
/// with MultiProvider to make singletons accessible throughout the widget tree.
/// 
/// This widget configures:
/// - MediaController provider for media data management
/// - ThemeViewModel provider for theme state management
/// 
/// All child widgets can access these providers using context.watch<T>() or context.read<T>().
class AppRoot extends StatelessWidget {
  const AppRoot({super.key});


    @override
    Widget build(BuildContext context) {

        final getIt = GetIt.instance;
    
        return MultiProvider(
            providers: [
                // Provide MediaController singleton for media data operations
                ChangeNotifierProvider<MediaController>.value(value: getIt<MediaController>()),
                // Provide ThemeViewModel singleton for theme management
                ChangeNotifierProvider<ThemeViewModel>.value(value: getIt<ThemeViewModel>()),
            ],

            child: MyApp(),
        );
    }
}
// @@@@@@@@@@@@@@@@ END - APP ROOT @@@@@@@@@@@@@@@@@@@@@




// %%%%%%%%%%%%%%%%%%%%%%% MY APP %%%%%%%%%%%%%%%%%%%%%%%
/// **Main application widget with routing and theme configuration**
/// 
/// Configures the MaterialApp with:
/// - Theme management (light/dark mode switching)
/// - Application routing for all pages
/// - Global app settings and configuration
/// 
/// Features:
/// - Dynamic theme switching via ThemeViewModel
/// - Named route navigation system
/// - Arguments passing between routes
/// - Debug banner disabled for production-ready appearance
class MyApp extends StatelessWidget {
    const MyApp({super.key});

    // This widget is the root of the application.
    @override
    Widget build(BuildContext context) {

        return MaterialApp(
            debugShowCheckedModeBanner: false,
            // navigatorKey: navigatorKey, // Global navigator key if needed
            title: 'CineBook App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            // Watch ThemeViewModel for dynamic theme switching
            themeMode: context.watch<ThemeViewModel>().themeMode,
            

            // ooooooooooooooooooo ROUTES ooooooooooooooooooooo
            initialRoute: "/",
            routes: {
                
                // °°°°°°°°°° HOME °°°°°°°°°°°°°°°
                // Root page route - main application entry point
                "/": (context) => const RootPage(),
                // °°°°°°°°°° END - HOME °°°°°°°°°°°°°°°

                // °°°°°°°°°°°°°°°° MEDIA EDIT PAGE °°°°°°°°°°°°°°°°°
                "/mediaEdit": (context) {
                    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
                    final String title = args['title'];
                    final EditPageAction editPageAction = args['editPageAction'];
                    final Media? media = args['media'];

                    return MediaEditPage(
                        title: title, 
                        editPageAction: editPageAction,
                        media: media,
                    );
                },
                // °°°°°°°°°°°°°°°° END - MEDIA EDIT PAGE °°°°°°°°°°°°°°°°°


                // °°°°°°°°°°°°°°°° MEDIA DETAILS PAGE °°°°°°°°°°°°°°°°°
                "/mediaDetails": (context) {
                    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
                    final Media media = args['media'];

                    return MediaDetailsPage(
                        media: media,
                    );
                },
                // °°°°°°°°°°°°°°°° END - MEDIA DETAILS PAGE °°°°°°°°°°°°°°°°°
            },
            // ooooooooooooooooooo END - ROUTES ooooooooooooooooooooo
        );    
    }
}
// %%%%%%%%%%%%%%%%%%%%%%% MY APP %%%%%%%%%%%%%%%%%%%%%%%