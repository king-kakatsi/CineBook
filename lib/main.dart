
import 'package:first_project/core/themes/app_theme.dart';
import 'package:first_project/views/home_page/home_page.dart';
import 'package:first_project/views/home_page/widgets/media_list/media_list_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

void main() {

    final getIt = GetIt.instance;
    getIt.registerSingleton<MediaListViewModel>(MediaListViewModel());

    runApp(MyApp());
}




// %%%%%%%%%%%%%%%%%%%%%%% MY APP %%%%%%%%%%%%%%%%%%%%%%%
class MyApp extends StatelessWidget {
    const MyApp({super.key});

    // This widget is the root of the application.
    @override
    Widget build(BuildContext context) {

        final getIt = GetIt.instance;

        return MultiProvider(
            providers: [
                ChangeNotifierProvider<MediaListViewModel>.value(value: getIt<MediaListViewModel>())
            ],

            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'CineBook App',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: ThemeMode.dark,
                home: const HomePage(title: 'CineBook'),
            ),
        );
         
    }
}
// %%%%%%%%%%%%%%%%%%%%%%% MY APP %%%%%%%%%%%%%%%%%%%%%%%


