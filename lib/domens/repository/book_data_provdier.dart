import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:mashtoz_flutter/domens/blocs/update_home_event.dart';
import 'package:mashtoz_flutter/domens/data_providers/session_data_provider.dart';
import 'package:mashtoz_flutter/domens/models/book_data/book_home_data.dart';
import 'package:mashtoz_flutter/domens/models/book_data/category_lsit.dart';
import 'package:mashtoz_flutter/domens/models/book_data/gallery_data.dart';
import 'package:mashtoz_flutter/domens/models/book_data/lessons.dart';
import 'package:mashtoz_flutter/domens/models/book_data/word_of_day.dart';

import '../../globals.dart';
import '../blocs/update_home_bloc.dart';
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
  Future<List<dynamic>?> getLibraryBooksByCategory(int idCategory,bool isFromPullRefresh) async {
    List<dynamic> libraryList = [];
    List<dynamic>? updatedLibraryList = [];

    // Check if response is cached
    var file = await cacheManager?.getFileFromCache(Api.libraryCategoryById(idCategory.toString()));

    if (file != null) {
      print('Fetching from cache');
      var body = await file.file.readAsString();
      var content = json.decode(body)['data']['content'];
      Map.from(content).forEach((key, value) {
        if (key.toString().contains(Map.from(value).values.first.toString())) {
          var data = Content.fromJson(value);
          libraryList.add(data);
        }
      });
     if(isFromPullRefresh){
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
     }


      return libraryList;
    }

    // Fetch data from network
    try {
      print('Fetching from the network');
      var response = await http.get(
        Uri.parse(Api.libraryCategoryById(idCategory.toString())),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      var body = json.decode(response.body);
      var data = body['data'];

      var success = body['success'];

      if (success == true) {
        if (data is Map) {
          var contents = data['content'];
          contents.forEach((key, value) {
            var content = Content.fromJson(value);
            updatedLibraryList.add(content);
          });
        } else {
          print('Unexpected data type in content: ${data.runtimeType}');
        }
      }

        if (!listEquals(updatedLibraryList, libraryList)) {
          // Cache the response and update the libraryList
          await cacheManager?.putFile(
            Api.libraryCategoryById(idCategory.toString()),
            response.bodyBytes,
          );
          libraryList = updatedLibraryList;
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


      if (success == true) {
        var data = body['data'];
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

  Future<HomeData> getHomeData(bool isFromPullRefresh) async {
    Map<String, dynamic> homeData = {};
    Map<String, dynamic> updateHomeData = {};

    try {
      // Check if response is cached
      var file = await cacheManager.getFileFromCache(Api.getHomeData);
      if (file != null) {
        print('Fetching from cache');
        var body = await file.file.readAsString();
        var data = json.decode(body)['data'] as Map<String, dynamic>;
        homeData = data;

        if (isFromPullRefresh) {
          // Fetch data from network
          var response = await http.get(
            Uri.parse(Api.getHomeData),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              // Add any additional headers as needed
            },
          );
          var responseBody = json.decode(response.body);
          var success = responseBody['success'];
          if (success == true && response.statusCode == 200) {
            var data = responseBody['data'] as Map<String, dynamic>;

            updateHomeData = data;

            homeData = updateHomeData;

              // Cache the response
              await cacheManager.putFile(
                Api.getHomeData,
                response.bodyBytes,
              );


          } else {
            // Handle error case
            var error = responseBody['error'] ?? 'Unknown error';
            print('Error: $error');
            throw Exception(error);
          }
        }

        return HomeData.fromJson(homeData);
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
      if (success == true && response.statusCode == 200) {
        var data = body['data'] as Map<String, dynamic>;
        updateHomeData = data;

        homeData = updateHomeData;
          // Cache the response
          await cacheManager.putFile(
            Api.getHomeData,
            response.bodyBytes,
            eTag: response.headers['etag'] ?? '',
            // Set the maximum cache age (in seconds)
            maxAge: Duration(seconds: 10),
            // Set the maximum cache size (in bytes)
          );


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
    return HomeData.fromJson(homeData);
  }


  Future<void> updateHomeAfterPushNotification(BuildContext context) async {
    final MyBloc bloc = BlocProvider.of<MyBloc>(context);

    try {
      // Fetch the home data using await to make the code cleaner and more readable
      final value = await getHomeData(true);

      // We can execute these three tasks concurrently using Future.wait
      await Future.wait([
        getDataByCharactersForHome(Api.encyclopediasByCharacters(value.encyclopedias?.first)),
        getDataByCharactersForHome(Api.dialectBYCharacters(value.dialects?.first)),
        getDataByCharactersForHome(Api.audioLibrariesByCharacters(value.audiolibraries)),
      ]).catchError((error){
        bloc.add(const UpdateScreenEvent(false));
        print('Error occurred during API call: $error');
      });


      bloc.add(const UpdateScreenEvent(false));

      // Any additional code that needs to be executed after the three tasks
      // (if necessary) can be added here.
    } catch (e) {
      // Handle any potential errors here
      print('Error: $e');
    }
  }
  Future<void> updateBooksAfterPushNotification() async {
    try {
      // Fetch the home data using await to make the code cleaner and more readable
      final List<BookCategory> value = await getCategoryLists(Api.categoryListUrl, false);

      // Use Future.forEach to execute the tasks concurrently
      await Future.forEach(value, (BookCategory nv) async {
        if (nv.id != null) {
          await getLibraryBooksByCategory(nv.id!, true);
        }
      });

    } catch (e) {
      // Handle any potential errors here
      print('Error: $e');
    }
  }
}





String responses = """{
        "success": true,
        "data": {
          "libraries": {
            "content": {
              "656": {
                "id": 656,
                "title": "Սբ. Սիմեոն Նոր Աստվածաբան (949-1022)",
                "image": "https://mashtoz.org/storage/files/symeon-icon.jpg",
                "body": "",
                "video_link": "https://www.youtube.com/watch?v=qXZanMhalSE&list=PLKvKkiEoRUy9akafTCTrI1j4G7ML6ptH4",
                "explanation": "",
                "author": "ՀԱՏԸՆՏԻՐ ՀԱՏՎԱԾՆԵՐ ՍԲ. ՍԻՄԵՈՆ ՆՈՐ ԱՍՏՎԱԾԱԲԱՆԻ ԱՇԽԱՏՈՒԹՅՈՒՆՆԵՐԻՑ",
                "sharurl": "",
                "content": {
                  "657": {
                    "id": 657,
                    "title": "« ՓՈՒԹԱՆՔ ԼԻՆԵԼ ԱՍՏԾՈ ՀԵՏ, ՈՐ ԵՐԿԻՐ ԻՋԱՎ ՄԵԶ ՓՐԿԵԼՈՒ ՀԱՄԱՐ »",
                    "image": "https://mashtoz.org/storage/files/0e7df9d1e61d71d38564d0f77183fc4a.jpg",
                    "body": "",
                    "video_link": "https://www.youtube.com/watch?v=qXZanMhalSE&list=PLKvKkiEoRUy9akafTCTrI1j4G7ML6ptH4",
                    "explanation": "",
                    "author": "",
                    "sharurl":""
                  },
                  "830": {
                    "id": 830,
                    "title": "« ՄԻ´ ՍՏԻՊԻՐ ՆՐԱՆՑ ԱՆԵԼ ԱՅՆ, ԻՆՉ ՆՐԱՆՑ ՈՒՍՈՒՑԱՆՈՒՄ ԵՍ »",
                    "image": "https://mashtoz.org/storage/files/6-1-749x1024.jpg",
                    "body": "",
                    "video_link": "https://www.youtube.com/watch?v=yzA1BKFvsrs&list=PLKvKkiEoRUy_sSsjfhSqZbQEv5ZXyDQt_&index=6",
                    "explanation": "",
                    "author": "",
                    "sharurl": ""
                  },
                  "1012": {
                    "id": 1012,
                    "title": "« ԵՎ ՆՐԱՆՑ ԱՉՔԵՐԸ ԲԱՑՎԵՑԻՆ »",
                    "image": "https://mashtoz.org/storage/files/il-570xn1463801302-g053.jpg",
                    "body": "",
                    "video_link": "https://www.youtube.com/watch?v=RME8P0q56F4&list=PLKvKkiEoRUy_CPqlVTcWhwasbZk7NNFv7",
                    "explanation": "",
                    "author": "",
                    "sharurl": ""
                  },
                  "1709": {
                    "id": 1709,
                    "title": "« ՍՈՒՐԲ ՀՈԳԻՆ, ՈՐԻՆ ՀԱՅՐԸ ԿՈՒՂԱՐԿԻ ԻՄ ԱՆՈՒՆՈՎ, ՆԱ ՁԵԶ ԿՈՒՍՈՒՑԱՆԻ ԱՄԵՆ ԲԱՆ »",
                    "image": "https://mashtoz.org/storage/files/spirit2.jpg",
                    "body": "",
                    "video_link": "https://www.youtube.com/watch?v=kJBWkAIHgWk&list=PLKvKkiEoRUy-b3sf-Fcci5ftiScsZlNKw&index=9",
                    "explanation": "",
                    "author": "",
                    "sharurl": ""
                  },
                  "1978": {
                    "id": 1978,
                    "title": "« ՆՐԱՆ, ՈՎ ԲԱԽՈՒՄ Է, ԿԲԱՑՎԻ »",
                    "image": "https://mashtoz.org/storage/files/jerusalem-jesus-pantokrator-apostle-paint-ceiling-evangelical-lutheran-church-ascension-israel-march-51798377.jpg",
                    "body": "",
                    "video_link": "https://www.youtube.com/watch?v=g-wZnFbrmRI&list=PLKvKkiEoRUy-pl2Dpf-sNZQBqFMkNPdia",
                    "explanation": "",
                    "author": "",
                    "sharurl": ""
                  },
                  "2681": {
                    "id": 2681,
                    "title": "« ՆՄԱՆՎԻՐ ԱՍՏԾՈ ԿԱՏԱՐԵԼՈՒԹՅԱՆԸ »",
                    "image": "https://mashtoz.org/storage/files/bc3c1152f4152e35ccc9091e846c511c.jpg",
                    "body": "",
                    "author": "",
                    "sharurl": ""
                  }
                }
              },
              "2682": {
                "id": 2682,
                "title": "test library title",
                "image": "https://mashtoz.org/storage/img-not-found.png",
                "body": "",
                "video_link": null,
                "explanation": "",
                "author": "test library",
                "sharurl": "https://mashtoz.org/%D4%B3%D6%80%D5%A1%D5%A4%D5%A1%D6%80%D5%A1%D5%B6/%D5%A1%D5%B2%D5%B8%D5%A9%D6%84/test-library-title",
                "content": {
                  "2683": {
                    "id": 2683,
                    "title": "test library sub",
                    "image": "https://mashtoz.org/storage/img-not-found.png",
                    "body": "",
                    "video_link": null,
                    "explanation": "",
                    "author": "test library sub",
                    "sharurl": "https://mashtoz.org/%D4%B3%D6%80%D5%A1%D5%A4%D5%A1%D6%80%D5%A1%D5%B6/%D5%A1%D5%B2%D5%B8%D5%A9%D6%84/test-library-sub"
                  }
                }
              }
            }
          },
          "lessons": [
            {
              "id": 19,
              "image": "https://mashtoz.org/storage/files/calcio-storico-corteo.jpg",
              "title": "0008 - Բառարան. Ժամանակի չափման միավորները, Տարվա ամիսները, Շաբաթվա օրերը",
              "link": "https://www.youtube.com/watch?v=-6-7juA9GLg&list=PLKvKkiEoRUy_Hm8T1QP_VL2-2Bdy3k5Wk&index=8",
              "number": "08"
            }
          ],
          "encyclopedias": [
            "Է",
            "Պ",
            "Փ"
          ],
          "audiolibraries": "Ե",
          "dialects": [
            "Ո",
            "Հ",
            "Թ"
          ]
        }
      }""";

bool deepEquals(dynamic object1, dynamic object2) {
  if (object1 == object2) return true;

  if (object1 is Map && object2 is Map) {
    if (object1.length != object2.length) return false;
    for (var key in object1.keys) {
      if (!object2.containsKey(key) || !deepEquals(object1[key], object2[key])) {
        return false;
      }
    }
    return true;
  } else if (object1 is List && object2 is List) {
    if (object1.length != object2.length) return false;
    for (var i = 0; i < object1.length; i++) {
      if (!deepEquals(object1[i], object2[i])) {
        return false;
      }
    }
    return true;
  } else {
    return object1 == object2;
  }
}
