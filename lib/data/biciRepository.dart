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
          int biciBoost = 0;
          int biciMecanica=0;
          
          if (status['vehicle_types_available'] != null) {
             for(var v in status['vehicle_types_available']){
               
               final count = (v['count'] as num).toInt();

               if(v['vehicle_type_id'] == 'FIT'){
                 biciMecanica += count;                
               }
               if(v['vehicle_type_id'] == 'EFIT'){
                 bicisElectricas += count;
               }
               if (v['vehicle_type_id'] == 'BOOST') {
                  biciBoost += count;
               }
             }
          }

          int totalBicis = (status['num_bikes_available'] as int);
          if (totalBicis > 0 && bicisElectricas == 0 && biciBoost == 0 && biciMecanica == 0) {
              biciMecanica = totalBicis;
          }
          
          Station nuevaEstacion = Station(
            id: int.parse(info['station_id'].toString()),
            name: info['name'],
            lat: (info['lat'] as num).toDouble(),
            lon: (info['lon'] as num).toDouble(),
            bikesAvailable: (status['num_bikes_available'] as int),
            ebikesAvailable: bicisElectricas,
            boostAvailable: biciBoost,
            fitBikesAvailable: biciMecanica,
            docksAvailable: (status['num_docks_available'] as int),
            lastUpdated: fecha,
            direccion: (info['address']?? '') as String,
          );

          listaFinal.add(nuevaEstacion);
        }
      }
    }

    return listaFinal;
  }
}