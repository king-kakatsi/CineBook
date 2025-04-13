import 'package:first_project/views/home_page/widgets/media_list/media_list_view.dart';
import 'package:first_project/models/media.dart';
import 'package:flutter/material.dart';

class SeriesPage extends StatelessWidget{

    // %%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%
    
    // %%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%%
    SeriesPage({super.key});
    // %%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%%%
    @override
    Widget build(BuildContext context) {
        
        return MediaListPage(mediaType: Mediatype.series, pageTitle: "Series");
    }
    // %%%%%%%%%%%%%%%%%%%%%% END - BUILD %%%%%%%%%%%%%%%%%%%


    
}