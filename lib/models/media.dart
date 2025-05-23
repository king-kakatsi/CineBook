import 'dart:convert';


import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
part 'media.g.dart';


// @@@@@@@@@@@@@@@ ENUMS @@@@@@@@@@@@@@@@@

// %%%%%%%%%%%%%% MEDIA TYPE %%%%%%%%%%%%%%%%
@HiveType(typeId: 0)
@JsonEnum(alwaysCreate: true)
enum Mediatype {
  @HiveField(0)
  @JsonValue('series')
  series,

  @HiveField(1)
  @JsonValue('anime')
  anime,
}
// %%%%%%%%%%%%%% END - MEDIA TYPE %%%%%%%%%%%%%%%%




// %%%%%%%%%%%%%%%%% MEDIA GENRE %%%%%%%%%%%%%%%
@HiveType(typeId: 1)
@JsonEnum(alwaysCreate: true)
enum MediaGenre {
    @HiveField(0)
    @JsonValue('action')
    action,

    @HiveField(1)
    @JsonValue('comedy')
    comedy,

    @HiveField(2)
    @JsonValue('drama')
    drama,

    @HiveField(3)
    @JsonValue('romance')
    romance,

    @HiveField(4)
    @JsonValue('fantasy')
    fantasy,

    @HiveField(5)
    @JsonValue('adventure')
    adventure,

    @HiveField(6)
    @JsonValue('thriller')
    thriller,

    @HiveField(7)
    @JsonValue('horror')
    horror,

    @HiveField(8)
    @JsonValue('psychological')
    psychological,

    @HiveField(9)
    @JsonValue('crime')
    crime,

    @HiveField(10)
    @JsonValue('finance')
    finance,

    @HiveField(11)
    @JsonValue('shonen')
    shonen,

    @HiveField(12)
    @JsonValue('isekai')
    isekai,

    @HiveField(13)
    @JsonValue('seinen')
    seinen,

    @HiveField(14)
    @JsonValue('sports')
    sports,

    @HiveField(15)
    @JsonValue('musical')
    musical,

    @HiveField(16)
    @JsonValue('mecha')
    mecha,

    @HiveField(17)
    @JsonValue('shojo')
    shojo,
}

// %%%%%%%%%%%%%%%%% END - MEDIA GENRE %%%%%%%%%%%%%%%




// %%%%%%%%%%%%%%% WATCH STATUS %%%%%%%%%%%%%%%%%%
@HiveType(typeId: 2)
@JsonEnum(alwaysCreate: true)
enum WatchStatus {
    @HiveField(0)
    @JsonValue('watching')
    watching,

    @HiveField(1)
    @JsonValue('completed')
    completed,

    @HiveField(2)
    @JsonValue('onHold')
    onHold,

    @HiveField(3)
    @JsonValue('dropped')
    dropped,

    @HiveField(4)
    @JsonValue('planned')
    planned,
}

// %%%%%%%%%%%%%%% END - WATCH STATUS %%%%%%%%%%%%%%%%%%

// @@@@@@@@@@@@@@@ END - ENUMS @@@@@@@@@@@@@@@@@





// @@@@@@@@@@@@@@@@@@ SEASON CLASS @@@@@@@@@@@@@@@@@@@@@
@HiveType(typeId: 3)
@JsonSerializable()
class Season {
    // %%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%
    @HiveField(0)
    final String uniqueId;

    @HiveField(1)
    final int index;

    @HiveField(2)
    final String description;

    @HiveField(3)
    final String imageUrl;

    @HiveField(4)
    final int numberOfEpisodes;

    // %%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%
    Season ({
        required this.uniqueId, 
        required this.index, 
        required this.description, 
        required this.imageUrl, 
        required this.numberOfEpisodes 
    });
    // %%%%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%




    factory Season.fromJson(Map<String, dynamic> json) => _$SeasonFromJson(json);
    Map<String, dynamic> toJson() => _$SeasonToJson(this);
}
// @@@@@@@@@@@@@@@@@@ END - SEASON CLASS @@@@@@@@@@@@@@@@@@@@@





// @@@@@@@@@@@@@@@@@@ MEDIA CLASS @@@@@@@@@@@@@@@@@@@@@

@HiveType(typeId: 4)
@JsonSerializable(explicitToJson: true)
class Media {

    // %%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%
    @HiveField(0)
    late String uniqueId;

    @HiveField(1)
    late Mediatype mediaType;

    @HiveField(2)
    late MediaGenre? mediaGenre;

    @HiveField(3)
    late WatchStatus? watchStatus;

    @HiveField(4)
    late String title;

    @HiveField(5)
    late String description;

    @HiveField(6)
    late String imageUrl;

    @HiveField(7)
    late String imagePath;

    @HiveField(8)
    late double? rate;

    @HiveField(9)
    late int? numberOfSeasons;

    @HiveField(10)
    late List<Season>? seasons;

    @HiveField(11)
    late String searchFinder;

    @HiveField(12)
    late DateTime creationDate;

    @HiveField(13)
    late DateTime lastModificationDate;

    @HiveField(14)
    late int? currentSeasonIndex;

    @HiveField(15)
    late int? currentEpisodeIndex;


    // %%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%
    Media ({
        required this.mediaType, 
        required this.title,
    }) {

        numberOfSeasons = 0;
        seasons = [];
    }
    // %%%%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%




    // %%%%%%%%%%%%%%%%% GENERATE SEARCH PROVIDER %%%%%%%%%%%%%%%%%%%
    void generateSearchFinder () {
        searchFinder = "";
        try{
            searchFinder += uniqueId;
            searchFinder += title;
            searchFinder += description;
            searchFinder += "$numberOfSeasons";
            searchFinder += "$mediaType";
            searchFinder += "$creationDate";
            searchFinder += "$lastModificationDate";
            searchFinder += "$rate";
        }
        // ignore: empty_catches
        catch (e) {}    
    }
    // %%%%%%%%%%%%%%%%% END - GENERATE SEARCH PROVIDER %%%%%%%%%%%%%%%%%%%




    factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);
    Map<String, dynamic> toJson() => _$MediaToJson(this);

    factory Media.fromString(String jsonStr) => Media.fromJson(jsonDecode(jsonStr));
    String toJsonString() => jsonEncode(toJson());

}
// @@@@@@@@@@@@@@@@@@ END - MEDIA CLASS @@@@@@@@@@@@@@@@@@@@@
