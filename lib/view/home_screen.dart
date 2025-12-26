import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/stationsViewModel.dart';
import '../model/station.dart';
import 'barChart_HomePage.dart';
import 'station_detail_screen.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final vm= context.watch<BiciViewModel> ();

    List <Station> listaOrdenada= List.from(vm.listaDeEstaciones);

    listaOrdenada.sort((a,b){
      bool aEsFav= vm.esFavorita(a.id);
      bool bEsFav= vm.esFavorita(b.id);

      if(aEsFav && !bEsFav) return -1;
      if(!aEsFav&& bEsFav) return 1;
      return 0;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("BiciCoruña pero mejor"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              vm.cargarDatos(); 
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Actualizando datos..."), duration: Duration(milliseconds: 500)),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("Top 3 Estaciones (Total Bicis)", style: TextStyle(fontWeight: FontWeight.bold)),
          ),

          SizedBox(
            height: 200,
            child: BarchartHomepage(stations: vm.listaDeEstaciones),
          ),

          const Divider(thickness: 2),
          Expanded(
            child: vm.cargando 
              ? const Center(child: CircularProgressIndicator()) 
              : ListView.builder(
                  itemCount: listaOrdenada.length,
                  itemBuilder: (context, index) {
                    final station = listaOrdenada[index];
                    final esFavorita = vm.esFavorita(station.id);
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: IconButton(
                          icon: Icon(
                            esFavorita ? Icons.favorite : Icons.favorite_border,
                            color: esFavorita ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            vm.cambiarFav(station.id);
                          },
                        ),
                        title: Text(station.name),
                        subtitle: Text("Bicicletas disponibles: ${station.bikesAvailable} \nDocks disponibles: ${station.docksAvailable}"),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StationDetailScreen(station: station),
                            ),
                          );
                        },
                      ),
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}