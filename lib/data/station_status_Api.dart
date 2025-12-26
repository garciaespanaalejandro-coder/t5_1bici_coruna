import 'dart:convert';
import 'package:http/http.dart' as http;

class station_status_Api {
  static const String _base ='https://acoruna.publicbikesystem.net/customer/gbfs/v2/gl/station_status';
  
Future<Map<String, dynamic>> getPostsJson() async {    final url = Uri.parse(_base);
    final res = await http.get(url);

    if(res.statusCode!= 200){
      throw Exception('HTTP ${res.statusCode}');
    }

    final decoded = jsonDecode(res.body);

    if (decoded is Map<String, dynamic> && decoded['data'] != null) {
       return {
         'last_updated': decoded['last_updated'], 
         'stations': decoded['data']['stations']  
       };
    } else {
       throw Exception('Respuesta inesperada');
    }
  }
}