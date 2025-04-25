
enum Mediatype {
    series,
    anime
}




// @@@@@@@@@@@@@@@@@@ MEDIA CLASS @@@@@@@@@@@@@@@@@@@@@

class Media {
    // %%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%
    final String uniqueId;
    final Mediatype mediaType;
    final String title;
    final String description;
    final String imageUrl;
    final int numberOfSeasons;
    final List<Season> seasons;

    // %%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%





    // %%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%
    Media ({required this.uniqueId, required this.mediaType, required this.title, required this.description, required this.imageUrl, required this.numberOfSeasons, required this.seasons });
    // %%%%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@@@@@@@ END - MEDIA CLASS @@@@@@@@@@@@@@@@@@@@@








// @@@@@@@@@@@@@@@@@@ SEASON CLASS @@@@@@@@@@@@@@@@@@@@@

class Season {
    // %%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%
    final String uniqueId;
    final int index;
    final String description;
    final String imageUrl;
    final int numberOfEpisodes;

    // %%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%





    // %%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%
    Season ({required this.uniqueId, required this.index, required this.description, required this.imageUrl, required this.numberOfEpisodes });
    // %%%%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%
}
// @@@@@@@@@@@@@@@@@@ END - SEASON CLASS @@@@@@@@@@@@@@@@@@@@@