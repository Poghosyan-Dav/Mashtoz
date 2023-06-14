import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:mashtoz_flutter/domens/data_providers/session_data_provider.dart';
import 'package:mashtoz_flutter/domens/models/book_data/book_home_data.dart';
import 'package:mashtoz_flutter/domens/models/book_data/category_lsit.dart';
import 'package:mashtoz_flutter/domens/models/book_data/gallery_data.dart';
import 'package:mashtoz_flutter/domens/models/book_data/lessons.dart';
import 'package:mashtoz_flutter/domens/models/book_data/word_of_day.dart';

import '../../globals.dart';
import '../models/book_data/content_list.dart';
import '../models/book_data/data.dart';

class BookDataProvider {
  Stream<FileResponse>? fileStream;
  // CacheManager? cacheManager;
  final sessionDataProvider = SessionDataProvider();
  // final Box homeBox = Hive.box('data');
  // final Box charactersBox = Hive.box('UserData');
  // final Box categoryBox = Hive.box('category');
  final cacheManager = DefaultCacheManager();
  String? _cachedETag; // declare a private field to store the ETag value

  //Fetch Category List
  Future<List<BookCategory>> getCategoryLists(String url,bool isFromMenu) async {
    var libraryList = <BookCategory>[];
    //   try {

    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    var body = json.decode(response.body);

    var success = body['success'];
    if (success == true) {
      try{
        var data = body['data'];
        var newData =(data as List).map((e) => BookCategory.fromJson(e) as BookCategory).toList();
        if(isFromMenu) newData.insert(2, BookCategory(categoryTitle: null, id: null, title: 'ԻՏԱԼԵՐԵՆ֊ՀԱՅԵՐԵՆ ԲԱՌԱՐԱՆ', type: 'dictionary'));
        return newData;
      }catch(e){
        print(e);
      }

      // print(newData);
      // libraryList.addAll(newData);
    } else {
      print("failed");
    }
    return libraryList;
  }

  // Future<List<dynamic>?> getLibraryBooksByCategory(int idCategory) async {
  //   List<dynamic> libraryList = [];
  //
  //   // Check if response is cached
  //   var file = await cacheManager?.getFileFromCache(Api.libraryCategoryById(idCategory.toString()));
  //   if (file != null && file.validTill?.isAfter(DateTime.now()) == true) {
  //     print('Fetching from cache');
  //     var body = await file.file.readAsString();
  //     var content = json.decode(body)['data']['content'];
  //     Map.from(content).forEach((key, value) {
  //       if (key
  //           .toString()
  //           .contains(Map.
  //       from(value).values.first.toString())) {
  //         var data = Content.fromJson(value);
  //         libraryList.add(data);
  //
  //       }
  //     });
  //     return libraryList;
  //   }
  //
  //   // Fetch data from network
  //   try {
  //     print('Fetching from the network');
  //     var eTag = _cachedETag; // use the cached ETag value (if it exists)
  //     var response = await http.get(
  //       Uri.parse(Api.libraryCategoryById(int.parse('$idCategory').toString(), eTag: eTag)),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'If-None-Match': eTag ?? '',
  //       },
  //     );
  //     if (response.statusCode == 304) {
  //       print('Data not modified');
  //       return libraryList;
  //     }
  //     var body = json.decode(response.body);
  //     var content = body['data']['content'];
  //     var success = body['success'];
  //     if (success == true) {
  //       Map.from(content).forEach((key, value) {
  //         if (key
  //             .toString()
  //             .contains(Map.
  //         from(value).values.first.toString())) {
  //           var data = Content.fromJson(value);
  //           if(data!=null){
  //             libraryList?.add(data);
  //           }
  //
  //         }
  //       });
  //       // Cache the response and store the new ETag value
  //       _cachedETag = response.headers['etag'];
  //       await cacheManager?.putFile(
  //         Api.libraryCategoryById(idCategory.toString(), eTag: _cachedETag),
  //         response.bodyBytes,
  //         eTag: _cachedETag,
  //       );
  //     } else {
  //       print('failed');
  //       return libraryList;
  //     }
  //   } catch (e) {
  //     print('Imherreeeeeee ${e}');
  //   }
  //
  //   return libraryList;
  // }
  Future<List<dynamic>?> getLibraryBooksByCategory(int idCategory) async {
    List<dynamic> libraryList = [];
    List<dynamic>? updatedLibraryList = [];

    // Check if response is cached
    var file = await cacheManager?.getFileFromCache(Api.libraryCategoryById(idCategory.toString()));

    if (file != null && file.validTill?.isAfter(DateTime.now()) == true) {
      print('Fetching from cache');
      var body = await file.file.readAsString();
      var content = json.decode(body)['data']['content'];
      Map.from(content).forEach((key, value) {
        if (key.toString().contains(Map.from(value).values.first.toString())) {
          var data = Content.fromJson(value);
          libraryList.add(data);
        }
      });

      // Fetch data from network to check for updates
      var response = await http.get(
        Uri.parse(Api.libraryCategoryById(idCategory.toString())),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      var responseBody = json.decode(response.body);
      var responseContent = responseBody['data']['content'];
      var success = responseBody['success'];

      if (success == true) {
        List<dynamic>? updatedLibraryList = [];

        Map.from(responseContent).forEach((key, value) {
          if (key.toString().contains(Map.from(value).values.first.toString())) {
            var data = Content.fromJson(value);
            if (data != null) {
              updatedLibraryList.add(data);
            }
          }
        });

        if (!listEquals(updatedLibraryList, libraryList)) {
          // Cache the response and update the libraryList
          await cacheManager?.putFile(
            Api.libraryCategoryById(idCategory.toString()),
            response.bodyBytes,
          );
          libraryList = updatedLibraryList;
        }
      } else {
        print('Failed to fetch data');
      }

      return libraryList;
    }

    // Fetch data from network
    try {
      print('Fetching from the network');
      var response = await http.get(
        Uri.parse(Api.libraryCategoryById(int.parse('$idCategory').toString())),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      var body = json.decode(response.body);
      var content = body['data']['content'];
      var success = body['success'];

      if (success == true) {
        Map.from(content).forEach((key, value) {
          if (key.toString().contains(Map.from(value).values.first.toString())) {
            var data = Content.fromJson(value);
            if (data != null) {
              updatedLibraryList?.add(data);
            }
          }
        });

        if (!listEquals(updatedLibraryList, libraryList)) {
          // Cache the response and update the libraryList
          await cacheManager?.putFile(
            Api.libraryCategoryById(idCategory.toString()),
            response.bodyBytes,
          );
          libraryList = updatedLibraryList;
        }
      } else {
        print('Failed to fetch data');
      }
    } catch (e) {
      print('Error: $e');
    }

    return libraryList;
  }

  // Future<List<dynamic>?> getLibraryBooksByCategory(int idCategory) async {
  //   List<dynamic> libraryList = [];
  //
  //   // Check if response is cached
  //   var file = await cacheManager?.getFileFromCache(Api.libraryCategoryById(idCategory.toString()));
  //   if (file != null && file.validTill?.isAfter(DateTime.now()) == true) {
  //     print('Fetching from cache');
  //     var body = await file.file.readAsString();
  //     var content = json.decode(body)['data']['content'];
  //     Map.from(content).forEach((key, value) {
  //       if (key
  //           .toString()
  //           .contains(Map.
  //       from(value).values.first.toString())) {
  //         var data = Content.fromJson(value);
  //         libraryList.add(data);
  //
  //       }
  //     });
  //     return libraryList;
  //   }
  //
  //   // Fetch data from network
  //   try {
  //     print('Fetching from the network');
  //     var response = await http.get(
  //       Uri.parse(Api.libraryCategoryById(idCategory.toString())),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //       },
  //     );
  //     var body = json.decode(response.body);
  //     var content = body['data']['content'];
  //     var success = body['success'];
  //     if (success == true) {
  //       Map.from(content).forEach((key, value) {
  //                   if (key
  //                       .toString()
  //                       .contains(Map.
  //                   from(value).values.first.toString())) {
  //                     var data = Content.fromJson(value);
  //                     if(data!=null){
  //                       libraryList?.add(data);
  //                     }
  //
  //                   }
  //                 });
  //       // Cache the response
  //       await cacheManager?.putFile(
  //         Api.libraryCategoryById(idCategory.toString()),
  //         response.bodyBytes,
  //         eTag: response.headers['etag'] ?? '',
  //       );
  //     } else {
  //       print('failed');
  //       return libraryList;
  //     }
  //   } catch (e) {
  //     print('Imherreeeeeee ${e}');
  //   }
  //
  //   return libraryList;
  // }

  // Future<List?> getLibrarayYbooksByCategory(
  //     int idCategory) async {
  //   List<dynamic>? libraryList = [];
  //   try {
  //
  //     print('Fetching from Hive');
  //     libraryList =
  //     (categoryBox.get(idCategory.toString()) != null ? categoryBox.get(idCategory.toString())  : []) ;
  //     if (libraryList?.length == 0) {
  //       print('Fetching from the network');
  //       var response = await http.get(
  //         Uri.parse(Api.libraryCategoryById(idCategory.toString())),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json',
  //         },
  //       );
  //       var body = json.decode(response.body);
  //       var content = body['data']['content'];
  //       var success = body['success'];
  //       if (success == true) {
  //         Map.from(content).forEach((key, value) {
  //           if (key
  //               .toString()
  //               .contains(Map.
  //           from(value).values.first.toString())) {
  //             var data = Content.fromJson(value);
  //             if(data!=null){
  //               libraryList?.add(data);
  //             }
  //
  //           }
  //         });
  //         await categoryBox.put(idCategory.toString(), libraryList);
  //       } else {
  //         print('failed');
  //         return libraryList;
  //       }
  //     }
  //   } catch (e) {
  //     print('Imherreeeeeee ${e}');
  //   }
  //   //await categoryBox.close();
  //   return libraryList!;
  // }

  //Fetch Gallery List
  Future<List<dynamic>> fetchGalleryList() async {
    var galleryList = <dynamic>[];

    try {
      var response = await http.get(
        Uri.parse(Api.gallery),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      var body = json.decode(response.body);

      var success = body['success'];
      if (success == true) {
        var data = body['data'];
        Map.from(data).forEach((key, value) {
          (value is List)
              ? galleryList.add([key, value])
              : Map<String, dynamic>.from(value).forEach((key2, value2) {
                  var dataf = [key, Gallery.fromJson(value2)];

                  galleryList.add(dataf);
                });
        });
      }
    } catch (e) {
      print(e);
    }

    return galleryList;
  }

  //Main menu list
  Future<List<Data>?> getMenuList() async {
    var response = await http.get(
      Uri.parse(Api.menu),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var body = json.decode(response.body);
    var success = body['success'];
    var datas = body['data'];
    if (success == true) {
      return (datas as List).map((e) => Data.fromJson(e)).toList();
    } else {
      print("failed");
    }
    return null;
  }

  //Dialect Character
  Future<List<String>> getDialect_Encyclopaedia_Characters(String url) async {
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var body = json.decode(response.body);
    var success = body['success'];
    var datas = body['data'];

    if (success == true) {
      var dat = List<String>.from(datas.map((x) => x)).toList();
      dat.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      return dat;
    } else {
      print("failed");
    }
    return [];
  }

  //Data by characters
  Future<List<Data>> getDataByCharacters(String url) async {
    var dialects = <Data>[];

    // Check if response is cached
    var file = await cacheManager?.getFileFromCache(url);
    if (file != null && file.validTill?.isAfter(DateTime.now()) == true) {
      print('Fetching from cache');
      var body = await file.file.readAsString();
      var data = json.decode(body)['data'];
      if (data is List) {
        // Handle case when data is a list
        data.forEach((element) {
          var dat = Data.fromJson(element);
          dialects.add(dat);
        });
      } else if (data is Map) {
        // Handle case when data is a map
        Map.from(data).values.forEach((element) {
          var dat = Data.fromJson(element);
          dialects.add(dat);
        });
      }
      return dialects;
    }

    // Fetch data from network
    try {
      print('Fetching from the network');
      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var body = json.decode(response.body);
      var success = body['success'];
      var data = body['data'];

      if (success == true) {
        if (data is List) {
          // Handle case when data is a list
          data.forEach((element) {
            var dat = Data.fromJson(element);
            dialects.add(dat);
          });
        } else if (data is Map) {
          // Handle case when data is a map
          Map.from(data).values.forEach((element) {
            var dat = Data.fromJson(element);
            dialects.add(dat);
          });
        }
        // Cache the response
        await cacheManager?.putFile(
          url,
          response.bodyBytes,
          maxAge: Duration(minutes: 10), // Cache for 10 minutes
        );
        return dialects;
      } else {
        print("failed");
      }
    } catch (error) {
      // Handle the exception
      print("Error: $error");
    }


    return dialects;
  }


  Future<List<Data>> getDataByCharactersForHome(String url) async {
    var dialects = <Data>[];

    // Try to fetch data from cache
    var file = await DefaultCacheManager().getSingleFile(url);
    if (await file.exists()) {
      var jsonString = await file.readAsString();
      var body = json.decode(jsonString);
      var success = body['success'];
      var datas = body['data'];
      if (success == true) {
        Map.from(datas).values.forEach((element) {
          var dat = Data.fromJson(element);
          dialects.add(dat);
        });
      }
    }

    // Call API to get data
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    // Parse API response
    var body = json.decode(response.body);
    var success = body['success'];
    var datas = body['data'];
    if (success == true) {
      Map.from(datas).values.forEach((element) {
        var dat = Data.fromJson(element);
        dialects.add(dat);
      });

      // Check if data in cache is different from API response
      var jsonString = json.encode(body);
      if (await file.exists()) {
        var oldJsonString = await file.readAsString();
        if (jsonString != oldJsonString) {
          await DefaultCacheManager().putFile(url, response.bodyBytes);
        }
      } else {
        await DefaultCacheManager().putFile(url, response.bodyBytes);
      }
    }

    return dialects;
  }


  //Words of Day
  Future<WordOfDay?> getWordsOfDay() async {
    var response = await http.get(
      Uri.parse(Api.wordsOfDay),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var body = json.decode(response.body);
    var success = body['success'];
    var datas = body['data'];
    if (success == true && response.statusCode == 200) {
      var newData = WordOfDay.fromJson(datas);
      return newData;
    } else {
      print("failed");
      return null;
    }
  }

  Future<List<WordOfDay>> getAfterWordsOfDay() async {
    var listDaysWord = <WordOfDay>[];
    var response = await http.get(
      Uri.parse(Api.afterWordsOfDay),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var body = json.decode(response.body);
    var success = body['success'];
    var data = body['data'];
    try{
      if (success == true && response.statusCode == 200) {
        Map.from(data).forEach((key, value) {
          if(value != null ){
            var iData = WordOfDay.fromJson(value);
            listDaysWord.add(iData);
          }
        });
          return  listDaysWord ;

      }
    }
    catch(e){
      print(e);
    }

    return listDaysWord;
  }

  //Lessons
  Future<List<Lessons>> getLessons() async {
    var dialects = <Lessons>[];
    try {
      var response = await http.get(
        Uri.parse(Api.italianLessons),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var body = json.decode(response.body);
      var success = body['success'];
      var datas = body['data'];
      if (success == true) {
        var dialects = List.from(datas)
            .map(
              (e) => Lessons.fromJson(e),
            )
            .toList();
        return dialects;
      } else {
        print("failed");
        return dialects;
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
  // Future<HomeData> getHomeData() async {
  //   try {
  //     var response = await http.get(
  //       Uri.parse(Api.getHomeData),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //     );
  //     var body = json.decode(response.body);
  //     var success = body['success'];
  //     if (success == true) {
  //       var data = body['data'] as Map<String, dynamic>;
  //
  //       var newData = HomeData.fromJson(data);
  //
  //       return newData;
  //     }
  //   } catch (e) {
  //     print(e);
  //     // throw Exception(e);
  //   }
  //   return HomeData();
  // }
  Future<HomeData> getHomeData() async {
    try {
      // Check if response is cached
      var file = await cacheManager.getFileFromCache(Api.getHomeData);
      if (file != null && file.validTill?.isAfter(DateTime.now()) == true) {
        print('Fetching from cache');
        var body = await file.file.readAsString();
        var data = HomeData.fromJson(json.decode(body)['data']);
        return data;
      }

      // Fetch data from network
      var response = await http.get(
        Uri.parse(Api.getHomeData),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // Add any additional headers as needed
        },
      );
      var body = json.decode(response.body);
      var success = body['success'];
      if (success == true) {
        var data = body['data'] as Map<String, dynamic>;
        var newData = HomeData.fromJson(data);
        // Cache the response
        await cacheManager.putFile(
          Api.getHomeData,
          response.bodyBytes,
          eTag: response.headers['etag'] ?? '',
          // Set the maximum cache age (in seconds)
          maxAge: Duration(seconds: 10),
          // Set the maximum cache size (in bytes)
        );
        return newData;
      } else {
        // Handle error case
        var error = body['error'] ?? 'Unknown error';
        print('Error: $error');
        throw Exception(error);
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      rethrow;
    }
  }


}
