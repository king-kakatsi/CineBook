import 'package:first_project/shared_ui/media_list_widget.dart';
import 'package:first_project/models/media.dart';
import 'package:flutter/material.dart';


/// **Anime Page Widget for displaying anime catalog**
///
/// A StatelessWidget that represents the anime section of the application.
/// This page is part of a tabbed interface (alongside SeriesPage) that composes the HomePage.
/// It provides a predefined list of sample anime data and displays them using MediaListWidget.
///
/// The widget contains hardcoded sample anime data including:
/// - Blade of Destiny (1 season, 12 episodes)
/// - Cyber Pulse (2 seasons, 10+8 episodes)
/// - Spirit Runner (1 season, 13 episodes)
/// - Echo Samurai (1 season, 11 episodes)
///
/// Each anime includes complete metadata such as title, description, ratings,
/// seasons with episode counts, and placeholder/real image URLs.
// ignore: must_be_immutable
class AnimePage extends StatelessWidget{

    // %%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%%
    const AnimePage({super.key});
    // %%%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%%%
    @override
    Widget build(BuildContext context) {

        return MediaListWidget(
            context: context,
            mediaType: Mediatype.anime, 
            pageTitle: "Animes",
            hiveBoxName: Mediatype.anime.name,
        );
    }
    // %%%%%%%%%%%%%%%%%%%%%% END - BUILD %%%%%%%%%%%%%%%%%%%


    
}