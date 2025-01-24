import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'photo.g.dart';

@JsonSerializable()
@Entity(tableName: 'photos')
class PhotoEntity {
  @primaryKey
  final int id;
  final int albumId;
  final String title;
  final String url;
  final String thumbnailUrl;

  PhotoEntity({
    required this.id,
    required this.albumId,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  factory PhotoEntity.fromJson(Map<String, dynamic> json) =>
      _$PhotoEntityFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoEntityToJson(this);

  PhotoEntity copyWith({
    int? id,
    int? albumId,
    String? title,
    String? url,
    String? thumbnailUrl,
  }) {
    return PhotoEntity(
      id: id ?? this.id,
      albumId: albumId ?? this.albumId,
      title: title ?? this.title,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }
}
