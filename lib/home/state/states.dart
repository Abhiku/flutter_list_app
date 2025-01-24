import 'package:navatech_assignment/data/entity/album.dart';
import 'package:navatech_assignment/data/entity/photo.dart';

abstract class HomeEvent {}

class LoadAlbums extends HomeEvent {}

class LoadPhotosForAlbum extends HomeEvent {
  final int albumId;
  LoadPhotosForAlbum(this.albumId);
}

class RefreshAlbums extends HomeEvent {}

// States
class PhotoState {
  final List<PhotoEntity> photos;
  final bool isLoading;
  final String? error;

  const PhotoState({
    this.photos = const [],
    this.isLoading = false,
    this.error,
  });

  PhotoState copyWith({
    List<PhotoEntity>? photos,
    bool? isLoading,
    String? error,
  }) {
    return PhotoState(
      photos: photos ?? this.photos,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class HomeState {
  final bool isLoading;
  final List<AlbumEntity> albums;
  final Map<int, PhotoState> photoStates;
  final String? error;

  const HomeState({
    this.isLoading = false,
    this.albums = const [],
    this.photoStates = const {},
    this.error,
  });

  HomeState copyWith({
    bool? isLoading,
    List<AlbumEntity>? albums,
    Map<int, PhotoState>? photoStates,
    String? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      albums: albums ?? this.albums,
      photoStates: photoStates ?? this.photoStates,
      error: error,
    );
  }
}
