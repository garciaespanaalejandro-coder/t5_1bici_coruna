import 'package:flutter/material.dart';
import '../data/biciRepository.dart'; 
import '../model/station.dart';

class BiciViewModel extends ChangeNotifier {
  final BiciRepository repository;

  List <Station> listaDeEstaciones= [];
  bool cargando=false;
  String mensajeError="";
  int? _idFavorita;

  BiciViewModel({required this.repository});

  Future <void> cargarDatos() async{
    cargando=true;
    notifyListeners();

    try{
      listaDeEstaciones= await repository.getStations();
      if(_idFavorita==null&& listaDeEstaciones.isNotEmpty){
        _idFavorita=listaDeEstaciones.first.id;
      }
    }catch(e){
      mensajeError="Error, no se pudieron cargar los datos: $e";
    }finally{
      cargando=false;
      notifyListeners();
    }
  }

  Station? get estacionFavorita{
    if(listaDeEstaciones.isEmpty || _idFavorita==null)return null;

    for(Station estacion in listaDeEstaciones){
      if(estacion.id==_idFavorita){
        return estacion;
      }
    }
    return null;
  }

  bool esFavorita(int id){
    return _idFavorita== id;
  }
  
  void cambiarFav(int id){
    if(_idFavorita==id){
      _idFavorita==null;
    }else{
      _idFavorita= id;
    }
    notifyListeners();
  }

  Map <String, dynamic> obtenerRecomendacion(Station station){
    if(station.ebikesAvailable>=3){
      return{
        "texto": "¡BAJA YA HAY ELÉCTRICAS!",
        "color": Colors.green,
        "icono": Icons.flash_on
      };
    }else if(station.bikesAvailable>0 && station.ebikesAvailable==0&&
        station.boostAvailable==0){
      return{
        "texto":"Solo bicicletas mecánicas disponibles.",
        "color": Colors.orange,
        "icono": Icons.pedal_bike,
      };
    }else if(station.docksAvailable>0){
      return{
        "texto":"¡LLENA YA HAY ANCLAJES LIBRES!",
        "color": Colors.blue,
        "icono": Icons.dock,
      };
    }else if(station.bikesAvailable==0 && station.ebikesAvailable==0 && station.boostAvailable==0){
      return{
        "texto": "Estación sin bicicletas.",
        "color": Colors.red,
        "icono": Icons.remove_circle,
      };
    }else if(station.boostAvailable>3){
      return{
        "texto": "Bicis BOOST disponibles.",
        "color": Colors.purple,
        "icono": Icons.electric_bike,
      };
    } 
    return{
      "texto": "Estado desconocido",
      "color": Colors.grey,
      "icono": Icons.help,
    };
  }
}