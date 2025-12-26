import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../model/station.dart';

class BarchartHomepage extends StatelessWidget {
  final List<Station> stations;

  const BarchartHomepage({required this.stations});
  
  @override
  Widget build(BuildContext context) {
    
    if(stations.isEmpty){
      return const Center(child: Text("Cargando..."));
    }

    List<Station> ordenadas= List.from(stations);

    ordenadas.sort((a,b)=>b.bikesAvailable.compareTo(a.bikesAvailable));

    List<Station> top3= ordenadas.take(3).toList();

    List<BarChartGroupData> barras= [];

    for(int i=0; i<top3.length; i++){
      Station estacion= top3[i];

      BarChartGroupData unaBarra= BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: estacion.bikesAvailable.toDouble(),
            color: Colors.blue,
            width: 15,
            borderRadius: BorderRadius.circular(4),
          )
        ],
      );
      barras.add(unaBarra);
    }
    return Padding(
      padding: const EdgeInsets.all(10),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: top3.first.bikesAvailable.toDouble()+5,
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();

                  if (index < top3.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        top3[index].name, 
                        style: const TextStyle(fontSize: 10),
                        overflow: TextOverflow.ellipsis, 
                      ),
                    );
                  }
                  return const Text("");
                },
              ),
            ),
          ),
          
          barGroups: barras, 
        ),
      ),
    );
  }
}