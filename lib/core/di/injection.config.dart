// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:navatech_assignment/core/di/injection.dart' as _i596;
import 'package:navatech_assignment/core/local/app_database.dart' as _i56;
import 'package:navatech_assignment/core/network/api_client.dart' as _i867;
import 'package:navatech_assignment/data/dao/album_dao.dart' as _i611;
import 'package:navatech_assignment/data/dao/photo_dao.dart' as _i391;
import 'package:navatech_assignment/data/home/store/home_store.dart' as _i225;
import 'package:navatech_assignment/data/repository/repository.dart' as _i54;
import 'package:navatech_assignment/data/service/backend_service.dart' as _i774;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final databaseModule = _$DatabaseModule();
    gh.factory<_i867.ApiClient>(() => _i867.ApiClient());
    await gh.singletonAsync<_i56.AppDatabase>(
      () => databaseModule.database,
      preResolve: true,
    );
    gh.factory<_i774.IBackendService>(
        () => _i774.BackendService(gh<_i867.ApiClient>()));
    gh.singleton<_i611.AlbumDao>(
        () => databaseModule.albumDao(gh<_i56.AppDatabase>()));
    gh.singleton<_i391.PhotoDao>(
        () => databaseModule.photoDao(gh<_i56.AppDatabase>()));
    gh.factory<_i54.IRepository>(() => _i54.Repository(
          gh<_i774.IBackendService>(),
          gh<_i611.AlbumDao>(),
          gh<_i391.PhotoDao>(),
        ));
    gh.factory<_i225.HomeBloc>(() => _i225.HomeBloc(gh<_i54.IRepository>()));
    return this;
  }
}

class _$DatabaseModule extends _i596.DatabaseModule {}
