// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cabinet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cabinet _$CabinetFromJson(Map<String, dynamic> json) => Cabinet(
      game: Game.values.byName(json['game'] as String),
    );

Map<String, dynamic> _$CabinetToJson(Cabinet instance) => <String, dynamic>{
      'game': instance.game,
    };
