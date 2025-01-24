import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:navatech_assignment/core/state/network_result_state.dart';
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

// Add this before HomeState class
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

// States
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
      final albumState = await _repository.getAlbums();

      if (albumState.isSuccess()) {
        var albums = albumState.data;

        emit(state.copyWith(
          isLoading: false,
          albums: albums,
        ));

        // Load photos for initial visible albums
        for (var i = 0; i < initialPhotosToLoad && i < albums.length; i++) {
          add(LoadPhotosForAlbum(albums[i].id));
        }
      } else {
        emit(state.copyWith(isLoading: false, error: albumState.error));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadPhotosForAlbum(
      LoadPhotosForAlbum event, Emitter<HomeState> emit) async {
    // Skip if already loading
    if (state.photoStates[event.albumId]?.isLoading == true) {
      return;
    }

    // Set loading state for this album
    emit(state.copyWith(
      photoStates: Map.from(state.photoStates)
        ..[event.albumId] = PhotoState(isLoading: true),
    ));

    try {
      final photoState = await _repository.getPhotosByAlbumId(event.albumId);
      if (photoState.isSuccess()) {
        emit(state.copyWith(
          photoStates: Map.from(state.photoStates)
            ..[event.albumId] = PhotoState(photos: photoState.data),
        ));
      } else {
        emit(state.copyWith(
          photoStates: Map.from(state.photoStates)
            ..[event.albumId] = PhotoState(error: photoState.error),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        photoStates: Map.from(state.photoStates)
          ..[event.albumId] = PhotoState(error: e.toString()),
      ));
    }
  }

  Future<void> _onRefreshAlbums(
      RefreshAlbums event, Emitter<HomeState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      await _repository.clearLocalData();
      await _onLoadAlbums(LoadAlbums(), emit);
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
