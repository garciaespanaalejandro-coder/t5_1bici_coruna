import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart'; 
import '../viewmodel/stationsViewModel.dart';
import '../model/station.dart';

class StationDetailScreen extends StatelessWidget {
  final Station station;

  const StationDetailScreen({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<BiciViewModel>(); 
    final recomendacion = vm.obtenerRecomendacion(station);

    final double mecanicas = station.fitBikesAvailable.toDouble();
    final double electricas = station.ebikesAvailable.toDouble();
    final double libres = station.docksAvailable.toDouble();
    final double semiElectricas= station.boostAvailable.toDouble();

    return Scaffold(
      appBar: AppBar(
        title: Text(station.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: "Exportar Informe PDF",
            onPressed: () => _exportPdf(context, station),
          )
        ],
      ),
      body: SingleChildScrollView( 
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: recomendacion['color'],
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(recomendacion['icono'], size: 40, color: Colors.white),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        recomendacion['texto'],
                        style: const TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.white
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),

            const Text("Distribución de la Estación", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      color: Colors.green,
                      value: electricas,
                      title: '${electricas.toInt()}',
                      radius: 50,
                      titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    PieChartSectionData(
                      color: Colors.orange,
                      value: mecanicas,
                      title: '${mecanicas.toInt()}',
                      radius: 50,
                      titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    PieChartSectionData(
                      color: Colors.amber,
                      value: semiElectricas,
                      title: '${semiElectricas.toInt()}',
                      radius: 50,
                      titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),                      
                    ),
                    PieChartSectionData(
                      color: Colors.grey.shade400,
                      value: libres,
                      title: '${libres.toInt()}',
                      radius: 50,
                      titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _LegendItem(color: Colors.green, text: "Eléctricas"),
                _LegendItem(color: Colors.orange, text: "Mecánicas"),
                _LegendItem(color: Colors.amber, text: "SemiElectricas"),
                _LegendItem(color: Colors.grey, text: "Libres"),
              ],
            ),

            const SizedBox(height: 30),
            const Divider(),

            _buildInfoRow("Dirección / Coordenadas:", "${station.direccion} "),
            _buildInfoRow("Última actualización:", "${station.lastUpdated}"),
            _buildInfoRow("Total Bicis:", "${station.bikesAvailable}"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Future<void> _exportPdf(BuildContext context, Station station) async {
    final pdf = pw.Document();
    

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0, 
                child: pw.Text("Informe estacion: ${station.name}")
              ),
              
              pw.Text("Direccion: ${station.direccion}"),
              pw.SizedBox(height: 20),
              
              pw.Text("Estado Actual:"),
              pw.SizedBox(height: 5),
              
              pw.Bullet(text: "Total de bicicletas disponibles: \n${station.bikesAvailable}"),
              pw.SizedBox(height: 10),
              pw.Bullet(text: "Bicicletas Eléctricas: \n${station.ebikesAvailable}"),
              pw.Bullet(text: "Bicicletas SemiEléctricas: \n${station.boostAvailable}"),              
              pw.Bullet(text: "Bicicletas Normales: \n${station.fitBikesAvailable}"),
              pw.SizedBox(height: 10),
              pw.Bullet(text: "Aparcamientos libres: \n${station.docksAvailable}"),

              pw.SizedBox(height: 20),
              pw.Divider(),
              
              pw.Text("Momento de actualizacion de datos: \n${station.lastUpdated}"),
              pw.Text("Informe generado: ${DateTime.now()}")
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12, height: 12, 
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}