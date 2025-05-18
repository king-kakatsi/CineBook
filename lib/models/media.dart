import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
part 'media.g.dart';


// @@@@@@@@@@@@@@@ MEDIA TYPE ENUM @@@@@@@@@@@@@@@@@
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
// @@@@@@@@@@@@@@@ END - MEDIA TYPE ENUM @@@@@@@@@@@@@@@@@





// @@@@@@@@@@@@@@@@@@ SEASON CLASS @@@@@@@@@@@@@@@@@@@@@
@HiveType(typeId: 2)
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

@HiveType(typeId: 3)
@JsonSerializable(explicitToJson: true)
class Media {

    // %%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%
    @HiveField(0)
    late String uniqueId;

    @HiveField(1)
    late Mediatype mediaType;

    @HiveField(2)
    late String title;

    @HiveField(3)
    late String description;

    @HiveField(4)
    late String imageUrl;

    @HiveField(5)
    late String imagePath;

    @HiveField(6)
    late double? rate;

    @HiveField(7)
    late int? numberOfSeasons;

    @HiveField(8)
    late List<Season>? seasons;

    @HiveField(9)
    late String searchFinder;

    @HiveField(10)
    late DateTime creationDate;

    @HiveField(11)
    late DateTime lastModificationDate;

    @HiveField(12)
    late int? currentSeasonIndex;

    @HiveField(13)
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
