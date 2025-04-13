// import 'package:first_project/viewmodels/home_viewmodel.dart';
// import 'package:first_project/views/home_page/home_page_controller.dart';
import 'package:first_project/views/manga_page/anime_page.dart';
import 'package:first_project/views/series_page/series_page.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// $$$$$$$$$$$$$$$$$$$ HOME PAGE - STATEFUL $$$$$$$$$$$$$$$$$$$
class HomePage extends StatefulWidget {

  // %%%%%%%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%
  final String title;
  // %%%%%%%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%




  // %%%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%%
  const HomePage({super.key, required this.title});
  // %%%%%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% CREATE STATE %%%%%%%%%%%%%%%%%%%
  @override
  State<HomePage> createState() => HomePageState();
    // %%%%%%%%%%%%%%%%%%%% END - CREATE STATE %%%%%%%%%%%%%%%%%%%
}
// $$$$$$$$$$$$$$$$$$$ END - HOME PAGE - STATEFUL $$$$$$$$$$$$$$$$$$$








// $$$$$$$$$$$$$$$$$$$ HOME PAGE - STATE $$$$$$$$$$$$$$$$$$$
class HomePageState extends State<HomePage> {

    // %%%%%%%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%

    final pages = [
        SeriesPage(),
        AnimePage()
    ];

    int selectedPageIndex = 0;
    // %%%%%%%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% CHANGE TAB %%%%%%%%%%%%%%%%%%%%
    void onTabTapped(int index) {
        setState(() {
            selectedPageIndex = index;
        });
    }
    // %%%%%%%%%%%%%%%%%% END - CHANGE TAB %%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%%%%
    @override
    Widget build(BuildContext context) {

        return Scaffold(
            // ooooooooooooo APP BAR ooooooooooooooooo
            appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text(widget.title),
            ),
            // ooooooooooooo END - APP BAR ooooooooooooooooo



            // ooooooooooooooo BODY ooooooooooooooooooo
            body: pages[selectedPageIndex],
            // ooooooooooooooo END - BODY ooooooooooooooooooo



            // oooooooooooooooooo BOTTOM NAVIGATION BAR ooooooooooooooo
            bottomNavigationBar: BottomNavigationBar(

                currentIndex: selectedPageIndex,
                onTap: (int index) => onTabTapped(index),

                // ::-----::::::::--:: PAGES ::-----::::::::--::
                items: const [

                    // Series
                    BottomNavigationBarItem(
                        icon: Icon(Icons.movie),
                        label: "Series"
                    ),

                    // Animes
                    BottomNavigationBarItem(
                        icon: Icon(Icons.book),
                        label: "Animes"
                    )
                ]
                // ::-----::::::::--:: END - PAGES ::-----::::::::--::

            ),
            // oooooooooooooooooo END - BOTTOM NAVIGATION BAR ooooooooooooooo
        );
    }
    // %%%%%%%%%%%%%%%%%%%% END - BUILD %%%%%%%%%%%%%%%%%%%%
}
// $$$$$$$$$$$$$$$$$$$ END - HOME PAGE - STATE $$$$$$$$$$$$$$$$$$$