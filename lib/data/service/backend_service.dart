import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:navatech_assignment/core/network/api_client.dart';
import 'package:navatech_assignment/data/entity/album.dart';
import 'package:navatech_assignment/data/entity/photo.dart';

abstract class IBackendService {
  Future<List<AlbumEntity>> getAlbums();
  Future<List<PhotoEntity>> getPhotosByAlbumId(int albumId);
}

@Injectable(as: IBackendService)
class BackendService implements IBackendService {
  final ApiClient _apiClient;

  BackendService(this._apiClient);

  @override
  Future<List<AlbumEntity>> getAlbums() async {
    try {
      final response = await _apiClient.get('/albums');
      final List<dynamic> data = response.data;
      return data.map((json) => AlbumEntity.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PhotoEntity>> getPhotosByAlbumId(int albumId) async {
    try {
      final response = await _apiClient.get(
        '/photos',
        queryParameters: {'albumId': albumId},
      );
      final List<dynamic> data = response.data;
      return data.map((json) => PhotoEntity.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
