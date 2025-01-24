import 'package:injectable/injectable.dart';
import 'package:navatech_assignment/core/exception/network_exception.dart';
import 'package:navatech_assignment/core/state/network_result_state.dart';
import 'package:navatech_assignment/data/dao/album_dao.dart';
import 'package:navatech_assignment/data/dao/photo_dao.dart';
import 'package:navatech_assignment/data/entity/album.dart';
import 'package:navatech_assignment/data/entity/photo.dart';
import 'package:navatech_assignment/data/service/backend_service.dart';
import 'package:dio/dio.dart';

abstract class IRepository {
  Future<NetworkResultState<List<AlbumEntity>>> getAlbums();
  Future<NetworkResultState<List<PhotoEntity>>> getPhotosByAlbumId(int albumId);
  Future<NetworkResultState<void>> clearLocalData();
}

@Injectable(as: IRepository)
class Repository implements IRepository {
  final IBackendService _backendService;
  final AlbumDao _albumDao;
  final PhotoDao _photoDao;

  Repository(this._backendService, this._albumDao, this._photoDao);

  @override
  Future<NetworkResultState<List<AlbumEntity>>> getAlbums() async {
    try {
      // Try to get albums from local database first
      final localAlbums = await _albumDao.getAllAlbums();

      if (localAlbums.isNotEmpty) {
        return NetworkResultState.success(localAlbums);
      }

      // If local database is empty, fetch from API
      final remoteAlbums = await _backendService.getAlbums();

      // Save to local database
      await _albumDao.insertAlbums(remoteAlbums);

      return NetworkResultState.success(remoteAlbums);
    } on DioException catch (e) {
      final networkException = NetworkException.fromDioError(e);
      return NetworkResultState.error(networkException.message);
    } catch (e) {
      return NetworkResultState.error(e.toString());
    }
  }

  @override
  Future<NetworkResultState<List<PhotoEntity>>> getPhotosByAlbumId(
      int albumId) async {
    try {
      // Try to get photos from local database first
      final localPhotos = await _photoDao.getPhotosByAlbumId(albumId);

      if (localPhotos.isNotEmpty) {
        return NetworkResultState.success(localPhotos);
      }

      // If local database is empty, fetch from API
      final remotePhotos = await _backendService.getPhotosByAlbumId(albumId);

      // Save to local database
      await _photoDao.insertPhotos(remotePhotos);

      return NetworkResultState.success(remotePhotos);
    } on DioException catch (e) {
      final networkException = NetworkException.fromDioError(e);
      return NetworkResultState.error(networkException.message);
    } catch (e) {
      return NetworkResultState.error(e.toString());
    }
  }

  @override
  Future<NetworkResultState<void>> clearLocalData() async {
    try {
      await Future.wait([
        _albumDao.deleteAllAlbums(),
        _photoDao.deleteAllPhotos(),
      ]);
      return const NetworkResultState.success(null);
    } catch (e) {
      return NetworkResultState.error(e.toString());
    }
  }
}
