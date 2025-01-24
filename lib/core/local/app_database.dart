import 'dart:async';
import 'package:floor/floor.dart';
import 'package:navatech_assignment/data/dao/album_dao.dart';
import 'package:navatech_assignment/data/dao/photo_dao.dart';
import 'package:navatech_assignment/data/entity/album.dart';
import 'package:navatech_assignment/data/entity/photo.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(version: 1, entities: [AlbumEntity, PhotoEntity])
abstract class AppDatabase extends FloorDatabase {
  AlbumDao get albumDao;
  PhotoDao get photoDao;

  static Future<AppDatabase> getInstance() async {
    return await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }
}
