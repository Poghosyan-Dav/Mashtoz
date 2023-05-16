import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:mashtoz_flutter/domens/data_providers/session_data_provider.dart';
import 'package:mashtoz_flutter/domens/models/book_data/data.dart';

class InfoDataProvider {
  final sessionDataProvider = SessionDataProvider();

  //About_Us  //Donation
  Future<Data> getInfoAbaoutUs_Donation(String url) async {
    Data? data;

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // var body = json.decode(response.body);
      // var data = body['data'];
      if (response.statusCode == 200) {
        data = Data.fromJson(jsonDecode(response.body)['data']);
        inspect(data);
        // return (data as List).map((e) => Data.fromJson(e)).toList();

      } else {
        print("failed");
      }
    } catch (e) {
      print(e);
    }
    return data!;
  }

  // Future<Data> getInfoDonation() async {
  //   Data? data;
  //   var token = await sessionDataProvider.readToken();
  //   try {
  //     var response = await http.get(
  //       Uri.parse(Api.donation),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'Authorization': 'bearer $token'
  //       },
  //     );
  //     // var body = json.decode(response.body);
  //     // var data = body['data'];
  //     if (response.statusCode == 200) {
  //       data = Data.fromJson(jsonDecode(response.body)['data']);
  //       inspect(data);
  //       // return (data as List).map((e) => Data.fromJson(e)).toList();

  //     } else {
  //       print("failed");
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   return data!;
  // }
}
