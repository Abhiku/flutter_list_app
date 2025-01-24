import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:navatech_assignment/core/di/injection.dart';
import 'package:navatech_assignment/core/theme/app_theme.dart';
import 'package:navatech_assignment/home/page/home_screen.dart';
import 'package:navatech_assignment/home/store/home_store.dart';
import 'package:navatech_assignment/home/state/states.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Albums',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => GetIt.I<HomeBloc>()..add(LoadAlbums()),
        child: const HomeScreen(),
      ),
    );
  }
}
