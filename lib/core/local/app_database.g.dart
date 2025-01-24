// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  AlbumDao? _albumDaoInstance;

  PhotoDao? _photoDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `albums` (`id` INTEGER NOT NULL, `userId` INTEGER NOT NULL, `title` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `photos` (`id` INTEGER NOT NULL, `albumId` INTEGER NOT NULL, `title` TEXT NOT NULL, `url` TEXT NOT NULL, `thumbnailUrl` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  AlbumDao get albumDao {
    return _albumDaoInstance ??= _$AlbumDao(database, changeListener);
  }

  @override
  PhotoDao get photoDao {
    return _photoDaoInstance ??= _$PhotoDao(database, changeListener);
  }
}

class _$AlbumDao extends AlbumDao {
  _$AlbumDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _albumEntityInsertionAdapter = InsertionAdapter(
            database,
            'albums',
            (AlbumEntity item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'title': item.title
                }),
        _albumEntityDeletionAdapter = DeletionAdapter(
            database,
            'albums',
            ['id'],
            (AlbumEntity item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'title': item.title
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AlbumEntity> _albumEntityInsertionAdapter;

  final DeletionAdapter<AlbumEntity> _albumEntityDeletionAdapter;

  @override
  Future<List<AlbumEntity>> getAllAlbums() async {
    return _queryAdapter.queryList('SELECT * FROM albums',
        mapper: (Map<String, Object?> row) => AlbumEntity(
            id: row['id'] as int,
            userId: row['userId'] as int,
            title: row['title'] as String));
  }

  @override
  Future<AlbumEntity?> getAlbumById(int id) async {
    return _queryAdapter.query('SELECT * FROM albums WHERE id = ?1',
        mapper: (Map<String, Object?> row) => AlbumEntity(
            id: row['id'] as int,
            userId: row['userId'] as int,
            title: row['title'] as String),
        arguments: [id]);
  }

  @override
  Future<void> deleteAllAlbums() async {
    await _queryAdapter.queryNoReturn('DELETE FROM albums');
  }

  @override
  Future<void> insertAlbum(AlbumEntity album) async {
    await _albumEntityInsertionAdapter.insert(
        album, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAlbums(List<AlbumEntity> albums) async {
    await _albumEntityInsertionAdapter.insertList(
        albums, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteAlbum(AlbumEntity album) async {
    await _albumEntityDeletionAdapter.delete(album);
  }
}

class _$PhotoDao extends PhotoDao {
  _$PhotoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _photoEntityInsertionAdapter = InsertionAdapter(
            database,
            'photos',
            (PhotoEntity item) => <String, Object?>{
                  'id': item.id,
                  'albumId': item.albumId,
                  'title': item.title,
                  'url': item.url,
                  'thumbnailUrl': item.thumbnailUrl
                }),
        _photoEntityDeletionAdapter = DeletionAdapter(
            database,
            'photos',
            ['id'],
            (PhotoEntity item) => <String, Object?>{
                  'id': item.id,
                  'albumId': item.albumId,
                  'title': item.title,
                  'url': item.url,
                  'thumbnailUrl': item.thumbnailUrl
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PhotoEntity> _photoEntityInsertionAdapter;

  final DeletionAdapter<PhotoEntity> _photoEntityDeletionAdapter;

  @override
  Future<List<PhotoEntity>> getAllPhotos() async {
    return _queryAdapter.queryList('SELECT * FROM photos',
        mapper: (Map<String, Object?> row) => PhotoEntity(
            id: row['id'] as int,
            albumId: row['albumId'] as int,
            title: row['title'] as String,
            url: row['url'] as String,
            thumbnailUrl: row['thumbnailUrl'] as String));
  }

  @override
  Future<List<PhotoEntity>> getPhotosByAlbumId(int albumId) async {
    return _queryAdapter.queryList('SELECT * FROM photos WHERE albumId = ?1',
        mapper: (Map<String, Object?> row) => PhotoEntity(
            id: row['id'] as int,
            albumId: row['albumId'] as int,
            title: row['title'] as String,
            url: row['url'] as String,
            thumbnailUrl: row['thumbnailUrl'] as String),
        arguments: [albumId]);
  }

  @override
  Future<PhotoEntity?> getPhotoById(int id) async {
    return _queryAdapter.query('SELECT * FROM photos WHERE id = ?1',
        mapper: (Map<String, Object?> row) => PhotoEntity(
            id: row['id'] as int,
            albumId: row['albumId'] as int,
            title: row['title'] as String,
            url: row['url'] as String,
            thumbnailUrl: row['thumbnailUrl'] as String),
        arguments: [id]);
  }

  @override
  Future<void> deletePhotosByAlbumId(int albumId) async {
    await _queryAdapter.queryNoReturn('DELETE FROM photos WHERE albumId = ?1',
        arguments: [albumId]);
  }

  @override
  Future<void> deleteAllPhotos() async {
    await _queryAdapter.queryNoReturn('DELETE FROM photos');
  }

  @override
  Future<void> insertPhoto(PhotoEntity photo) async {
    await _photoEntityInsertionAdapter.insert(
        photo, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertPhotos(List<PhotoEntity> photos) async {
    await _photoEntityInsertionAdapter.insertList(
        photos, OnConflictStrategy.replace);
  }

  @override
  Future<void> deletePhoto(PhotoEntity photo) async {
    await _photoEntityDeletionAdapter.delete(photo);
  }
}
