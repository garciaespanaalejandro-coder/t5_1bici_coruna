import 'package:flutter/material.dart';
import 'package:t5_1bici_coruna/data/biciRepository.dart';
import 'package:t5_1bici_coruna/model/station.dart';

class Stationsviewmodel extends ChangeNotifier{

  final BiciRepository repository;

  bool _isLoading=false;

  String _errorMessage='';

  List<Station> _stations=[];

}