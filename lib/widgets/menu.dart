import 'package:flutter/material.dart';

// @@@@@@@@@@@@@@@@@@@ MENU OPTION @@@@@@@@@@@@@@@@

/// **Data model for menu option configuration**
///
/// This class represents a single menu item with an icon, title, and associated action.
/// Used to configure menu options in MyMenu widget.
///
/// Properties:
/// - icon : IconData for the menu item icon
/// - title : String text displayed for the menu item
/// - action : VoidCallback function executed when menu item is tapped
///
/// Example usage:
/// ```dart
/// MenuOption option = MenuOption(
///   icon: Icons.settings,
///   title: "Settings",
///   action: () => navigateToSettings(),
/// );
/// ```
class MenuOption {

    // %%%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%
    /// Icon displayed for this menu option
    final IconData icon;
    /// Title text displayed for this menu option
    final String title;
    /// Callback function executed when this menu option is tapped
    final VoidCallback action;
    // %%%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%



    // %%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%
    /// Creates a MenuOption with required icon, title, and action
    MenuOption({
        required this.icon,
        required this.title,
        required this.action,
    });
    // %%%%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@@@@@@@@ END - MENU OPTION @@@@@@@@@@@@@@@@





// @@@@@@@@@@@@ STATEFUL @@@@@@@@@@@@@@@@

/// **Customizable menu widget with header and action list**
///
/// This widget creates a vertical menu interface with a header containing
/// a title and close button, followed by a scrollable list of menu options.
/// Each menu option displays an icon and title, and executes its associated
/// action when tapped.
///
/// Features:
/// - Header with "Menu" title and close button
/// - Scrollable list of menu options with icons
/// - Automatic action execution on option tap
/// - Themed styling following Material Design
///
/// Parameters:
/// - menuList : List of MenuOption objects to display in the menu
/// - onClose : Callback function executed when close button is pressed
///
/// Example usage:
/// ```dart
/// MyMenu(
///   menuList: [
///     MenuOption(icon: Icons.home, title: "Home", action: () => goHome()),
///     MenuOption(icon: Icons.settings, title: "Settings", action: () => openSettings()),
///   ],
///   onClose: () => Navigator.pop(context),
/// )
/// ```
// ignore: must_be_immutable
class MyMenu extends StatefulWidget {


    // %%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%
    /// List of menu options to display in the menu
    late List<MenuOption> menuList;
    /// Callback function executed when close button is pressed
    final VoidCallback onClose;
    // %%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%%%
    /// Creates a MyMenu with required menu options list and close callback
    MyMenu ({

        super.key,
        required this.menuList,
        required this.onClose,
    });
    // %%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%% CREATE STATE %%%%%%%%%%%%%%%%%
    @override State<MyMenu> createState() => MyMenuState();
    // %%%%%%%%%%%%% END - CREATE STATE %%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@ END - STATEFUL @@@@@@@@@@@@@@@@





// @@@@@@@@@@@@@@@@@@ STATE @@@@@@@@@@@@@@@@

/// **State management for MyMenu widget**
///
/// Handles menu option interactions and UI rendering.
/// Manages the execution of menu option actions when items are tapped.
class MyMenuState extends State<MyMenu> {


    // %%%%%%%%%%%%%%%%%%%%%%%% EXECUTE MENU OPTION ACTION %%%%%%%%%%%%%%%%%%%%%%%%%%
    /// **Executes the action associated with a menu option**
    ///
    /// This method is called when a menu option is tapped. It retrieves the
    /// MenuOption at the specified index and executes its associated action callback.
    ///
    /// Parameters:
    /// - index : int index of the menu option in the menuList
    ///
    /// The method directly calls the action() function of the selected MenuOption.
    /// No validation is performed on the index as ListView.builder ensures valid indices.
    ///
    /// Example usage:
    /// ```dart
    /// onMenuOptionTapped(0); // Executes action of first menu option
    /// ```
    void onMenuOptionTapped(index) {
        
        widget.menuList[index].action(); 
    }
    // %%%%%%%%%%%%%%%%%%%%%%%% END - EXECUTE MENU OPTION ACTION %%%%%%%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%
    @override
    Widget build(BuildContext context) {

        return Container (
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 50),
            child: Column(
                children: [

                    // oooooooooooooo HEADER ooooooooooooooooo
                    // Menu header with title and close button
                    Row(
                        children: [

                            // °°°°°°°°°°° TITLE °°°°°°°°°°°°
                            Text(
                                "Menu",
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontSize: 22,
                                ),
                            ),
                            // °°°°°°°°°°° END - TITLE °°°°°°°°°°°°


                            Expanded(child: Container()),


                            // °°°°°°°°°°°°° CLOSE BUTTON °°°°°°°°°°°°°
                            CircleAvatar(
                                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,

                                child: IconButton(
                                    icon: Icon(Icons.close),
                                    color: Theme.of(context).colorScheme.onSurface,
                                    onPressed: () => widget.onClose(),
                                ),
                            )
                            // °°°°°°°°°°°°° END - CLOSE BUTTON °°°°°°°°°°°°°
                        ],
                    ),
                    // oooooooooooooo END - HEADER ooooooooooooooooo

                    
                    // oooooooooooooo LIST VIEW oooooooooooooo
                    // Scrollable list of menu options
                    Expanded(
                            child: ListView.builder(
                                itemCount: widget.menuList.length,

                                itemBuilder: (context, index) {
                                    var menuOption = widget.menuList[index];

                                    return ListTile(
                                        leading: Icon(menuOption.icon),
                                        title: Text(
                                            menuOption.title,
                                        ),
                                        // Execute menu option action on tap
                                        onTap: () => onMenuOptionTapped(index),
                                    );
                                }
                            ),
                        
                        ),
                    // oooooooooooooo END - LIST VIEW oooooooooooooo
                ],
            ),
        );
    }
    // %%%%%%%%%%%%%%%% END - BUILD %%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@@@@@@@ END - STATE @@@@@@@@@@@@@@@@