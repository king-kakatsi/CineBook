
import 'package:first_project/pages/anime_page.dart';
import 'package:first_project/pages/media_edit_page.dart';
import 'package:first_project/pages/series_page.dart';
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
    late final List<Widget> _pages;
    int _selectedPageIndex = 0;
    // %%%%%%%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% INIT STATE %%%%%%%%%%%%%%%%
    @override
    void initState() {
        super.initState();

        _pages = [
            SeriesPage(),
            AnimePage()
        ];
    }
    // %%%%%%%%%%%%%%%%%%%% END - INIT STATE %%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% CHANGE TAB %%%%%%%%%%%%%%%%%%%%
    void onTabTapped(int index) {
        setState(() {
            _selectedPageIndex = index;
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
            body: _pages[_selectedPageIndex],
            // ooooooooooooooo END - BODY ooooooooooooooooooo
            

            // ooooooooooooooooo FLOATING ACTION BUTTON oooooooooooooooo
            floatingActionButton: FloatingActionButton(

                // On pressed
                // onPressed: _controller.goToAddNewMedia,
                onPressed: () => Navigator.of(context).pushNamed(
                    "/mediaEdit",
                    
                    arguments: {
                        'title': _selectedPageIndex == 0 ?
                            'Add series':
                            'Add anime',

                        'editPageAction': _selectedPageIndex == 0 ? 
                            EditPageAction.createSeries : 
                            EditPageAction.createAnime,

                        'onSubmit': _selectedPageIndex == 0 ? 
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
                
                currentIndex: _selectedPageIndex,
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