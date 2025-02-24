// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CommentAdapter extends TypeAdapter<Comment> {
  @override
  final int typeId = 18;

  @override
  Comment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Comment(
      id: fields[0] as String,
      postId: fields[1] as String,
      postType: fields[2] as String,
      userId: fields[3] as String,
      user: fields[4] as UserPreview?,
      content: fields[5] as String,
      parentId: fields[6] as String?,
      likes: (fields[7] as List?)?.cast<String>(),
      replyCount: fields[8] as int,
      createdAt: fields[9] as DateTime?,
      replies: (fields[10] as List?)?.cast<Comment>(),
    );
  }

  @override
  void write(BinaryWriter writer, Comment obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.postId)
      ..writeByte(2)
      ..write(obj.postType)
      ..writeByte(3)
      ..write(obj.userId)
      ..writeByte(4)
      ..write(obj.user)
      ..writeByte(5)
      ..write(obj.content)
      ..writeByte(6)
      ..write(obj.parentId)
      ..writeByte(7)
      ..write(obj.likes)
      ..writeByte(8)
      ..write(obj.replyCount)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.replies);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
