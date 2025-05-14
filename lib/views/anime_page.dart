import 'package:first_project/core/widgets/media_list/media_list_view.dart';
import 'package:first_project/models/media.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AnimePage extends StatelessWidget{

    // %%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%
    List<Media> animeList = [
        
        Media(
            mediaType: Mediatype.anime,
            title: 'Blade of Destiny',
        )
        ..uniqueId = 'anime1'
        ..description = 'A warrior seeks revenge in a cursed land.'
        ..imageUrl = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2iYUZeztetyKx8K4s8a6oFqRasusPGjbAdw&s'
        ..rate = 4.6
        ..numberOfSeasons = 1
        
        ..seasons = [
            Season(
                uniqueId: 'a1s1',
                index: 1,
                description: 'His path begins in the village of shadows.',
                imageUrl: 'https://static0.gamerantimages.com/wordpress/wp-content/uploads/2024/12/best-school-anime-everyone-should-watch.jpg',
                numberOfEpisodes: 12,
            ),
        ]

        ..creationDate = DateTime.now()
        ..lastModificationDate = DateTime.now(),


        Media(
            mediaType: Mediatype.anime,
            title: 'Cyber Pulse',
        )
        ..uniqueId = 'anime2'
        ..description = 'Teen hackers fight AI domination in Neo Tokyo.'
        ..imageUrl = 'https://via.placeholder.com/150x200?text=Cyber+Pulse'
        ..rate = 4.4
        ..numberOfSeasons = 2

        ..seasons = [
            Season(
                uniqueId: 'a2s1',
                index: 1,
                description: 'The awakening of rogue code.',
                imageUrl: 'https://via.placeholder.com/120x180?text=Cyber+S1',
                numberOfEpisodes: 10,
            ),

            Season(
                uniqueId: 'a2s2',
                index: 2,
                description: 'AI strike back on the web frontier.',
                imageUrl: 'https://via.placeholder.com/120x180?text=Cyber+S2',
                numberOfEpisodes: 8,
            ),
        ]

        ..creationDate = DateTime.now()
        ..lastModificationDate = DateTime.now(),


        Media(
            mediaType: Mediatype.anime,
            title: 'Spirit Runner',
        )
        ..uniqueId = 'anime3'
        ..description = 'In a parallel world, spirits compete in deadly races.'
        ..imageUrl = 'https://via.placeholder.com/150x200?text=Spirit+Runner'
        ..rate = 4.5
        ..numberOfSeasons = 1

        ..seasons = [
            Season(
                uniqueId: 'a3s1',
                index: 1,
                description: 'The spirit trials begin.',
                imageUrl: 'https://via.placeholder.com/120x180?text=Spirit+S1',
                numberOfEpisodes: 13,
            ),
        ]

        ..creationDate = DateTime.now()
        ..lastModificationDate = DateTime.now(),


        Media(
            mediaType: Mediatype.anime,
            title: 'Echo Samurai',
        )
        ..uniqueId = 'anime4'
        ..description = 'A silent warrior travels through time to fix history.'
        ..imageUrl = 'https://via.placeholder.com/150x200?text=Echo+Samurai'
        ..rate = 4.3
        ..numberOfSeasons = 1

        ..seasons = [
            Season(
                uniqueId: 'a4s1',
                index: 1,
                description: 'The first time jump goes wrong.',
                imageUrl: 'https://via.placeholder.com/120x180?text=Echo+S1',
                numberOfEpisodes: 11,
            ),
        ]

        ..creationDate = DateTime.now()
        ..lastModificationDate = DateTime.now(),
    ];


    // %%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%%
    AnimePage({super.key});
    // %%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%%%
    @override
    Widget build(BuildContext context) {

        return MediaListPage(

            mediaType: Mediatype.anime, 
            pageTitle: "Animes",
            hiveBoxName: Mediatype.anime.name,
        );
    }
    // %%%%%%%%%%%%%%%%%%%%%% END - BUILD %%%%%%%%%%%%%%%%%%%


    
}