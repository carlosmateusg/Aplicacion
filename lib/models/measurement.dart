import 'package:hive_ce/hive.dart';

part 'measurement.g.dart';

@HiveType(typeId: 0)
class Measurement {

  @HiveField(0)
  final double oxigeno;

  @HiveField(1)
  final double metano;

  @HiveField(2)
  final double co2;

  @HiveField(3)
  final double nitrosos;

  @HiveField(4)
  final double monoxido;

  @HiveField(5)
  final double sulfuricos;

  @HiveField(6)
  final String observacion;

  @HiveField(7)
  final DateTime fecha;

  @HiveField(8)
  final double latitud;

  @HiveField(9)
  final double longitud;

  Measurement({
    required this.oxigeno,
    required this.metano,
    required this.co2,
    required this.nitrosos,
    required this.monoxido,
    required this.sulfuricos,
    required this.observacion,
    required this.fecha,
    required this.latitud,
    required this.longitud,
  });
}