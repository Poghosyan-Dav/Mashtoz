// import 'package:hive/hive.dart';
//
// import 'domens/models/book_data/lessons.dart';
//
// class LessonsAdapter extends TypeAdapter<Lessons> {
//   @override
//   Lessons read(BinaryReader reader) {
//     var numOfFields = reader.readByte();
//     var fields = <int, dynamic>{
//       for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return Lessons(
//       id: fields[0] as int,
//       image: fields[1] as String,
//       title: fields[2] as String,
//       link: fields[3] as String,
//       number: fields[4] as String,
//     );
//   }
//
//   @override
//   void write(BinaryWriter writer, Lessons obj) {
//     writer
//       ..writeByte(5)
//       ..writeByte(0)
//       ..write(obj.id)
//       ..writeByte(1)
//       ..write(obj.image)
//       ..writeByte(2)
//       ..write(obj.title)
//       ..writeByte(3)
//       ..write(obj.link)
//       ..writeByte(4)
//       ..write(obj.number);
//   }
//
//   @override
//   int get typeId => 4;
// }