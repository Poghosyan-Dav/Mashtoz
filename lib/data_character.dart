// import 'package:hive/hive.dart';
//
// import 'domens/models/book_data/data.dart';
//
// class DataAdapter extends TypeAdapter<Data> {
//   @override
//   Data read(BinaryReader reader) {
//     var numOfFields = reader.readByte();
//     var fields = <int, dynamic>{
//       for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return Data(
//       id: fields[0] as int,
//       title: fields[1] as String,
//       image: fields[2] as String,
//       body: fields[3] as String,
//       type: fields[4] as String,
//       firstCharacter: fields[5] as String,
//       link: fields[6] as dynamic,
//       video_link: fields[7] as String,
//       explanation: fields[8] as String,
//       author: fields[9] as String,
//       summary: fields[10] as String,
//       sharurl: fields[11] as String,
//
//     );
//   }
//
//   @override
//   void write(BinaryWriter writer, Data obj) {
//     writer
//       ..writeByte(12)
//       ..writeByte(0)
//       ..write(obj.id)
//       ..writeByte(1)
//       ..write(obj.title)
//       ..writeByte(2)
//       ..write(obj.image)
//       ..writeByte(3)
//       ..write(obj.body)
//       ..writeByte(4)
//       ..write(obj.type)
//       ..writeByte(5)
//       ..write(obj.firstCharacter)
//       ..writeByte(6)
//       ..write(obj.link)
//       ..writeByte(7)
//       ..write(obj.video_link)
//       ..writeByte(8)
//       ..write(obj.explanation)
//       ..writeByte(9)
//       ..write(obj.author)
//       ..writeByte(10)
//       ..write(obj.summary)
//       ..writeByte(11)
//       ..write(obj.sharurl);
//   }
//
//   @override
//   int get typeId => 2;
// }