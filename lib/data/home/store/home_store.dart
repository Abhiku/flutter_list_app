import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:navatech_assignment/data/entity/album.dart';
import 'package:navatech_assignment/data/entity/photo.dart';
import 'package:navatech_assignment/data/repository/repository.dart';

// Events
abstract class HomeEvent {}

class LoadAlbums extends HomeEvent {}

class LoadPhotosForAlbum extends HomeEvent {
  final int albumId;
  LoadPhotosForAlbum(this.albumId);
}

class RefreshAlbums extends HomeEvent {}

// States
class HomeState {
  final bool isLoading;
  final List<AlbumEntity> albums;
  final Map<int, List<PhotoEntity>> photosByAlbum;
  final Map<int, bool> loadingPhotos;
  final String? error;

  const HomeState({
    this.isLoading = false,
    this.albums = const [],
    this.photosByAlbum = const {},
    this.loadingPhotos = const {},
    this.error,
  });

  HomeState copyWith({
    bool? isLoading,
    List<AlbumEntity>? albums,
    Map<int, List<PhotoEntity>>? photosByAlbum,
    Map<int, bool>? loadingPhotos,
    String? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      albums: albums ?? this.albums,
      photosByAlbum: photosByAlbum ?? this.photosByAlbum,
      loadingPhotos: loadingPhotos ?? this.loadingPhotos,
      error: error,
    );
  }
}

// BLoC
@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IRepository _repository;
  static const initialPhotosToLoad =
      5; // Number of albums to load photos for initially

  HomeBloc(this._repository) : super(const HomeState()) {
    on<LoadAlbums>(_onLoadAlbums);
    on<LoadPhotosForAlbum>(_onLoadPhotosForAlbum);
    on<RefreshAlbums>(_onRefreshAlbums);
  }

  Future<void> _onLoadAlbums(LoadAlbums event, Emitter<HomeState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final albums = await _repository.getAlbums();
      emit(state.copyWith(
        isLoading: false,
        albums: albums,
      ));

      // Load photos for initial visible albums
      for (var i = 0; i < initialPhotosToLoad && i < albums.length; i++) {
        add(LoadPhotosForAlbum(albums[i].id));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadPhotosForAlbum(
      LoadPhotosForAlbum event, Emitter<HomeState> emit) async {
    try {
      // Skip if already loading or loaded
      if (state.loadingPhotos[event.albumId] == true ||
          state.photosByAlbum.containsKey(event.albumId)) {
        return;
      }

      // Set loading state for this album
      emit(state.copyWith(
        loadingPhotos: Map.from(state.loadingPhotos)..[event.albumId] = true,
      ));

      final photos = await _repository.getPhotosByAlbumId(event.albumId);

      emit(state.copyWith(
        photosByAlbum: Map.from(state.photosByAlbum)..[event.albumId] = photos,
        loadingPhotos: Map.from(state.loadingPhotos)..remove(event.albumId),
      ));
    } catch (e) {
      emit(state.copyWith(
        loadingPhotos: Map.from(state.loadingPhotos)..remove(event.albumId),
      ));
    }
  }

  Future<void> _onRefreshAlbums(
      RefreshAlbums event, Emitter<HomeState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      await _repository.clearLocalData();
      final albums = await _repository.getAlbums();
      emit(state.copyWith(
        isLoading: false,
        albums: albums,
        photosByAlbum: {},
        loadingPhotos: {},
      ));

      // Load photos for initial visible albums
      for (var i = 0; i < initialPhotosToLoad && i < albums.length; i++) {
        add(LoadPhotosForAlbum(albums[i].id));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
