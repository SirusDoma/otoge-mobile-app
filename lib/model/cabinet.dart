import 'package:json_annotation/json_annotation.dart';
import 'package:otoge_mobile_app/model/game.dart';

part 'cabinet.g.dart';

@JsonSerializable()
class Cabinet {
  Cabinet({required this.game});

  factory Cabinet.fromJson(Map<String, dynamic> json) => _$CabinetFromJson(json);
  Map<String, dynamic> toJson() => _$CabinetToJson(this);

  final Game game;
}