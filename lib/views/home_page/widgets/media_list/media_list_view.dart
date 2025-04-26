import 'package:first_project/core/themes/color_palette.dart';
import 'package:first_project/core/widgets/toggle_button_group.dart';
import 'package:first_project/views/home_page/widgets/card.dart';
import 'package:first_project/views/home_page/widgets/media_list/media_list_controller.dart';
import 'package:first_project/models/media.dart';
import 'package:first_project/views/home_page/widgets/media_list/media_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


// $$$$$$$$$$$$$$$$$$$ STATEFUL $$$$$$$$$$$$$$$$$$$$$$
class MediaListPage extends StatefulWidget {

    // %%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%
    final Mediatype mediaType;
    final String pageTitle;
    final List<Media> mediaList;
    // %%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%
    const MediaListPage({

        super.key, 
        required this.mediaType, 
        required this.pageTitle,
        required this.mediaList
    });
    // %%%%%%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% CREATE STATE %%%%%%%%%%%%%%%%%%%%%%
    @override
    State<StatefulWidget> createState() => MediaListPageState();
    // %%%%%%%%%%%%%%%%%%%% END - CREATE STATE %%%%%%%%%%%%%%%%%%%%%%
}
// $$$$$$$$$$$$$$$$$$$ END - STATEFUL $$$$$$$$$$$$$$$$$$$$$$







// $$$$$$$$$$$$$$$$$$$$ STATE $$$$$$$$$$$$$$$$$$$$$$$$$$$$

class MediaListPageState extends State<MediaListPage>{

    // %%%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%
    late final MediaListController _controller;
    // %%%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%% INIT %%%%%%%%%%%%%%%%%%%%%
    @override void initState() {
        super.initState();

        _controller = MediaListController(widget.mediaType);
    }
    // %%%%%%%%%%%%%%%%%%%%%% END - INIT %%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%%%%%%
    @override
    Widget build(BuildContext context) {
    
    // ooooooooooooooo VARIABLES ooooooooooooooooo
    final viewModel = Provider.of<MediaListViewModel>(context);

    Color searchBarBackground = Theme.of(context).brightness == Brightness.dark ? AppColors.darkField : AppColors.lightField;
    // ooooooooooooooo END - VARIABLES ooooooooooooooooo


    return Scaffold(

        // oooooooooooooooooooo BODY oooooooooooooooooo
        body: Padding(
            
            padding: EdgeInsets.fromLTRB(15, 20, 15, 50), 

            child: Column(
                spacing: 20,
                children: [

                    // :::::-:::::-:-- SEARCH BAR :::::-:::::-:--
                    TextField(
                        decoration: InputDecoration(

                            hintText: "Search here...",
                            prefixIcon: Icon(Icons.search),
                            filled: true,
                            fillColor: searchBarBackground,
                            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),

                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(70),
                                borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    width: .02,
                                ),
                            )

                        ),
                        
                    ),
                    // :::::-:::::-:-- END - SEARCH BAR :::::-:::::-:--


                    // ::--::::::-::-::--::: SORT BUTTONS ::--::::::-::-::--:::
                    Row(
                        spacing: 5,
                        children: [
                            Text(
                                "Sort by",
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w600
                                ),
                            ),

                            SizedBox(width: 5),

                            ToggleButtonGroup(
                                buttons: viewModel.sortButtons,
                                onChanged: (selectedIndex, buttons) => viewModel.sortBy(selectedIndex, buttons),
                            ),
                        ],
                    ),
                    
                    // ::--::::::-::-::--::: END - SORT BUTTONS ::--::::::-::-::--:::



                    // ::--::::::-::-::--::: LIST VIEW ::--::::::-::-::--:::
                    Expanded(

                        child: ListView.builder(
                        itemCount: widget.mediaList.length,

                        itemBuilder: (context, index) {
                            return MediaCard(
                                media: widget.mediaList[index],
                            );
                        }
                    ),
                    
                    )
                    
                    // ::--::::::-::-::--::: END - LIST VIEW ::--::::::-::-::--:::
                ],
            ),
        ),
        // oooooooooooooooooooo END - BODY oooooooooooooooooo



        // ooooooooooooooooo FLOATING ACTION BUTTON oooooooooooooooo
        floatingActionButton: FloatingActionButton(

            // On pressed
            onPressed: _controller.goToAddNewMedia,
            // child
            child: const Icon(Icons.add),
        ),
        // ooooooooooooooooo END - FLOATING ACTION BUTTON oooooooooooooooo

    );
  }
    // %%%%%%%%%%%%%%%%%% END - BUILD %%%%%%%%%%%%%%%%%%%%%%
}
// $$$$$$$$$$$$$$$$$$$$ END - STATE $$$$$$$$$$$$$$$$$$$$$$$$$$$$