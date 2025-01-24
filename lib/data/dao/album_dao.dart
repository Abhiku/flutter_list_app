import 'package:floor/floor.dart';
import 'package:navatech_assignment/data/entity/album.dart';

@dao
abstract class AlbumDao {
  @Query('SELECT * FROM albums')
  Future<List<AlbumEntity>> getAllAlbums();

  @Query('SELECT * FROM albums WHERE id = :id')
  Future<AlbumEntity?> getAlbumById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAlbum(AlbumEntity album);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAlbums(List<AlbumEntity> albums);

  @delete
  Future<void> deleteAlbum(AlbumEntity album);

  @Query('DELETE FROM albums')
  Future<void> deleteAllAlbums();
}
