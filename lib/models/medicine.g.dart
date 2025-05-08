// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicineAdapter extends TypeAdapter<Medicine> {
  @override
  final int typeId = 0;

  @override
  Medicine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Medicine(
      name: fields[0] as String,
      medtype: fields[1] as String,
      brand: fields[2] as String,
      quantity: fields[3] as int,
      stock: fields[4] as double,
      uses: fields[5] as String,
      sideEffects: fields[6] as String,
      ingredients: fields[7] as String,
      directions: fields[8] as String,
      warnings: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Medicine obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.medtype)
      ..writeByte(2)
      ..write(obj.brand)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.stock)
      ..writeByte(5)
      ..write(obj.uses)
      ..writeByte(6)
      ..write(obj.sideEffects)
      ..writeByte(7)
      ..write(obj.ingredients)
      ..writeByte(8)
      ..write(obj.directions)
      ..writeByte(9)
      ..write(obj.warnings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
