import 'package:first_project/shared_ui/media_list_widget.dart';
import 'package:first_project/models/media.dart';
import 'package:flutter/material.dart';


// @@@@@@@@@@@@@@@@@@@@@@@ STATEFULL @@@@@@@@@@@@@@@@@@@@@@@@@@@@

// ignore: must_be_immutable
class SeriesPage extends StatelessWidget{

    // %%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%
    List<Media> seriesList = [
        
        Media(
            mediaType: Mediatype.series,
            title: 'Quantum Agents',
        )
        ..uniqueId = 'series1'
        ..description = 'Secret agents manipulate time to stop global threats.'
        ..imageUrl = 'https://media.ouest-france.fr/v1/pictures/7f97ffa0e5254ecabb2eecc70cc5ed5c-code-quantum-2022-serie-de-science-fiction-programme-tv?width=1260&height=708&sign=37243c95fb233d75c0852c505e66548c823d8d2f0f095c28332bc98687ffde5c&client_id=bpservices'
        ..rate = 4.5
        ..numberOfSeasons = 2

        ..seasons = [
            Season(
                uniqueId: 's1s1',
                index: 1,
                description: 'Origins of the Quantum Division.',
                imageUrl: 'https://via.placeholder.com/120x180?text=QA+S1',
                numberOfEpisodes: 9,
            ),

            Season(
                uniqueId: 's1s2',
                index: 2,
                description: 'Time war against the Syndicate.',
                imageUrl: 'https://via.placeholder.com/120x180?text=QA+S2',
                numberOfEpisodes: 10,
            ),
        ]
        
        ..creationDate = DateTime.now()
        ..lastModificationDate = DateTime.now(),


        Media(
            mediaType: Mediatype.series,
            title: 'Underground Justice',
        )
        ..uniqueId = 'series2'
        ..description = 'A vigilante lawyer serves justice in the shadows.'
        ..imageUrl = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR59QRJAoqspF9LzyNDTNeLzMp6FRjObMIdSQ&s'
        ..rate = 4.3
        ..numberOfSeasons = 1

        ..seasons = [
            Season(
                uniqueId: 's2s1',
                index: 1,
                description: 'The double life begins.',
                imageUrl: 'https://via.placeholder.com/120x180?text=UJ+S1',
                numberOfEpisodes: 8,
            ),
        ]
        
        ..creationDate = DateTime.now()
        ..lastModificationDate = DateTime.now(),


        Media(
            mediaType: Mediatype.series,
            title: 'Fractured Earth',
        )
        ..uniqueId = 'series3'
        ..description = 'Post-apocalyptic survivors uncover a hidden truth.'
        ..imageUrl = 'https://via.placeholder.com/150x200?text=Fractured+Earth'
        ..rate = 4.7
        ..numberOfSeasons = 3

        ..seasons = [
            Season(
                uniqueId: 's3s1',
                index: 1,
                description: 'Living underground.',
                imageUrl: 'https://via.placeholder.com/120x180?text=FE+S1',
                numberOfEpisodes: 6,
            ),

            Season(
                uniqueId: 's3s2',
                index: 2,
                description: 'First contact with the surface.',
                imageUrl: 'https://via.placeholder.com/120x180?text=FE+S2',
                numberOfEpisodes: 7,
            ),

            Season(
                uniqueId: 's3s3',
                index: 3,
                description: 'The forgotten cities.',
                imageUrl: 'https://via.placeholder.com/120x180?text=FE+S3',
                numberOfEpisodes: 9,
            ),
        ]
        
        ..creationDate = DateTime.now()
        ..lastModificationDate = DateTime.now(),


        Media(
            mediaType: Mediatype.series,
            title: 'Mirage Protocol',
        )
        ..uniqueId = 'series4'
        ..description = 'A spy thriller with illusion-based tech warfare.'
        ..imageUrl = 'https://via.placeholder.com/150x200?text=Mirage+Protocol'
        ..rate = 4.2
        ..numberOfSeasons = 1

        ..seasons = [
            Season(
                uniqueId: 's4s1',
                index: 1,
                description: 'Chasing shadows in Eastern Europe.',
                imageUrl: 'https://via.placeholder.com/120x180?text=MP+S1',
                numberOfEpisodes: 10,
            ),
        ]
        
        ..creationDate = DateTime.now()
        ..lastModificationDate = DateTime.now(),
    ];


    // %%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%%
    SeriesPage({super.key});
    // %%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%%



    
    // %%%%%%%%%%%%%%%% BUILD %%%%%%%%%%%%%%%%%
    @override
    Widget build(BuildContext context) {

        return MediaListWidget(
            context: context,
            mediaType: Mediatype.series, 
            pageTitle: "Series",
            hiveBoxName: Mediatype.series.name,
        );
    }
    // %%%%%%%%%%%%%%%% END - BUILD %%%%%%%%%%%%%%%%%
}

// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ END - STATE @@@@@@@@@@@@@@@@@@@@@@@@@@@@@