
import 'package:first_project/core/widgets/toggle_button_group.dart';
import 'package:first_project/views/home_page/widgets/card.dart';
// import 'package:first_project/views/home_page/widgets/media_list/media_list_controller.dart';
import 'package:first_project/models/media.dart';
import 'package:first_project/views/home_page/widgets/media_list/media_list_viewmodel.dart';
import 'package:first_project/views/media_edit/media_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


// $$$$$$$$$$$$$$$$$$$ STATEFUL $$$$$$$$$$$$$$$$$$$$$$
class MediaListPage extends StatefulWidget {

    // %%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%
    final Mediatype mediaType;
    final String pageTitle;
    final String hiveBoxName;
    // %%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%
    const MediaListPage({

        super.key, 
        required this.mediaType, 
        required this.pageTitle,
        required this.hiveBoxName
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
    // late final MediaListController _controller;
    // %%%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%% INIT %%%%%%%%%%%%%%%%%%%%%
    @override void initState() {
        super.initState();

        // _controller = MediaListController(widget.mediaType);
        final MediaListViewModel viewModel = Provider.of<MediaListViewModel>(context, listen: false);
        viewModel.hiveBoxName = widget.hiveBoxName;
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
            viewModel.initialize();
        });

    }
    // %%%%%%%%%%%%%%%%%%%%%% END - INIT %%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%%%%%%
    @override
    Widget build(BuildContext context) {

        final MediaListViewModel viewModel = Provider.of<MediaListViewModel>(context);

        return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),

            child: Scaffold(

                // oooooooooooooooooooo BODY oooooooooooooooooo
                body: Padding(
                    
                    padding: EdgeInsets.fromLTRB(15, 20, 15, 50), 

                    child: Column(
                        spacing: 20,
                        children: [

                            // :::::-:::::-:-- SEARCH BAR :::::-:::::-:--
                            TextField(
                                onChanged: (value) => viewModel.search(value),

                                decoration: InputDecoration(

                                    hintText: "Search here...",
                                    prefixIcon: Icon(Icons.search),
                                    filled: true,
                                    fillColor: Theme.of(context).colorScheme.surfaceContainer,
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


                            // ::--::::::-::-::--::: LIST ACTION BUTTONS ::--::::::-::-::--:::
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

                                    SizedBox(width: 10),

                                    // °°°°°°°°°°°°°° SORT BUTTONS °°°°°°°°°°°°°°°°°
                                    Flexible(
                                        fit: FlexFit.loose, 
                                        child: ToggleButtonGroup(
                                            buttons: viewModel.sortButtons,
                                            onChanged: (selectedIndex, buttons) => viewModel.sortBy(selectedIndex, buttons),
                                        ),
                                    ),
                                    // °°°°°°°°°°°°°° END - SORT BUTTONS °°°°°°°°°°°°°°°°°

                                    SizedBox(width: 5),

                                    // °°°°°°°°°°°°°°°° REVERSE BUTTON °°°°°°°°°°°°°°°°°°°
                                    IconButton(
                                        onPressed: viewModel.reverseList, 
                                        iconSize: 30,

                                        icon: Icon(
                                            Icons.swap_vertical_circle, 
                                            color: Theme.of(context).colorScheme.surfaceContainerHigh,          
                                        ),
                                    ),
                                    // °°°°°°°°°°°°°°°° END - REVERSE BUTTON °°°°°°°°°°°°°°°°°°° 
                                ],
                            ),
                            // ::--::::::-::-::--::: END - LIST ACTION BUTTONS ::--::::::-::-::--:::


                            // ::--::::::-::-::--::: LIST VIEW ::--::::::-::-::--:::
                            Expanded(

                                child: ListView.builder(
                                    itemCount: viewModel.mediaList.length,

                                    itemBuilder: (context, index) {
                                        return MediaCard(
                                            media: viewModel.mediaList[index],

                                            onEdit: () => Navigator.of(context).pushNamed(
                                                "/mediaEdit",
                                                
                                                arguments: {
                                                    'title': widget.mediaType == Mediatype.series ?
                                                        'Edit series':
                                                        'Edit anime',

                                                    'editPageAction': widget.mediaType == Mediatype.series ? 
                                                        EditPageAction.editSeries : 
                                                        EditPageAction.editAnime,

                                                    'media': viewModel.mediaList[index],
                                                }
                                            ),
                                            
                                            onDelete: () => viewModel.deleteInList(context, viewModel.mediaList[index].uniqueId)
                                        );
                                    }
                                ),
                            
                            ),
                            // ::--::::::-::-::--::: END - LIST VIEW ::--::::::-::-::--:::
                        ],
                    ),
                ),
                // oooooooooooooooooooo END - BODY oooooooooooooooooo
            )
        );
    }
    // %%%%%%%%%%%%%%%%%% END - BUILD %%%%%%%%%%%%%%%%%%%%%%
}
// $$$$$$$$$$$$$$$$$$$$ END - STATE $$$$$$$$$$$$$$$$$$$$$$$$$$$$