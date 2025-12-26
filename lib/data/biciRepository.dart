import 'station_information_Api.dart';
import 'station_status_Api.dart';
import 'package:t5_1bici_coruna/model/station.dart';


class BiciRepository {
  final station_information_Api infoApi;
  final station_status_Api statusApi;

  BiciRepository({required this.infoApi, required this.statusApi});

  Future<List<Station>> getStations() async {
    final infoList = await infoApi.getPostsJson(); 
    final statusResult = await statusApi.getPostsJson(); 

    final List<dynamic> statusList = statusResult['stations'];
    final int timestamp = statusResult['last_updated'];
    final DateTime fecha = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

    List<Station> listaFinal = [];

    for (var info in infoList) {
      for (var status in statusList) {
        
        if (info['station_id'].toString() == status['station_id'].toString()) {
          
          int bicisElectricas = 0;
          
          if (status['vehicle_types_available'] != null) {
             for (var v in status['vehicle_types_available']) {
               if (v['vehicle_type_id'] == 'EFIT' || v['vehicle_type_id'] == 'BOOST') {
                 bicisElectricas += (v['count'] as int);
               }
             }
          }

          Station nuevaEstacion = Station(
            id: int.parse(info['station_id'].toString()),
            name: info['name'],
            lat: (info['lat'] as num).toDouble(),
            lon: (info['lon'] as num).toDouble(),
            bikesAvailable: (status['num_bikes_available'] as int),
            ebikesAvailable: bicisElectricas,
            docksAvailable: (status['num_docks_available'] as int),
            lastUpdated: fecha,
          );

          listaFinal.add(nuevaEstacion);
        }
      }
    }

    return listaFinal;
  }
}