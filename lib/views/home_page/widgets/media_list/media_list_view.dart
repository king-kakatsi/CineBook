import 'package:first_project/views/home_page/widgets/media_list/media_list_controller.dart';
import 'package:first_project/models/media.dart';
import 'package:first_project/views/home_page/widgets/media_list/media_list_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


// $$$$$$$$$$$$$$$$$$$ STATEFUL $$$$$$$$$$$$$$$$$$$$$$
class MediaListPage extends StatefulWidget {

    // %%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%
    final Mediatype mediaType;
    final String pageTitle;
    // %%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%%%%
    const MediaListPage({super.key, required this.mediaType, required this.pageTitle});
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
    // ooooooooooooooo END - VARIABLES ooooooooooooooooo


    return Scaffold(

        // oooooooooooooooooooo BODY oooooooooooooooooo
        body: Column(
            children: [

                // :::::-:::::-:-- SEARCH BAR :::::-:::::-:--
                const Padding(
                    padding: EdgeInsets.all(10),

                    child: TextField(
                        decoration: InputDecoration(
                            hintText: "Search here...",
                        ),
                    ),

                ),
                // :::::-:::::-:-- END - SEARCH BAR :::::-:::::-:--

            ],
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