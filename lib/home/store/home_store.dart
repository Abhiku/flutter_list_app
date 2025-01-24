import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:navatech_assignment/core/state/network_result_state.dart';
import 'package:navatech_assignment/data/entity/album.dart';
import 'package:navatech_assignment/data/entity/photo.dart';
import 'package:navatech_assignment/data/repository/repository.dart';
import 'package:navatech_assignment/home/state/states.dart';

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
