// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SeasonAdapter extends TypeAdapter<Season> {
  @override
  final int typeId = 3;

  @override
  Season read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Season(
      uniqueId: fields[0] as String,
      index: fields[1] as int,
      description: fields[2] as String,
      imageUrl: fields[3] as String,
      numberOfEpisodes: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Season obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.uniqueId)
      ..writeByte(1)
      ..write(obj.index)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.numberOfEpisodes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SeasonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MediaAdapter extends TypeAdapter<Media> {
  @override
  final int typeId = 4;

  @override
  Media read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Media(
      mediaType: fields[1] as Mediatype,
      title: fields[4] as String,
    )
      ..uniqueId = fields[0] as String
      ..mediaGenre = fields[2] as MediaGenre?
      ..watchStatus = fields[3] as WatchStatus?
      ..description = fields[5] as String
      ..imageUrl = fields[6] as String
      ..imagePath = fields[7] as String
      ..rate = fields[8] as double?
      ..numberOfSeasons = fields[9] as int?
      ..seasons = (fields[10] as List?)?.cast<Season>()
      ..searchFinder = fields[11] as String
      ..creationDate = fields[12] as DateTime
      ..lastModificationDate = fields[13] as DateTime
      ..currentSeasonIndex = fields[14] as int?
      ..currentEpisodeIndex = fields[15] as int?;
  }

  @override
  void write(BinaryWriter writer, Media obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.uniqueId)
      ..writeByte(1)
      ..write(obj.mediaType)
      ..writeByte(2)
      ..write(obj.mediaGenre)
      ..writeByte(3)
      ..write(obj.watchStatus)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.imageUrl)
      ..writeByte(7)
      ..write(obj.imagePath)
      ..writeByte(8)
      ..write(obj.rate)
      ..writeByte(9)
      ..write(obj.numberOfSeasons)
      ..writeByte(10)
      ..write(obj.seasons)
      ..writeByte(11)
      ..write(obj.searchFinder)
      ..writeByte(12)
      ..write(obj.creationDate)
      ..writeByte(13)
      ..write(obj.lastModificationDate)
      ..writeByte(14)
      ..write(obj.currentSeasonIndex)
      ..writeByte(15)
      ..write(obj.currentEpisodeIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MediatypeAdapter extends TypeAdapter<Mediatype> {
  @override
  final int typeId = 0;

  @override
  Mediatype read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Mediatype.series;
      case 1:
        return Mediatype.anime;
      default:
        return Mediatype.series;
    }
  }

  @override
  void write(BinaryWriter writer, Mediatype obj) {
    switch (obj) {
      case Mediatype.series:
        writer.writeByte(0);
        break;
      case Mediatype.anime:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediatypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MediaGenreAdapter extends TypeAdapter<MediaGenre> {
  @override
  final int typeId = 1;

  @override
  MediaGenre read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MediaGenre.action;
      case 1:
        return MediaGenre.comedy;
      case 2:
        return MediaGenre.drama;
      case 3:
        return MediaGenre.romance;
      case 4:
        return MediaGenre.fantasy;
      case 5:
        return MediaGenre.adventure;
      case 6:
        return MediaGenre.thriller;
      case 7:
        return MediaGenre.horror;
      case 8:
        return MediaGenre.psychological;
      case 9:
        return MediaGenre.crime;
      case 10:
        return MediaGenre.finance;
      case 11:
        return MediaGenre.shonen;
      case 12:
        return MediaGenre.isekai;
      case 13:
        return MediaGenre.seinen;
      case 14:
        return MediaGenre.sports;
      case 15:
        return MediaGenre.musical;
      case 16:
        return MediaGenre.mecha;
      case 17:
        return MediaGenre.shojo;
      default:
        return MediaGenre.action;
    }
  }

  @override
  void write(BinaryWriter writer, MediaGenre obj) {
    switch (obj) {
      case MediaGenre.action:
        writer.writeByte(0);
        break;
      case MediaGenre.comedy:
        writer.writeByte(1);
        break;
      case MediaGenre.drama:
        writer.writeByte(2);
        break;
      case MediaGenre.romance:
        writer.writeByte(3);
        break;
      case MediaGenre.fantasy:
        writer.writeByte(4);
        break;
      case MediaGenre.adventure:
        writer.writeByte(5);
        break;
      case MediaGenre.thriller:
        writer.writeByte(6);
        break;
      case MediaGenre.horror:
        writer.writeByte(7);
        break;
      case MediaGenre.psychological:
        writer.writeByte(8);
        break;
      case MediaGenre.crime:
        writer.writeByte(9);
        break;
      case MediaGenre.finance:
        writer.writeByte(10);
        break;
      case MediaGenre.shonen:
        writer.writeByte(11);
        break;
      case MediaGenre.isekai:
        writer.writeByte(12);
        break;
      case MediaGenre.seinen:
        writer.writeByte(13);
        break;
      case MediaGenre.sports:
        writer.writeByte(14);
        break;
      case MediaGenre.musical:
        writer.writeByte(15);
        break;
      case MediaGenre.mecha:
        writer.writeByte(16);
        break;
      case MediaGenre.shojo:
        writer.writeByte(17);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaGenreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WatchStatusAdapter extends TypeAdapter<WatchStatus> {
  @override
  final int typeId = 2;

  @override
  WatchStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WatchStatus.watching;
      case 1:
        return WatchStatus.completed;
      case 2:
        return WatchStatus.onHold;
      case 3:
        return WatchStatus.dropped;
      case 4:
        return WatchStatus.planned;
      default:
        return WatchStatus.watching;
    }
  }

  @override
  void write(BinaryWriter writer, WatchStatus obj) {
    switch (obj) {
      case WatchStatus.watching:
        writer.writeByte(0);
        break;
      case WatchStatus.completed:
        writer.writeByte(1);
        break;
      case WatchStatus.onHold:
        writer.writeByte(2);
        break;
      case WatchStatus.dropped:
        writer.writeByte(3);
        break;
      case WatchStatus.planned:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Season _$SeasonFromJson(Map<String, dynamic> json) => Season(
      uniqueId: json['uniqueId'] as String,
      index: (json['index'] as num).toInt(),
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      numberOfEpisodes: (json['numberOfEpisodes'] as num).toInt(),
    );

Map<String, dynamic> _$SeasonToJson(Season instance) => <String, dynamic>{
      'uniqueId': instance.uniqueId,
      'index': instance.index,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'numberOfEpisodes': instance.numberOfEpisodes,
    };

Media _$MediaFromJson(Map<String, dynamic> json) => Media(
      mediaType: $enumDecode(_$MediatypeEnumMap, json['mediaType']),
      title: json['title'] as String,
    )
      ..uniqueId = json['uniqueId'] as String
      ..mediaGenre =
          $enumDecodeNullable(_$MediaGenreEnumMap, json['mediaGenre'])
      ..watchStatus =
          $enumDecodeNullable(_$WatchStatusEnumMap, json['watchStatus'])
      ..description = json['description'] as String
      ..imageUrl = json['imageUrl'] as String
      ..imagePath = json['imagePath'] as String
      ..rate = (json['rate'] as num?)?.toDouble()
      ..numberOfSeasons = (json['numberOfSeasons'] as num?)?.toInt()
      ..seasons = (json['seasons'] as List<dynamic>?)
          ?.map((e) => Season.fromJson(e as Map<String, dynamic>))
          .toList()
      ..searchFinder = json['searchFinder'] as String
      ..creationDate = DateTime.parse(json['creationDate'] as String)
      ..lastModificationDate =
          DateTime.parse(json['lastModificationDate'] as String)
      ..currentSeasonIndex = (json['currentSeasonIndex'] as num?)?.toInt()
      ..currentEpisodeIndex = (json['currentEpisodeIndex'] as num?)?.toInt();

Map<String, dynamic> _$MediaToJson(Media instance) => <String, dynamic>{
      'uniqueId': instance.uniqueId,
      'mediaType': _$MediatypeEnumMap[instance.mediaType]!,
      'mediaGenre': _$MediaGenreEnumMap[instance.mediaGenre],
      'watchStatus': _$WatchStatusEnumMap[instance.watchStatus],
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'imagePath': instance.imagePath,
      'rate': instance.rate,
      'numberOfSeasons': instance.numberOfSeasons,
      'seasons': instance.seasons?.map((e) => e.toJson()).toList(),
      'searchFinder': instance.searchFinder,
      'creationDate': instance.creationDate.toIso8601String(),
      'lastModificationDate': instance.lastModificationDate.toIso8601String(),
      'currentSeasonIndex': instance.currentSeasonIndex,
      'currentEpisodeIndex': instance.currentEpisodeIndex,
    };

const _$MediatypeEnumMap = {
  Mediatype.series: 'series',
  Mediatype.anime: 'anime',
};

const _$MediaGenreEnumMap = {
  MediaGenre.action: 'action',
  MediaGenre.comedy: 'comedy',
  MediaGenre.drama: 'drama',
  MediaGenre.romance: 'romance',
  MediaGenre.fantasy: 'fantasy',
  MediaGenre.adventure: 'adventure',
  MediaGenre.thriller: 'thriller',
  MediaGenre.horror: 'horror',
  MediaGenre.psychological: 'psychological',
  MediaGenre.crime: 'crime',
  MediaGenre.finance: 'finance',
  MediaGenre.shonen: 'shonen',
  MediaGenre.isekai: 'isekai',
  MediaGenre.seinen: 'seinen',
  MediaGenre.sports: 'sports',
  MediaGenre.musical: 'musical',
  MediaGenre.mecha: 'mecha',
  MediaGenre.shojo: 'shojo',
};

const _$WatchStatusEnumMap = {
  WatchStatus.watching: 'watching',
  WatchStatus.completed: 'completed',
  WatchStatus.onHold: 'onHold',
  WatchStatus.dropped: 'dropped',
  WatchStatus.planned: 'planned',
};
