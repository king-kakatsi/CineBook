// import 'package:first_project/viewmodels/home_viewmodel.dart';
// import 'package:first_project/views/home_page/home_page_controller.dart';
import 'package:first_project/views/anime_page/anime_page.dart';
import 'package:first_project/views/media_edit/media_edit_page.dart';
import 'package:first_project/views/series_page/series_page.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// $$$$$$$$$$$$$$$$$$$ HOME PAGE - STATEFUL $$$$$$$$$$$$$$$$$$$
class HomePage extends StatefulWidget {

  // %%%%%%%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%
  final String title;
  final VoidCallback onMenuPressed;
  // %%%%%%%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%




  // %%%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%%
  const HomePage({

        super.key, 
        required this.title,
        required this.onMenuPressed,
    });
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
    // %%%%%%%%%%%%%%%%%% END - CHANGE TAB %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%%%%
    @override
    Widget build(BuildContext context) {

        return Scaffold(
            // ooooooooooooo APP BAR ooooooooooooooooo
            appBar: AppBar(
                title: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headlineLarge,
                ),

                actions: [
                    IconButton(
                        onPressed: widget.onMenuPressed, 
                        icon: Icon(Icons.menu),
                    ),
                    
                ],
            ),
            // ooooooooooooo END - APP BAR ooooooooooooooooo


            // ooooooooooooooo BODY ooooooooooooooooooo
            body: pages[selectedPageIndex],
            // ooooooooooooooo END - BODY ooooooooooooooooooo
            

            // ooooooooooooooooo FLOATING ACTION BUTTON oooooooooooooooo
            floatingActionButton: FloatingActionButton(

                // On pressed
                // onPressed: _controller.goToAddNewMedia,
                onPressed: () => Navigator.of(context).pushNamed(
                    "/mediaEdit",
                    
                    arguments: {
                        'title': selectedPageIndex == 0 ?
                            'Add series':
                            'Add anime',

                        'editPageAction': selectedPageIndex == 0 ? 
                            EditPageAction.createSeries : 
                            EditPageAction.createAnime,

                        'onSubmit': selectedPageIndex == 0 ? 
                        EditPageAction.createSeries : 
                        EditPageAction.createAnime,

                        'media': null,
                    }
                ),
                // child
                child: const Icon(Icons.add),
            ),
            // ooooooooooooooooo END - FLOATING ACTION BUTTON oooooooooooooooo


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
                ],
                // ::-----::::::::--:: END - PAGES ::-----::::::::--::

                backgroundColor: Theme.of(context).colorScheme.primary,
                selectedItemColor: Theme.of(context).colorScheme.secondary,
                unselectedItemColor: Colors.white54,
            ),
            // oooooooooooooooooo END - BOTTOM NAVIGATION BAR ooooooooooooooo
        );
    }
    // %%%%%%%%%%%%%%%%%%%% END - BUILD %%%%%%%%%%%%%%%%%%%%
}
// $$$$$$$$$$$$$$$$$$$ END - HOME PAGE - STATE $$$$$$$$$$$$$$$$$$$