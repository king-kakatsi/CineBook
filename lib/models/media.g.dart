// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SeasonAdapter extends TypeAdapter<Season> {
  @override
  final int typeId = 2;

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
  final int typeId = 3;

  @override
  Media read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Media(
      mediaType: fields[1] as Mediatype,
      title: fields[2] as String,
    )
      ..uniqueId = fields[0] as String
      ..description = fields[3] as String
      ..imageUrl = fields[4] as String
      ..imagePath = fields[5] as String
      ..rate = fields[6] as double?
      ..numberOfSeasons = fields[7] as int?
      ..seasons = (fields[8] as List?)?.cast<Season>()
      ..searchFinder = fields[9] as String
      ..creationDate = fields[10] as DateTime
      ..lastModificationDate = fields[11] as DateTime
      ..currentSeasonIndex = fields[12] as int?
      ..currentEpisodeIndex = fields[13] as int?;
  }

  @override
  void write(BinaryWriter writer, Media obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.uniqueId)
      ..writeByte(1)
      ..write(obj.mediaType)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.imagePath)
      ..writeByte(6)
      ..write(obj.rate)
      ..writeByte(7)
      ..write(obj.numberOfSeasons)
      ..writeByte(8)
      ..write(obj.seasons)
      ..writeByte(9)
      ..write(obj.searchFinder)
      ..writeByte(10)
      ..write(obj.creationDate)
      ..writeByte(11)
      ..write(obj.lastModificationDate)
      ..writeByte(12)
      ..write(obj.currentSeasonIndex)
      ..writeByte(13)
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
