import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/biciRepository.dart';
import 'viewmodel/stationsViewModel.dart'; 
import 'view/home_screen.dart';
import 'data/station_information_Api.dart';
import 'data/station_status_Api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final infoApi = station_information_Api();
    final statusApi = station_status_Api();
    final repository = BiciRepository(infoApi: infoApi, statusApi: statusApi);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BiciViewModel(repository: repository)..cargarDatos(),
        ),
      ],
      child: MaterialApp(
        title: 'BiciCoruña Alternativa',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}