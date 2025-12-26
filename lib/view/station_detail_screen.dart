import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart'; // Para imprimir/compartir
import '../viewmodel/stationsViewModel.dart';
import '../model/station.dart';

class StationDetailScreen extends StatelessWidget {
  final Station station;

  const StationDetailScreen({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<BiciViewModel>(); // Read porque no necesitamos reconstruir todo si cambia el VM global
    final recomendacion = vm.obtenerRecomendacion(station);
    final totalSlots = station.bikesAvailable + station.docksAvailable; 
    // Nota: A veces la suma no es perfecta con la API, pero sirve de aproximación.

    return Scaffold(
      appBar: AppBar(
        title: Text(station.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _generarYExportarPDF(context, station, recomendacion),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // FECHA ACTUALIZACIÓN
              Text(
                "Actualizado: ${station.lastUpdated.hour}:${station.lastUpdated.minute}",
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 10),

              // --- BLOQUE DE RECOMENDACIÓN ---
              Card(
                color: recomendacion['color'],
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(recomendacion['icono'], size: 50, color: Colors.white),
                      const SizedBox(height: 10),
                      Text(
                        recomendacion['texto'],
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // --- GRÁFICO 2: Distribución de la Estación (Pie Chart) ---
              const Text("Distribución de ocupación",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              SizedBox(
                height: 250,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: [
                      // Sección Bicis Eléctricas
                      PieChartSectionData(
                        color: Colors.green,
                        value: station.ebikesAvailable.toDouble(),
                        title: '${station.ebikesAvailable} ⚡',
                        radius: 50,
                        titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      // Sección Bicis Mecánicas (Total bikes - electricas)
                      PieChartSectionData(
                        color: Colors.orange,
                        value: (station.bikesAvailable - station.ebikesAvailable).toDouble(),
                        title: '${station.bikesAvailable - station.ebikesAvailable} 🚲',
                        radius: 50,
                        titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      // Sección Anclajes Libres
                      PieChartSectionData(
                        color: Colors.grey[300],
                        value: station.docksAvailable.toDouble(),
                        title: '${station.docksAvailable} P',
                        radius: 50,
                        titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              // Leyenda manual simple
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _LegendItem(color: Colors.green, text: "Eléctricas"),
                  _LegendItem(color: Colors.orange, text: "Mecánicas"),
                  _LegendItem(color: Colors.grey, text: "Libres"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // --- LÓGICA DE EXPORTACIÓN PDF ---
  Future<void> _generarYExportarPDF(BuildContext context, Station station, Map<String, dynamic> rec) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(level: 0, child: pw.Text("Informe de Estación: ${station.name}")),
              pw.SizedBox(height: 20),
              pw.Text("Generado el: ${DateTime.now().toString()}"),
              pw.Text("Datos actualizados API: ${station.lastUpdated.toString()}"),
              pw.Divider(),
              pw.SizedBox(height: 20),
              
              pw.Text("Estadísticas actuales:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
              pw.Bullet(text: "Bicis Eléctricas disponibles: ${station.ebikesAvailable}"),
              pw.Bullet(text: "Bicis Mecánicas disponibles: ${station.bikesAvailable - station.ebikesAvailable}"),
              pw.Bullet(text: "Anclajes libres: ${station.docksAvailable}"),
              
              pw.SizedBox(height: 30),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Column(
                  children: [
                    pw.Text("Recomendación del sistema", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                    pw.Text(rec['texto'], style: const pw.TextStyle(fontSize: 20, color: PdfColors.blue)),
                  ]
                )
              ),
              pw.Spacer(),
              pw.Footer(title: pw.Text("BiciCoruña Alternativa App")),
            ],
          );
        },
      ),
    );

    // Usa el paquete printing para mostrar la preview o compartir
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  const _LegendItem({required this.color, required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(width: 12, height: 12, color: color),
      const SizedBox(width: 4),
      Text(text),
    ]);
  }
}