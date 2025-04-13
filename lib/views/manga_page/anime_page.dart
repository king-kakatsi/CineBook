import 'package:first_project/views/home_page/widgets/media_list/media_list_view.dart';
import 'package:first_project/models/media.dart';
import 'package:flutter/material.dart';

class AnimePage extends StatelessWidget{

    // %%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%
    
    // %%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%%
    AnimePage({super.key});
    // %%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%%%
    @override
    Widget build(BuildContext context) {
        
        return MediaListPage(mediaType: Mediatype.anime, pageTitle: "Animes");
    }
    // %%%%%%%%%%%%%%%%%%%%%% END - BUILD %%%%%%%%%%%%%%%%%%%


    
}