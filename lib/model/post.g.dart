// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostAdapter extends TypeAdapter<Post> {
  @override
  final int typeId = 16;

  @override
  Post read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Post(
      id: fields[0] as String,
      userId: fields[1] as String,
      content: fields[2] as String,
      mediaUrl: fields[3] as String?,
      likes: (fields[4] as List).cast<String>(),
      comments: (fields[5] as List).cast<Comment>(),
      user: fields[6] as UserPreview?,
      commentCount: fields[7] as int,
      createdAt: fields[8] as DateTime,
      isDeleted: fields[9] as bool,
      isReported: fields[10] as bool,
      reportReason: fields[11] as String?,
      isLikedByCurrentUser: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Post obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.mediaUrl)
      ..writeByte(4)
      ..write(obj.likes)
      ..writeByte(5)
      ..write(obj.comments)
      ..writeByte(6)
      ..write(obj.user)
      ..writeByte(7)
      ..write(obj.commentCount)
      ..writeByte(8)
      ..write(obj.createdAt)
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
      other is PostAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
