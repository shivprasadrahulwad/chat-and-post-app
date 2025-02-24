// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preview.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserPreviewAdapter extends TypeAdapter<UserPreview> {
  @override
  final int typeId = 17;

  @override
  UserPreview read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPreview(
      id: fields[0] as String,
      username: fields[1] as String,
      name: fields[2] as String?,
      profileImage: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserPreview obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.profileImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPreviewAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
