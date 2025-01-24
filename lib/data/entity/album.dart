import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'album.g.dart';

@JsonSerializable()
@Entity(tableName: 'albums')
class AlbumEntity {
  @primaryKey
  final int id;
  final int userId;
  final String title;

  AlbumEntity({
    required this.id,
    required this.userId,
    required this.title,
  });

  factory AlbumEntity.fromJson(Map<String, dynamic> json) =>
      _$AlbumEntityFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumEntityToJson(this);

  AlbumEntity copyWith({
    int? id,
    int? userId,
    String? title,
  }) {
    return AlbumEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
    );
  }
}
