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
void main() async {

    WidgetsFlutterBinding.ensureInitialized();
    initGetIt();
    await initHive();
    runApp(AppRoot());
}



    // %%%%%%%%%%%%%%%%% INIT GET IT %%%%%%%%%%%%%%%%%%%%
    void initGetIt() {
        final getIt = GetIt.instance;
        getIt.registerSingleton<MediaController>(MediaController());
        getIt.registerSingleton<ThemeViewModel>(ThemeViewModel());
    }
    // %%%%%%%%%%%%%%%%% END - INIT GET IT %%%%%%%%%%%%%%%%%%%%



    // %%%%%%%%%%%%%%%%%% INIT HIVE %%%%%%%%%%%%%%%%%%%%
    Future<void> initHive() async {
        final appDocDir = await getApplicationDocumentsDirectory();
        Hive.init(appDocDir.path);

        Hive.registerAdapter(MediatypeAdapter());
        Hive.registerAdapter(SeasonAdapter());
        Hive.registerAdapter(MediaAdapter());

        // await Hive.deleteBoxFromDisk(Mediatype.series.name);
        // await Hive.deleteBoxFromDisk(Mediatype.anime.name);
        await Hive.openBox<Media>(Mediatype.series.name);
        await Hive.openBox<Media>(Mediatype.anime.name);
    }
    // %%%%%%%%%%%%%%%%%% END - INIT HIVE %%%%%%%%%%%%%%%%%%%%

// @@@@@@@@@@@@@@@@@@@ END - MAIN @@@@@@@@@@@@@@@@@@@@@@@@





// @@@@@@@@@@@@@@@@ APP ROOT @@@@@@@@@@@@@@@@@@@@@
class AppRoot extends StatelessWidget {
  const AppRoot({super.key});


    @override
    Widget build(BuildContext context) {

        final getIt = GetIt.instance;
    
        return MultiProvider(
            providers: [
                ChangeNotifierProvider<MediaController>.value(value: getIt<MediaController>()),
                ChangeNotifierProvider<ThemeViewModel>.value(value: getIt<ThemeViewModel>()),
            ],

            child: MyApp(),
        );
    }
}
// @@@@@@@@@@@@@@@@à END - APP ROOT @@@@@@@@@@@@@@@@@@@@@




// %%%%%%%%%%%%%%%%%%%%%%% MY APP %%%%%%%%%%%%%%%%%%%%%%%

class MyApp extends StatelessWidget {
    const MyApp({super.key});

    // This widget is the root of the application.
    @override
    Widget build(BuildContext context) {

        return MaterialApp(
            debugShowCheckedModeBanner: false,
            // navigatorKey: navigatorKey,
            title: 'CineBook App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: context.watch<ThemeViewModel>().themeMode,
            // home: RootPage(),
            

            // ooooooooooooooooooo ROUTES ooooooooooooooooooooo
            initialRoute: "/",
            routes: {
                
                // °°°°°°°°°° HOME °°°°°°°°°°°°°°°
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


                // °°°°°°°°°°°°°°°° MEDIA DEATILS PAGE °°°°°°°°°°°°°°°°°
                "/mediaDetails": (context) {
                    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
                    final Media media = args['media'];

                    return MediaDetailsPage(
                        media: media,
                    );
                },
                // °°°°°°°°°°°°°°°° END - MEDIA DEATILS PAGE °°°°°°°°°°°°°°°°°
            },
            // ooooooooooooooooooo END - ROUTES ooooooooooooooooooooo
        );    
    }
}
// %%%%%%%%%%%%%%%%%%%%%%% MY APP %%%%%%%%%%%%%%%%%%%%%%%


