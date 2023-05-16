// import 'package:hive/hive.dart';
//
// import 'domens/models/book_data/content_list.dart';
//
// class ContentAdapter extends TypeAdapter<Content> {
//   @override
//   Content read(BinaryReader reader) {
//     var numOfFields = reader.readByte();
//     var fields = <int, dynamic>{
//       for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return Content(
//       id: fields[0] as int,
//       title: fields[1] as String,
//       image: fields[2] as String,
//       body: fields[3] as String,
//       videoLink: fields[4] as String,
//       explanation: fields[5] as String,
//       author: fields[6] as String,
//       number: fields[7] as String,
//       first_character: fields[8] as String,
//       summary: fields[9] as String,
//       sharurl: fields[10] as String,
//       content: fields[11] == null ?  null : Map.from(fields[11])
//         .map((key, value) => MapEntry(key, value )),
//     );
//   }
//
//   @override
//   void write(BinaryWriter writer, Content obj) {
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
//       ..write(obj.videoLink)
//       ..writeByte(5)
//       ..write(obj.explanation)
//       ..writeByte(6)
//       ..write(obj.author)
//       ..writeByte(7)
//       ..write(obj.number)
//       ..writeByte(8)
//       ..write(obj.first_character)
//       ..writeByte(9)
//       ..write(obj.summary)
//       ..writeByte(10)
//       ..write(obj.sharurl)
//       ..writeByte(11)
//       ..write(obj.content);
//   }
//
//   @override
//   int get typeId => 0;
// }