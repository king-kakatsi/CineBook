import 'package:first_project/views/home_page/widgets/media_list/media_list_view.dart';
import 'package:first_project/models/media.dart';
import 'package:flutter/material.dart';

class AnimePage extends StatelessWidget{

    // %%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%
    final List<Media> animeList = [

        Media(
            uniqueId: 'anime1',
            mediaType: Mediatype.anime,
            title: 'Blade of Destiny',
            description: 'A warrior seeks revenge in a cursed land.',
            imageUrl: 'https://via.placeholder.com/150x200?text=Blade+of+Destiny',
            numberOfSeasons: 1,

            seasons: [
                Season(
                    uniqueId: 'a1s1',
                    index: 1,
                    description: 'His path begins in the village of shadows.',
                    imageUrl: 'https://via.placeholder.com/120x180?text=Blade+S1',
                    numberOfEpisodes: 12,
                ),
            ],
        ),


        Media(
            uniqueId: 'anime2',
            mediaType: Mediatype.anime,
            title: 'Cyber Pulse',
            description: 'Teen hackers fight AI domination in Neo Tokyo.',
            imageUrl: 'https://via.placeholder.com/150x200?text=Cyber+Pulse',
            numberOfSeasons: 2,

            seasons: [
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
            ],
        ),


        Media(
            uniqueId: 'anime3',
            mediaType: Mediatype.anime,
            title: 'Spirit Runner',
            description: 'In a parallel world, spirits compete in deadly races.',
            imageUrl: 'https://via.placeholder.com/150x200?text=Spirit+Runner',
            numberOfSeasons: 1,

            seasons: [
                Season(
                    uniqueId: 'a3s1',
                    index: 1,
                    description: 'The spirit trials begin.',
                    imageUrl: 'https://via.placeholder.com/120x180?text=Spirit+S1',
                    numberOfEpisodes: 13,
                ),
            ],
        ),


        Media(
            uniqueId: 'anime4',
            mediaType: Mediatype.anime,
            title: 'Echo Samurai',
            description: 'A silent warrior travels through time to fix history.',
            imageUrl: 'https://via.placeholder.com/150x200?text=Echo+Samurai',
            numberOfSeasons: 1,

            seasons: [
                Season(
                    uniqueId: 'a4s1',
                    index: 1,
                    description: 'The first time jump goes wrong.',
                    imageUrl: 'https://via.placeholder.com/120x180?text=Echo+S1',
                    numberOfEpisodes: 11,
                ),
            ],
        ),
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
            mediaList: animeList,
        );
    }
    // %%%%%%%%%%%%%%%%%%%%%% END - BUILD %%%%%%%%%%%%%%%%%%%


    
}