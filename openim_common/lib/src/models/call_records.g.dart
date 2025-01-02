part of 'call_records.dart';

class CallRecordsAdapter extends TypeAdapter<CallRecords> {
  @override
  final int typeId = 4;

  @override
  CallRecords read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CallRecords(
      userID: fields[1] as String,
      nickname: fields[2] as String,
      faceURL: fields[3] as String?,
      type: fields[4] as String,
      success: fields[5] as bool,
      incomingCall: fields[6] as bool,
      date: fields[7] as int,
      duration: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CallRecords obj) {
    writer
      ..writeByte(8)
      ..writeByte(1)
      ..write(obj.userID)
      ..writeByte(2)
      ..write(obj.nickname)
      ..writeByte(3)
      ..write(obj.faceURL)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.success)
      ..writeByte(6)
      ..write(obj.incomingCall)
      ..writeByte(7)
      ..write(obj.date)
      ..writeByte(8)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallRecordsAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
