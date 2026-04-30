// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeasurementAdapter extends TypeAdapter<Measurement> {
  @override
  final typeId = 0;

  @override
  Measurement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Measurement(
      oxigeno: (fields[0] as num).toDouble(),
      metano: (fields[1] as num).toDouble(),
      co2: (fields[2] as num).toDouble(),
      nitrosos: (fields[3] as num).toDouble(),
      monoxido: (fields[4] as num).toDouble(),
      sulfuricos: (fields[5] as num).toDouble(),
      observacion: fields[6] as String,
      fecha: fields[7] as DateTime,
      latitud: (fields[8] as num).toDouble(),
      longitud: (fields[9] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, Measurement obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.oxigeno)
      ..writeByte(1)
      ..write(obj.metano)
      ..writeByte(2)
      ..write(obj.co2)
      ..writeByte(3)
      ..write(obj.nitrosos)
      ..writeByte(4)
      ..write(obj.monoxido)
      ..writeByte(5)
      ..write(obj.sulfuricos)
      ..writeByte(6)
      ..write(obj.observacion)
      ..writeByte(7)
      ..write(obj.fecha)
      ..writeByte(8)
      ..write(obj.latitud)
      ..writeByte(9)
      ..write(obj.longitud);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeasurementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
