import 'package:injectable/injectable.dart';
import 'package:navatech_assignment/data/dao/album_dao.dart';
import 'package:navatech_assignment/data/dao/photo_dao.dart';
import 'package:navatech_assignment/data/entity/album.dart';
import 'package:navatech_assignment/data/entity/photo.dart';
import 'package:navatech_assignment/data/service/backend_service.dart';

abstract class IRepository {
  Future<List<AlbumEntity>> getAlbums();
  Future<List<PhotoEntity>> getPhotosByAlbumId(int albumId);
  Future<void> clearLocalData();
}

@Injectable(as: IRepository)
class Repository implements IRepository {
  final IBackendService _backendService;
  final AlbumDao _albumDao;
  final PhotoDao _photoDao;

  Repository(this._backendService, this._albumDao, this._photoDao);

  @override
  Future<List<AlbumEntity>> getAlbums() async {
    try {
      // Try to get albums from local database first
      final localAlbums = await _albumDao.getAllAlbums();

      if (localAlbums.isNotEmpty) {
        return localAlbums;
      }

      // If local database is empty, fetch from API
      final remoteAlbums = await _backendService.getAlbums();

      // Save to local database
      await _albumDao.insertAlbums(remoteAlbums);

      return remoteAlbums;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PhotoEntity>> getPhotosByAlbumId(int albumId) async {
    try {
      // Try to get photos from local database first
      final localPhotos = await _photoDao.getPhotosByAlbumId(albumId);

      if (localPhotos.isNotEmpty) {
        return localPhotos;
      }

      // If local database is empty, fetch from API
      final remotePhotos = await _backendService.getPhotosByAlbumId(albumId);

      // Save to local database
      await _photoDao.insertPhotos(remotePhotos);

      return remotePhotos;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> clearLocalData() async {
    try {
      await Future.wait([
        _albumDao.deleteAllAlbums(),
        _photoDao.deleteAllPhotos(),
      ]);
    } catch (e) {
      rethrow;
    }
  }
}
