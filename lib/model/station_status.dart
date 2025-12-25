class station_status {
  final int stationId;
  final int bikesAvailable;
  final int docksAvailable;
  final int fitBikesAvailable;
  final int efitBikesAvailable;
  final int boostBikesAvailable;
  final DateTime lastUpdated;

  station_status({
    required this.stationId,
    required this.bikesAvailable,
    required this.docksAvailable,
    required this.fitBikesAvailable,
    required this.efitBikesAvailable,
    required this.boostBikesAvailable,
    required this.lastUpdated,
  });

  factory station_status.fromJson(Map <String, dynamic> json, int timestamp){
    int fit=0;
    int efit=0;
    int boost=0;

    if(json['vehicle_types_available']!=null){
      var vehicleList= json['vehicle_types_available'] as List;
      for(dynamic v in vehicleList){
        final typeId= v['vehicle_type_id'];
        final count= (v['count'] as num).toInt();

        if(typeId=="FIT") fit+=count;
        else if(typeId=="BOOST") boost+=count;
        else if(typeId=="EFIT") efit+=count;
      }
    }

    return station_status( 
      stationId: int.tryParse(json['station_id'].toString()) ?? 0,
      bikesAvailable: int.tryParse(json['num_bikes_available'].toString()) ??0,
      docksAvailable: int.tryParse(json['num_docks_available'].toString()) ??0,
      fitBikesAvailable: fit,
      efitBikesAvailable: efit,
      boostBikesAvailable: boost,

      lastUpdated: DateTime.fromMillisecondsSinceEpoch(timestamp*1000),

    );
    }
  

}