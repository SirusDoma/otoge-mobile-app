// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Store _$StoreFromJson(Map<String, dynamic> json) => Store(
      country: json['country'] as String,
      area: json['area'] as String,
      storeName: json['storeName'] as String,
      address: json['address'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      cabinets: (json['cabinets'] as List<dynamic>)
          .map((e) => Cabinet.fromJson(e as Map<String, dynamic>))
          .toList(),
      context: json['context'],
      alternateArea: json['alternateArea'] as String?,
      alternateStoreName: json['alternateStoreName'] as String?,
      alternateAddress: json['alternateAddress'] as String?,
    );

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      'country': instance.country,
      'area': instance.area,
      'storeName': instance.storeName,
      'address': instance.address,
      'lat': instance.lat,
      'lng': instance.lng,
      'cabinets': instance.cabinets,
      'context': instance.context,
      'alternateArea': instance.alternateArea,
      'alternateStoreName': instance.alternateStoreName,
      'alternateAddress': instance.alternateAddress,
    };
