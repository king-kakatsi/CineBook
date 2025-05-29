import 'package:flutter/material.dart';

// @@@@@@@@@@@@@@@@@@@ MENU OPTION @@@@@@@@@@@@@@@@

class MenuOption {

    // %%%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%
    final IconData icon;
    final String title;
    final VoidCallback action;
    // %%%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%



    // %%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%
    MenuOption({
        required this.icon,
        required this.title,
        required this.action,
    });
    // %%%%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@@@@@@@@ END - MENU OPTION @@@@@@@@@@@@@@@@





// @@@@@@@@@@@@ STATEFUL @@@@@@@@@@@@@@@@

// ignore: must_be_immutable
class MyMenu extends StatefulWidget {


    // %%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%
    late List<MenuOption> menuList;
    final VoidCallback onClose;
    // %%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%%%
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
class MyMenuState extends State<MyMenu> {


    // %%%%%%%%%%%%%%%%%% EXECUTE MENU OPTION ACTION %%%%%%%%%%%%%%%%%
    void onMenuOptionTapped(index) {
        
        widget.menuList[index].action(); 
    }
    // %%%%%%%%%%%%%%%%%% END - EXECUTE MENU OPTION ACTION %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%
    @override
    Widget build(BuildContext context) {

        return Container (
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 50),
            child: Column(
                children: [

                    // oooooooooooooo HEADER ooooooooooooooooo
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