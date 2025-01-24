import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:navatech_assignment/core/di/injection.config.dart';
import 'package:navatech_assignment/core/local/app_database.dart';
import 'package:navatech_assignment/data/dao/album_dao.dart';
import 'package:navatech_assignment/data/dao/photo_dao.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

@module
abstract class DatabaseModule {
  @preResolve
  @singleton
  Future<AppDatabase> get database => AppDatabase.getInstance();

  @singleton
  AlbumDao albumDao(AppDatabase database) => database.albumDao;

  @singleton
  PhotoDao photoDao(AppDatabase database) => database.photoDao;
}
