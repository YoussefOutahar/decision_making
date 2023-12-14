// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roulette.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RouletteAdapter extends TypeAdapter<Roulette> {
  @override
  final int typeId = 2;

  @override
  Roulette read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Roulette(
      name: fields[0] as String?,
      date: fields[1] as DateTime?,
      choices: (fields[2] as List?)?.cast<String>(),
    )..selectedChoice = fields[3] as String?;
  }

  @override
  void write(BinaryWriter writer, Roulette obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.choices)
      ..writeByte(3)
      ..write(obj.selectedChoice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouletteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
