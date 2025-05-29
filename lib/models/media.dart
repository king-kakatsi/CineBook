import 'dart:convert';


import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
part 'media.g.dart';


// @@@@@@@@@@@@@@@ ENUMS @@@@@@@@@@@@@@@@@

// %%%%%%%%%%%%%% MEDIA TYPE %%%%%%%%%%%%%%%%
/// Represents the type of media, either a **series** or an **anime**.
/// Used for both JSON serialization and Hive persistence.
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
/// Represents the genre of a media (e.g. action, romance, isekai...).
/// Useful for filtering or categorization.
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
/// Describes the current watching status of a media.
/// Useful to track user progress (e.g. watching, completed, planned...).
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

/// Represents a single season of a Media entry.
/// Contains description, index, image and episode count.
@HiveType(typeId: 3)
@JsonSerializable()
class Season {

    // %%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%

    /// Unique ID for the season (used by Hive & search).
    @HiveField(0)
    final String uniqueId;

    /// Index of the season (starting from 0 or 1).
    @HiveField(1)
    final int index;

    /// Short summary or description of the season.
    @HiveField(2)
    final String description;

    /// URL of the season's cover image.
    @HiveField(3)
    final String imageUrl;

    /// Number of episodes in this season.
    @HiveField(4)
    final int numberOfEpisodes;

    // %%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%


    // %%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%

    /// Creates a Season instance with required fields.
    Season ({
        required this.uniqueId, 
        required this.index, 
        required this.description, 
        required this.imageUrl, 
        required this.numberOfEpisodes 
    });

    // %%%%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%


    /// Creates a Season from a JSON map.
    factory Season.fromJson(Map<String, dynamic> json) => _$SeasonFromJson(json);

    /// Converts a Season instance to JSON.
    Map<String, dynamic> toJson() => _$SeasonToJson(this);
}
// @@@@@@@@@@@@@@@@@@ END - SEASON CLASS @@@@@@@@@@@@@@@@@@@@@





// @@@@@@@@@@@@@@@@@@ MEDIA CLASS @@@@@@@@@@@@@@@@@@@@@

/// Represents a full Media object (series or anime).
/// Contains main metadata and a list of seasons.
@HiveType(typeId: 4)
@JsonSerializable(explicitToJson: true)
class Media {

    // %%%%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%

    /// Unique ID for the media.
    @HiveField(0)
    late String uniqueId;

    /// Type of media (series or anime).
    @HiveField(1)
    late Mediatype mediaType;

    /// Genre of the media (can be null).
    @HiveField(2)
    late MediaGenre? mediaGenre;

    /// Watch status (can be null).
    @HiveField(3)
    late WatchStatus? watchStatus;

    /// Title of the media.
    @HiveField(4)
    late String title;

    /// Description or synopsis.
    @HiveField(5)
    late String description;

    /// URL of the media's cover image.
    @HiveField(6)
    late String imageUrl;

    /// Local path to the image file.
    @HiveField(7)
    late String imagePath;

    /// Optional rating (from 0 to 10 or similar).
    @HiveField(8)
    late double? rate;

    /// Total number of seasons.
    @HiveField(9)
    late int? numberOfSeasons;

    /// List of seasons attached to the media.
    @HiveField(10)
    late List<Season>? seasons;

    /// Generated field used for text-based search/filtering.
    @HiveField(11)
    late String searchFinder;

    /// Date of creation (used for sorting or sync).
    @HiveField(12)
    late DateTime creationDate;

    /// Date of last modification.
    @HiveField(13)
    late DateTime lastModificationDate;

    /// Current season being watched (if any).
    @HiveField(14)
    late int? currentSeasonIndex;

    /// Current episode being watched (if any).
    @HiveField(15)
    late int? currentEpisodeIndex;

    // %%%%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%


    // %%%%%%%%%%%%%%%%%% CONSTRUCTOR %%%%%%%%%%%%%%%%%

    /// Creates a new Media with required fields and initializes seasons to an empty list.
    Media ({
        required this.mediaType, 
        required this.title,
    }) {
        numberOfSeasons = 0;
        seasons = [];
    }

    // %%%%%%%%%%%%%%%%%% END - CONSTRUCTOR %%%%%%%%%%%%%%%%%


    // %%%%%%%%%%%%%%%%% GENERATE SEARCH PROVIDER %%%%%%%%%%%%%%%%%%%

    /// Generates a searchable string (`searchFinder`) by concatenating multiple fields.
    /// Useful for local search/filtering without database queries.
    void generateSearchFinder () {
        searchFinder = "";
        try {
            searchFinder += uniqueId;
            searchFinder += title;
            searchFinder += description;
            searchFinder += "$numberOfSeasons";
            searchFinder += "$mediaType";
            searchFinder += "$creationDate";
            searchFinder += "$lastModificationDate";
            searchFinder += "$rate";
        }
        // ignore errors silently
        catch (e) {}    
    }

    // %%%%%%%%%%%%%%%%% END - GENERATE SEARCH PROVIDER %%%%%%%%%%%%%%%%%%%


    /// Creates a Media object from JSON.
    factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);

    /// Converts this Media object to JSON.
    Map<String, dynamic> toJson() => _$MediaToJson(this);

    /// Parses a Media object from a raw JSON string.
    factory Media.fromString(String jsonStr) => Media.fromJson(jsonDecode(jsonStr));

    /// Converts this Media object to a JSON string.
    String toJsonString() => jsonEncode(toJson());

}
// @@@@@@@@@@@@@@@@@@ END - MEDIA CLASS @@@@@@@@@@@@@@@@@@@@@
