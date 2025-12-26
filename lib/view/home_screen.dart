import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/stationsViewModel.dart';
import '../model/station.dart';
import 'station_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchamos al ViewModel
    final vm = context.watch<BiciViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('BiciCoruña Stats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => vm.cargarDatos(),
          )
        ],
      ),
      body: vm.cargando
          ? const Center(child: CircularProgressIndicator())
          : vm.mensajeError.isNotEmpty
              ? Center(child: Text(vm.mensajeError))
              : Column(
                  children: [
                    // --- GRÁFICO 1: Comparativa Global (Barras) ---
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("Top 5 Estaciones (E-Bikes)",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    SizedBox(
                      height: 200,
                      child: _TopStationsChart(stations: vm.listaDeEstaciones),
                    ),
                    
                    const Divider(),

                    // --- LISTA DE ESTACIONES ---
                    Expanded(
                      child: ListView.builder(
                        itemCount: vm.listaDeEstaciones.length,
                        itemBuilder: (context, index) {
                          final station = vm.listaDeEstaciones[index];
                          final isFav = vm.esFavorita(station.id);
                          
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isFav ? Colors.red : Colors.grey,
                                child: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.white),
                              ),
                              title: Text(station.name),
                              subtitle: Text("Disponibles: ${station.bikesAvailable} (⚡${station.ebikesAvailable})"),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => StationDetailScreen(station: station),
                                  ),
                                );
                              },
                              onLongPress: () => vm.cambiarFav(station.id),
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

// Widget auxiliar para el gráfico de barras (Top 5 E-Bikes)
class _TopStationsChart extends StatelessWidget {
  final List<Station> stations;

  const _TopStationsChart({required this.stations});

  @override
  Widget build(BuildContext context) {
    // 1. Ordenamos por total de bicis (o ebikesAvailable si prefieres solo eléctricas)
    final sorted = List<Station>.from(stations)
      ..sort((a, b) => b.bikesAvailable.compareTo(a.bikesAvailable));
    
    // 2. Tomamos solo las 3 primeras
    final top3 = sorted.take(3).toList();

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 30, // He subido un poco el límite por seguridad
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  // CORRECCIÓN: Usamos 'top3' aquí (antes tenías top5)
                  if (index >= 0 && index < top3.length) {
                    // Recortamos el nombre si es muy largo para que quepa
                    String nombre = top3[index].name;
                    if (nombre.length > 8) nombre = "${nombre.substring(0, 8)}..";
                    
                    return Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(nombre, style: const TextStyle(fontSize: 10)),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          // CORRECCIÓN: Usamos 'top3' para generar las barras
          barGroups: top3.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  // Usamos bikesAvailable para ver disponibilidad total
                  toY: entry.value.bikesAvailable.toDouble(),
                  color: Colors.blueAccent,
                  width: 15,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
