import 'dart:convert';
import 'package:http/http.dart' as http;

class station_information_Api {
  static const String _base='https://acoruna.publicbikesystem.net/customer/gbfs/v2/gl/station_information';

  Future<List<dynamic>> getPostsJson() async {
    final url = Uri.parse(_base);
    final res = await http.get(url);
    
    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}');
    }

    final decoded = jsonDecode(res.body);
    if (decoded is Map<String, dynamic> && decoded['data'] != null) {
       return decoded['data']['stations'] as List<dynamic>;
    } else {
       throw Exception('Respuesta inesperada: No se encontró data.stations');
    }
  }
}