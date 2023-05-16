import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mashtoz_flutter/domens/models/book_data/data.dart';
import 'package:mashtoz_flutter/domens/repository/info_data_provider.dart';
import 'package:mashtoz_flutter/globals.dart';
import 'package:mashtoz_flutter/ui/widgets/helper_widgets/menuShow.dart';
import 'package:mashtoz_flutter/ui/widgets/helper_widgets/size_config.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/main_menu_pages/contact_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/palette.dart';

class InfoPage extends StatefulWidget {
  final bool isShow;
  const InfoPage({Key? key, required this.isShow}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState(isShow: isShow);
}

class _InfoPageState extends State<InfoPage> {
  final infoDataProvider = InfoDataProvider();
  final bool isShow;

  _InfoPageState({required this.isShow});

  Future<Data>? futureInfoAbautUs;
  Future<Data>? futureInfoDonation;
  @override
  void initState() {
    futureInfoAbautUs = infoDataProvider.getInfoAbaoutUs_Donation(Api.abaoutUs);
    futureInfoDonation =
        infoDataProvider.getInfoAbaoutUs_Donation(Api.donation);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<Data>(
        future: isShow ? futureInfoAbautUs : futureInfoDonation,
        builder: (context, snapshot) {
          var characters = snapshot.data;
          if (snapshot.hasData) {
            return SafeArea(
              child: Scaffold(
                  backgroundColor: isShow
                      ? const Color.fromRGBO(117, 99, 111, 1)
                      : const Color.fromRGBO(226, 224, 224, 1),
                  appBar:  AppBar(
                    leading: IconButton(onPressed: ()=>Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back_ios_new_outlined),color:isShow? Colors.white:const Color.fromRGBO(117, 99, 111, 1),),
                    flexibleSpace: Container(
                      margin: const EdgeInsets.only(left: 50),
                      height: double.infinity,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '${characters?.title}',
                            style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 1,
                                fontFamily: 'GHEAGrapalat',
                                fontWeight: FontWeight.w700,
                                color: isShow
                                    ? Palette.textLineOrBackGroundColor
                                    : const Color.fromRGBO(117, 99, 111, 1)),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ),
                    backgroundColor: isShow
                        ? const Color.fromRGBO(117, 99, 111, 1)
                        : const Color.fromRGBO(226, 224, 224, 1),
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    systemOverlayStyle: const SystemUiOverlayStyle(
                        statusBarColor: Color.fromRGBO(25, 4, 18, 1)),
                    actions: [
                      const Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: MenuShow()),
                    ],
                  ),
                  body:

                ListView(
                  children: [
                    isShow
                        ? Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            width: 120.0,
                            height: 120.0,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: CachedNetworkImage(
                                imageUrl: "${characters?.image!}",
                                maxHeightDiskCache: 120,
                                maxWidthDiskCache:120,
                                fit: BoxFit.cover,
                                errorWidget: (BuildContext context,String exception,error)
                                {
                                  return const Icon(Icons.error_sharp);
                                },
                              ),
                            ),
                          ),
                        )
                        : Container(),
                    Container(
                      padding: const EdgeInsets.only(
                          right: 20.0, left: 20.0),
                      child: Html(
                        shrinkWrap: true,
                        onLinkTap: (url, _, __, ___) async{
                          print('Opening $url...');
                          if(url!=null){
                            if(url.contains('http') || url.contains('https') ){
                              if (await canLaunch(url)) {
                                await launch(
                                  url,
                                );
                              } else {
                                throw 'Could not launch $url';
                              }
                            }
                            if(url.contains('page:2')){
                              print('page2');
                              Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const Contact()));
                            }


                          }
                        },
                        data:"${characters?.body}",
                        style: {
                          'p': Style(
                           fontSize:  FontSize(17),
                            textAlign: TextAlign.start
                          ),
                        },
                      ),
                    ),
                    isShow &&
                        SizeConfig.orentation ==
                            Orientation.portrait
                        ? const SizedBox(height: 30)
                        : isShow
                        ? const SizedBox(height: 300)
                        : const SizedBox(height: 0.1),
                    isShow
                        ? Container(
                      padding: const EdgeInsets.only(top: 20),
                      alignment: const Alignment(0.0, -1.0),
                      color:
                      const Color.fromRGBO(226, 224, 224, 1),
                      height: 100,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                  fontFamily:
                                  'GHEAGpalat',
                                  fontWeight:
                                  FontWeight.w400,
                                  letterSpacing: 1.2,
                                  fontSize: 14,
                                  color: Colors.black),
                              children: <TextSpan>[
                                const TextSpan(
                                  text:
                                  'Հուսով եմ, այս կայքի էջերը օգտակար\n',
                                ),
                                const TextSpan(
                                  text:
                                  'են լինում Ձեզ։\n',
                                ),
                                const TextSpan(
                                    text:
                                    'Որևէ հարցով, '),
                                TextSpan(
                                  text: ' գրեցեք ինձ:',
                                  style: const TextStyle(
                                      fontWeight:
                                      FontWeight
                                          .bold),
                                  recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder:
                                                  (_) =>
                                                  const Contact()));
                                    },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                        : Container(),
                    const SizedBox(height: 30),
                  ],
                )
              ),
            );
          } else {
            return Container(
              child: const Center(
                  child: CircularProgressIndicator(
                color: Palette.main,
              )),
            );
          }
        },
      
    );
  }
}
//  FutureBuilder<Data?>(
//                 future: futureInfo,
//                 builder: (context, snapshot) {
//                   var characters = snapshot.data;

//                   if (snapshot.hasData) {
//                     return Column(
//                       children: [
//                         ListView(
//                           scrollDirection: Axis.vertical,
//                           shrinkWrap: true,
//                           padding: EdgeInsets.all(12.0),
//                           physics: NeverScrollableScrollPhysics(),
//                           children: [
//                             Text(
//                               '${characters!.body}',
//                               style: TextStyle(
//                                   fontFamily: 'GHEAGpalat',
//                                   fontWeight: FontWeight.w400,
//                                   letterSpacing: 1.2,
//                                   fontSize: 14,
//                                   color: Palette.textLineOrBackGroundColor),
//                             ),
//                           ],
//                         ),
//                       ],
//                     );
//                   } else {
//                     return Container(
//                       child: Center(child: CircularProgressIndicator()),
//                     );
//                   }
//                 },
//               )
