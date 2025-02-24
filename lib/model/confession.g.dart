// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confession.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConfessionAdapter extends TypeAdapter<Confession> {
  @override
  final int typeId = 15;

  @override
  Confession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Confession(
      id: fields[0] as String,
      content: fields[1] as String,
      category: fields[2] as String,
      userId: fields[3] as String,
      createdAt: fields[4] as DateTime,
      isAnonymous: fields[5] as bool,
      mentions: (fields[6] as List).cast<String>(),
      likesCount: fields[7] as int,
      commentsCount: fields[8] as int,
      isDeleted: fields[9] as bool,
      isReported: fields[10] as bool,
      reportReason: fields[11] as String?,
      isLikedByCurrentUser: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Confession obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.userId)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.isAnonymous)
      ..writeByte(6)
      ..write(obj.mentions)
      ..writeByte(7)
      ..write(obj.likesCount)
      ..writeByte(8)
      ..write(obj.commentsCount)
      ..writeByte(9)
      ..write(obj.isDeleted)
      ..writeByte(10)
      ..write(obj.isReported)
      ..writeByte(11)
      ..write(obj.reportReason)
      ..writeByte(12)
      ..write(obj.isLikedByCurrentUser);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
