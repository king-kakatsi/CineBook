import 'package:first_project/pages/anime_page.dart';
import 'package:first_project/pages/media_edit_page.dart';
import 'package:first_project/pages/series_page.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// @@@@@@@@@@@@@@@@@@ HOME PAGE - STATEFUL @@@@@@@@@@@@@@@@@@
/// **Main home page widget that serves as the primary navigation hub for the Cinebook app.**
/// 
/// This page provides a tabbed interface to switch between Series and Anime collections.
/// It includes an app bar with the app icon and menu button, a bottom navigation bar
/// for tab switching, and a floating action button to add new media items.
/// 
/// Features:
/// - Tab-based navigation between Series and Anime pages
/// - Floating action button for adding new media (context-aware based on current tab)
/// - App bar with custom icon and menu functionality
/// - Bottom navigation bar with themed styling
/// 
/// Example usage:
/// ```dart
/// HomePage(
///   title: 'Cinebook',
///   onMenuPressed: () => print('Menu pressed'),
/// )
/// ```
class HomePage extends StatefulWidget {

  // %%%%%%%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%
  /// Title displayed in the app bar
  final String title;
  
  /// Callback function triggered when the menu button is pressed
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
// @@@@@@@@@@@@@@@@@@ END - HOME PAGE - STATEFUL @@@@@@@@@@@@@@@@@@





// @@@@@@@@@@@@@@@@@@ HOME PAGE - STATE @@@@@@@@@@@@@@@@@@
/// **State class for HomePage widget.**
/// 
/// Manages the tab navigation state and handles switching between Series and Anime pages.
/// Controls the display of appropriate content based on the selected tab and manages
/// the floating action button behavior for adding new media items.
class HomePageState extends State<HomePage> {

    // %%%%%%%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%
    /// List of page widgets that can be displayed in the tab view
    late final List<Widget> _pages;
    
    /// Index of the currently selected tab/page (0 = Series, 1 = Anime)
    int _selectedPageIndex = 0;
    // %%%%%%%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% INIT STATE %%%%%%%%%%%%%%%%
    @override
    void initState() {
        super.initState();

        // Initialize the list of pages for tab navigation
        _pages = [
            SeriesPage(),
            AnimePage()
        ];
    }
    // %%%%%%%%%%%%%%%%%%%% END - INIT STATE %%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% CHANGE TAB %%%%%%%%%%%%%%%%%%%%
    /// **Handles tab selection changes in the bottom navigation bar.**
    /// 
    /// Updates the selected page index and triggers a UI rebuild to display
    /// the corresponding page content.
    /// 
    /// Parameters:
    /// - index : The index of the selected tab (0 for Series, 1 for Anime)
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
                // App icon on the left
                leading: Image.asset('assets/icon/icon.png'),
                title: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headlineLarge,
                ),

                actions: [
                    // Menu button on the right
                    IconButton(
                        onPressed: widget.onMenuPressed, 
                        icon: Icon(Icons.menu),
                    ),
                    
                ],
            ),
            // ooooooooooooo END - APP BAR ooooooooooooooooo


            // ooooooooooooooo BODY ooooooooooooooooooo
            // Display the currently selected page
            body: _pages[_selectedPageIndex],
            // ooooooooooooooo END - BODY ooooooooooooooooooo
            

            // ooooooooooooooooo FLOATING ACTION BUTTON oooooooooooooooo
            floatingActionButton: FloatingActionButton(

                // Navigate to media edit page with context-aware parameters
                // onPressed: _controller.goToAddNewMedia,
                onPressed: () => Navigator.of(context).pushNamed(
                    "/mediaEdit",
                    
                    arguments: {
                        // Dynamic title based on selected tab
                        'title': _selectedPageIndex == 0 ?
                            'Add series':
                            'Add anime',

                        // Dynamic action based on selected tab
                        'editPageAction': _selectedPageIndex == 0 ? 
                            EditPageAction.createSeries : 
                            EditPageAction.createAnime,

                        'onSubmit': _selectedPageIndex == 0 ? 
                        EditPageAction.createSeries : 
                        EditPageAction.createAnime,

                        // No existing media for creation mode
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

                    // Series tab
                    BottomNavigationBarItem(
                        icon: Icon(Icons.movie),
                        label: "Series"
                    ),

                    // Animes tab
                    BottomNavigationBarItem(
                        icon: Icon(Icons.book),
                        label: "Animes"
                    )
                ],
                // ::-----::::::::--:: END - PAGES ::-----::::::::--::

                // Theme-based styling
                backgroundColor: Theme.of(context).colorScheme.primary,
                selectedItemColor: Theme.of(context).colorScheme.secondary,
                unselectedItemColor: Colors.white54,
            ),
            // oooooooooooooooooo END - BOTTOM NAVIGATION BAR ooooooooooooooo
        );
    }
    // %%%%%%%%%%%%%%%%%%%% END - BUILD %%%%%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@@@@@@@ END - HOME PAGE - STATE @@@@@@@@@@@@@@@@@@