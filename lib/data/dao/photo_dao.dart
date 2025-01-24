import 'package:floor/floor.dart';
import 'package:navatech_assignment/data/entity/photo.dart';

@dao
abstract class PhotoDao {
  @Query('SELECT * FROM photos')
  Future<List<PhotoEntity>> getAllPhotos();

  @Query('SELECT * FROM photos WHERE albumId = :albumId')
  Future<List<PhotoEntity>> getPhotosByAlbumId(int albumId);

  @Query('SELECT * FROM photos WHERE id = :id')
  Future<PhotoEntity?> getPhotoById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPhoto(PhotoEntity photo);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPhotos(List<PhotoEntity> photos);

  @delete
  Future<void> deletePhoto(PhotoEntity photo);

  @Query('DELETE FROM photos WHERE albumId = :albumId')
  Future<void> deletePhotosByAlbumId(int albumId);

  @Query('DELETE FROM photos')
  Future<void> deleteAllPhotos();
}
