import 'package:json_annotation/json_annotation.dart';
import 'package:otoge_mobile_app/model/cabinet.dart';
import 'package:otoge_mobile_app/model/game.dart';

part 'store.g.dart';

@JsonSerializable()
class Store {
  Store({
    required this.country,
    required this.area,
    required this.storeName,
    required this.address,
    required this.lat,
    required this.lng,
    required this.cabinets,
    this.context,
    this.alternateArea,
    this.alternateStoreName,
    this.alternateAddress,
  });

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
  Map<String, dynamic> toJson() => _$StoreToJson(this);

  final String country;
  final String area;
  final String storeName;
  final String address;
  final double lat;
  final double lng;
  final List<Cabinet> cabinets;
  final Object? context;
  final String? alternateArea;
  final String? alternateStoreName;
  final String? alternateAddress;
}
