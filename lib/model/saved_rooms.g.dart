// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_rooms.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedRoomsAdapter extends TypeAdapter<SavedRooms> {
  @override
  final int typeId = 0;

  @override
  SavedRooms read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedRooms(
      timeOfPost: fields[0] as DateTime,
      iam: fields[1] as String,
      phoneNo: fields[2] as String,
      propertyImgUrl: fields[3] as String,
      plusCode: fields[4] as String,
      address: fields[5] as String,
      rent: fields[6] as String,
      deposit: fields[7] as String,
      clFrom: fields[8] as String,
      clTo: fields[9] as String,
      bikePark: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SavedRooms obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.timeOfPost)
      ..writeByte(1)
      ..write(obj.iam)
      ..writeByte(2)
      ..write(obj.phoneNo)
      ..writeByte(3)
      ..write(obj.propertyImgUrl)
      ..writeByte(4)
      ..write(obj.plusCode)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.rent)
      ..writeByte(7)
      ..write(obj.deposit)
      ..writeByte(8)
      ..write(obj.clFrom)
      ..writeByte(9)
      ..write(obj.clTo)
      ..writeByte(10)
      ..write(obj.bikePark);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedRoomsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
