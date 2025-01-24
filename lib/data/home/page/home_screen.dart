import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navatech_assignment/data/home/store/home_store.dart';
import 'package:collection/collection.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Albums'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<HomeBloc>().add(RefreshAlbums());
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.isLoading && state.albums.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null && state.albums.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(LoadAlbums());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: state.albums.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final album = state.albums[index];
              final photoState = state.photoStates[album.id] ??
                  const PhotoState(isLoading: true);

              return VisibilityDetector(
                key: Key('album_${album.id}'),
                onVisibilityChanged: (info) {
                  if (info.visibleFraction > 0.5) {
                    context.read<HomeBloc>().add(LoadPhotosForAlbum(album.id));
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        album.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    SizedBox(
                      height: 120,
                      child: Builder(
                        builder: (context) {
                          if (photoState.isLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (photoState.error != null) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    photoState.error!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  IconButton(
                                    icon: const Icon(Icons.refresh),
                                    onPressed: () {
                                      context
                                          .read<HomeBloc>()
                                          .add(LoadPhotosForAlbum(album.id));
                                    },
                                  ),
                                ],
                              ),
                            );
                          }

                          if (photoState.photos.isEmpty) {
                            return const Center(
                                child: Text('No photos available'));
                          }

                          return ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: photoState.photos.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, photoIndex) {
                              final photo = photoState.photos[photoIndex];
                              return AspectRatio(
                                aspectRatio: 1,
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.network(
                                    photo.thumbnailUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(Icons.error_outline),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
