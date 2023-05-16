// import 'package:hive/hive.dart';
//
// import 'domens/models/book_data/book_home_data.dart';
// import 'domens/models/book_data/content_list.dart';
// import 'domens/models/book_data/lessons.dart';
//
// class HomeDataAdapter extends TypeAdapter<HomeData> {
//   @override
//   HomeData read(BinaryReader reader) {
//     var numOfFields = reader.readByte();
//     var fields = <int, dynamic>{
//       for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return HomeData(
//       libraries: fields[0] as Content,
//       lessons: (fields[1] as List)?.cast<Lessons>(),
//       encyclopedias: (fields[2] as List)?.cast<String>(),
//       audiolibraries: fields[3] as String,
//       dialects: (fields[4] as List)?.cast<String>(),
//     );
//   }
//
//   @override
//   void write(BinaryWriter writer, HomeData obj) {
//     writer
//       ..writeByte(5)
//       ..writeByte(0)
//       ..write(obj.libraries)
//       ..writeByte(1)
//       ..write
//     ..writeByte(4)
//     ..write(obj.dialects);
//   }
//
//   @override
//   int get typeId => 3;
// }