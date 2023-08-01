import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mashtoz_flutter/domens/models/book_data/category_lsit.dart';
import 'package:mashtoz_flutter/domens/repository/book_data_provdier.dart';
import 'package:mashtoz_flutter/ui/widgets/helper_widgets/menuShow.dart';
import 'package:mashtoz_flutter/ui/widgets/helper_widgets/save_show_dialog.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../config/palette.dart';
import '../../../../domens/models/book_data/content_list.dart';
import '../../../../domens/repository/user_data_provider.dart';
import '../../../../globals.dart';
import '../../../../tab_provider.dart';
import 'book_inherited_widget.dart';
import 'book_read_screen.dart';

class BookInitalScreen extends StatefulWidget {
  const BookInitalScreen({Key? key, this.category, this.isFromHomaPage,this.book,required this.idLib,required this.categoryID})
      : super(key: key);
  final BookCategory? category;
  final Content? book;
  final bool? isFromHomaPage;
  final String idLib;
  final String categoryID;

  @override
  State<BookInitalScreen> createState() =>
      _BookInitalScreenState(book: book, category: category, idLib: idLib,isFromHomePage: isFromHomaPage,categoryID:categoryID);
}

class _BookInitalScreenState extends State<BookInitalScreen> {
  _BookInitalScreenState({ this.book, this.category, required this.idLib,this.isFromHomePage,required this.categoryID});
  final userDataProvider = UserDataProvider();
  final bookDataProvider = BookDataProvider();
  Content? book;
  bool isShowingDialog = false;
  final bool? isFromHomePage;
  final String idLib;
  final String categoryID;
  final BookCategory? category;
  bool isValid = false;
  int? custemerId;
  @override
  void initState() {

    userDataProvider.fetchUserInfo().then((value) => custemerId = value?.id);
    if(idLib.isNotEmpty && categoryID.isNotEmpty) findBookFromPushNotification();
    if(idLib.isNotEmpty && !idLib.contains('null') ) findBook();

    super.initState();
  }
  void findBook()async{
    bookDataProvider.updateHomeAfterPushNotification(context);
    await bookDataProvider.getCategoryLists(Api.categoryListUrl,false).then((value) {
      for (var nv in value) {
        bookDataProvider.getLibraryBooksByCategory(nv.id!, false).then((value) {
          for (var nValue in value!) {
            if (nValue.id == int.parse('$idLib')) {
              book = nValue;
              setState(() {});
              break;
            }
          }
        });
      }
    });

  }

  void findBookFromPushNotification(){
    bookDataProvider.updateHomeAfterPushNotification(context);
    bookDataProvider.getLibraryBooksByCategory(int.parse('$categoryID'),true).then((value) {

      for (var nValue in value!) {
        if (nValue.id == int.parse('$idLib')) {
          book = nValue;
          setState(() {});
          break;
        }
      }
    });


  }
//   Future<void> getLibrarayYbooksById(int idLib) async {
//     List<BookCategory> categoryList = await bookDataProvider.getCategoryLists(Api.categoryListUrl);
//     bool isFound = false;
// try{
//   for (var nv in categoryList) {
//     print("Iddddddddd${nv.id}");
//     List<dynamic>? librarayYbooks = await bookDataProvider.getLibrarayYbooksByCategory(nv.id!);
//     for (var nValue in librarayYbooks!) {
//       if ("(${nValue.id})".toString().contains(idLib.toString())) {
//         book = nValue;
//         isFound = true;
//         break;
//       }
//     }
//     if(isFound){
//       break;
//     }
//   }
//   setState(() {});
// }catch(e){
//   if(isFound){
//     //break;
//   }
// }

  //}
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    if ( book?.content != null ) {
      var save_id = widget.book?.id ??  book?.id;
      return Scaffold(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Transform(
                transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
                child:isFromHomePage==true? null:Text(
                  '${category?.categoryTitle??''}',
                  style: const TextStyle(
                      fontSize: 16,
                      letterSpacing: 1,
                      fontFamily: 'GHEAGrapalat',
                      fontWeight: FontWeight.w700,
                      color: Palette.appBarTitleColor),
                ),
              ),
              leading: SizedBox(
                width: 8,
                height: 14,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Palette.appBarTitleColor,
                  ),
                ),
              ),
              expandedHeight: 73,
              backgroundColor: Palette.textLineOrBackGroundColor,
              elevation: 0,
              automaticallyImplyLeading: false,
              systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Color.fromRGBO(25, 4, 18, 1)),
              actions: [
                const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: MenuShow(),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: mediaQuery.width,
                    height: 300,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                            top: 90,
                            left: 0,
                            child: Container(
                                width: mediaQuery.width,
                                height: 285,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(164, 171, 189, 1),
                                ))),
                        Container(
                            child: Center(
                          child: SizedBox(
                              width: 168,
                              height: mediaQuery.height / 2,
                              child: Stack(children: <Widget>[
                                Positioned(
                                    top: 0,
                                    left: 0,
                                    child: Container(
                                        width: 160,
                                        height: 194,
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              255, 255, 255, 1),
                                          border: Border.all(
                                            color:
                                                const Color.fromRGBO(51, 51, 51, 1),
                                            width: 01,
                                          ),
                                        ))),
                                Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      width: 144,
                                      height: 174,
                                      child: CachedNetworkImage(
                                        imageUrl: book!.image!,
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ])),
                        )),
                        Positioned.fill(
                          top: 200,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                      child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      child: Text(
                                        "${book?.title}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Color.fromRGBO(25, 4, 18, 1),
                                          fontSize: 12,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "GEHAGrapalat",
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                  )),
                                  Positioned.fill(
                                    top: 50,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Container(
                                            child: Text(
                                              book?.author ?? '',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    25, 4, 18, 1),
                                                fontSize: 12,
                                                letterSpacing: 1,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'GHEAGrapalat',
                                                height: 1,
                                              ),
                                              maxLines: MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      360
                                                  ? 2
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      color: const Color.fromRGBO(246, 246, 246, 1),
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      height: 49,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              await Share.share(book!.sharurl!);
                              print('kisvel');
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/images/այքըններ.svg'),
                                const SizedBox(width: 6),
                                const Text(
                                  'Կիսվել',
                                  style: TextStyle(
                                      fontFamily: 'GHEAGrapalat',
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 1),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {

                                userIsSign(context);

                            },
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/images/վելացնել1.svg'),
                                const SizedBox(width: 6),
                                const Text('Պահել',
                                    style: TextStyle(
                                        fontFamily: 'GHEAGrapalat',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 1)),
                              ],
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(height: 14),
                  const Center(
                      child: Text(
                    'Բովանդակություն',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  )),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ListView.builder(
                    itemCount: book?.content?.length,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final bovandak =
                          book?.content?.values.map((e) => e).toList();
                      final subBovandak = bovandak?[index]
                          .content
                          ?.values
                          .map((e) => e)
                          .toList();
                      if (bovandak?[index].content != null) {
                        return Column(
                          children: [
                            ExpansionTile(
                              collapsedIconColor:
                                  const Color.fromRGBO(250, 147, 114, 1),
                              textColor: const Color.fromRGBO(84, 112, 126, 1),
                              iconColor: Palette.whenTapedButton,
                              childrenPadding:
                                  const EdgeInsets.only(left: 20.0, right: 20.0),
                              title:GestureDetector(
                      onTap:(){

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  BookReadScreen(
                                    isFromHomePage: widget.isFromHomaPage,
                                    readScreen:
                                    bovandak?[index],
                                    isShowTitle:
                                    true,
                                    saveId: save_id,
                                  ),
                            ),
                          );
                          print('Coco');

                      },
                                child: Text(
                                  '${bovandak?[index].title}',
                                  style: const TextStyle(
                                    fontFamily: 'GHEAGrapalat',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(84, 112, 126, 1),
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              // leading: Text('0${index+1}'),
                              tilePadding:
                                  const EdgeInsets.only(right: 20.0, left: 40.0),
                                initiallyExpanded:true,
                              children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: subBovandak?.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index2) {
                                      //   print("SubContent:::${subContent}");

                                      var subContent = subBovandak?[index2]
                                          .content
                                          ?.values
                                          .map(
                                            (e) => e,
                                          )
                                          .toList();
                                      return subBovandak?[index2].content !=
                                              null
                                          ? Column(
                                              children: [
                                                ExpansionTile(
                                                  initiallyExpanded:true,
                                                  collapsedIconColor:
                                                      const Color.fromRGBO(
                                                          250, 147, 114, 1),
                                                  iconColor:
                                                      const Color.fromRGBO(
                                                          250, 147, 114, 1),
                                                  title: GestureDetector(
                                                    onTap:(){

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              BookReadScreen(

                                                                isFromHomePage: widget.isFromHomaPage,
                                                                readScreen:
                                                                subBovandak?[index2],
                                                                isShowTitle:
                                                                true,
                                                                saveId: save_id,
                                                              ),
                                                        ),
                                                      );
                                                      print('Coco');

                                                    },
                                                    child: Text(
                                                      '${subBovandak?[index2].title}',
                                                      style: const TextStyle(
                                                          color: Color.fromRGBO(
                                                              113, 141, 156, 1),
                                                          fontFamily:
                                                              'GHEAGrapalat',
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                  tilePadding: const EdgeInsets.only(
                                                      right: 20.0, left: 40.0),
                                                  children: [
                                                    ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            subContent?.length,
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemBuilder:
                                                            (context, index3) {
                                                          Content readContent =
                                                              subContent![
                                                                  index3];
                                                          return InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      BookReadScreen(
                                                                        saveId: save_id,
                                                                        isFromHomePage: widget.isFromHomaPage,
                                                                    readScreen:
                                                                        readContent,
                                                                    isShowTitle:
                                                                        true,
                                                                  ),
                                                                ),
                                                              );
                                                              print('Coco');
                                                            },
                                                            child: Container(
                                                              padding: const EdgeInsets
                                                                  .only(
                                                                      left:
                                                                          40.0,
                                                                      right:
                                                                          20.0),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      SvgPicture
                                                                          .asset(
                                                                              'assets/images/line24.svg'),
                                                                      const SizedBox(
                                                                          width:
                                                                              20.0),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          "${subContent[index3].title}",
                                                                          style: const TextStyle(
                                                                              fontFamily: 'GHEAGrapalat',
                                                                              fontSize: 14.0,
                                                                              fontWeight: FontWeight.w700,
                                                                              letterSpacing: 1),
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const Divider(
                                                                      height:
                                                                          20.0,
                                                                      thickness:
                                                                          1.0),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                  ],
                                                ),
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(
                                                          right: 15.0,
                                                          left: 15.0),
                                                  child: Divider(
                                                    thickness: 1,
                                                    height: 1.5,
                                                    color: Color.fromRGBO(
                                                        226, 224, 224, 1),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        BookReadScreen(
                                                          isFromHomePage: widget.isFromHomaPage,
                                                          readScreen:
                                                          subBovandak![index2],
                                                      isShowTitle: true,
                                                          saveId: save_id,
                                                    ),
                                                  ),
                                                );
                                                print('Coco');
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 20, left: 40.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    IntrinsicHeight(
                                                      child: Text(
                                                        '${subBovandak?[index2].title}',
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    ),
                                                    const Divider(),
                                                  ],
                                                ),
                                              ),
                                            );
                                    }),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                  right: 20.0, left: 20.0),
                              child: Divider(
                                thickness: 1,
                                height: 1.5,
                                color: Color.fromRGBO(226, 224, 224, 1),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 5.0),
                          child: Column(children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => BookReadScreen(
                                          isFromHomePage: widget.isFromHomaPage,
                                          readScreen: bovandak![index],
                                              isShowTitle: true,
                                          saveId: save_id,
                                            )));
                              },
                              child: Container(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${bovandak?[index].title}',
                                    style: const TextStyle(
                                        fontFamily: 'GHEAGrapalat',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromRGBO(84, 112, 126, 1)),
                                    textAlign: TextAlign.start,
                                    maxLines: 3,
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding:
                                  EdgeInsets.only(right: 15.0, left: 0.0),
                              child: Divider(
                                thickness: 1,
                                height: 1.5,
                                color: Color.fromRGBO(226, 224, 224, 1),
                              ),
                            ),
                            const SizedBox(height: 5.0),
                          ]),
                        );
                      }
                    }),
              ),
            ),
          ],
        ),
      );
    } else {
   return  book != null ?  BookReadScreen(
     isFromHomePage: widget.isFromHomaPage,
     readScreen: book,
        isShowTitle: true,
     saveId: widget.book?.id ?? book?.id,
      ):const Scaffold(body: Center(child:CircularProgressIndicator(color: Palette.main,),),);
    }
  }

  void userIsSign(BuildContext context) async {
    final tabProvider = Provider.of<TabProvider>(context,listen: false);

    var data = <String,dynamic>{};
    await   userDataProvider.fetchUserInfo().then((value) {

      data = <String,dynamic>{
        'type':
        'libraries',
        'type_id':
        book?.id,
        'customer_id':
        value?.id,
      };
    });
    if(data.isNotEmpty){
      tabProvider.updateSaveData(data,context);
      if (!isShowingDialog) {
        isShowingDialog = true;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => SaveShowDialog(
            data: data,
            isShow: false,
          ),
        ).then((value) {
          // Reset the flag when the dialog is dismissed
          isShowingDialog = false;
        });
      }
    }
  }
}

class GlobalBovandakLists extends StatefulWidget {
  GlobalBovandakLists({Key? key}) : super(key: key);

  @override
  State<GlobalBovandakLists> createState() => _GlobalBovandakListsState();
}

class _GlobalBovandakListsState extends State<GlobalBovandakLists> {
  @override
  Widget build(BuildContext context) {
    final book = context.read<ContentProvider>().bookContents;

    return book?.content != null
        ? ListView.builder(
            itemCount: book?.content?.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final bovandak = book?.content?.values.map((e) => e).toList();
              final subBovandak =
                  bovandak?[index].content?.values.map((e) => e).toList();
              if (bovandak?[index].content != null) {
                return Column(
                  children: [
                    ExpansionTile(
                      collapsedIconColor:
                          const Color.fromRGBO(250, 147, 114, 1),
                      textColor: const Color.fromRGBO(84, 112, 126, 1),
                      iconColor: Palette.whenTapedButton,
                      title: GestureDetector(
              onTap:(){

              Navigator.push(
              context,
              MaterialPageRoute(
              builder: (_) =>
              BookReadScreen(
              isFromHomePage:false,
              readScreen:
              bovandak?[index],
              isShowTitle:
              true,
                saveId: book?.id,
              ),
              ),
              );
              print('Coco');

              },
                        child: Text(
                          '${bovandak?[index].title}',
                          style: const TextStyle(
                            fontFamily: 'GHEAGrapalat',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(84, 112, 126, 1),
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      tilePadding: const EdgeInsets.only(right: 20.0, left: 40.0),
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: subBovandak?.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index2) {
                              //   print("SubContent:::${subContent}");
                              var subContent = subBovandak?[index2]
                                  .content
                                  ?.values
                                  .map(
                                    (e) => e,
                                  )
                                  .toList();
                              return subBovandak?[index2].content != null
                                  ? Column(
                                      children: [
                                        ExpansionTile(
                                          collapsedIconColor:
                                              const Color.fromRGBO(
                                                  250, 147, 114, 1),
                                          iconColor: const Color.fromRGBO(
                                              250, 147, 114, 1),
                                          title: GestureDetector(
                                            onTap:(){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      BookReadScreen(
                                                        isFromHomePage:false,
                                                        readScreen:
                                                        subBovandak?[index2],
                                                        isShowTitle:
                                                        true,
                                                        saveId:book?.id,
                                                      ),
                                                ),
                                              );
                                              print('Coco');

                                            },
                                            child: Text(
                                              '${subBovandak?[index2].title}',
                                              style: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      113, 141, 156, 1),
                                                  fontFamily: 'GHEAGrapalat',
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          tilePadding: const EdgeInsets.only(
                                              right: 20.0, left: 40.0),
                                          children: [
                                            ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: subContent?.length,
                                                physics:
                                                    const ClampingScrollPhysics(),
                                                itemBuilder: (context, index3) {
                                                  Content readContent =
                                                      subContent![index3];
                                                  return InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              BookReadScreen(
                                                                saveId:book?.id,
                                                            readScreen:
                                                                readContent,
                                                            isShowTitle: true,
                                                          ),
                                                        ),
                                                      );
                                                      print('Coco');
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.only(
                                                          left: 40.0,
                                                          right: 20.0),
                                                      height: 60,
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                              'assets/images/line24.svg'),
                                                          const SizedBox(width: 20.0),
                                                          Expanded(
                                                            child: Text(
                                                              "${subContent[index3].title}",
                                                              style: const TextStyle(
                                                                  fontFamily:
                                                                      'GHEAGrapalat',
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  letterSpacing:
                                                                      1),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ],
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              right: 15.0, left: 0.0),
                                          child: Divider(
                                            thickness: 1,
                                            height: 1.5,
                                            color: Color.fromRGBO(
                                                226, 224, 224, 1),
                                          ),
                                        ),
                                      ],
                                    )
                                  : InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => BookReadScreen(
                                              saveId:book?.id,
                                              readScreen: subBovandak![index2],
                                              isShowTitle: true,
                                            ),
                                          ),
                                        );
                                        print('Coco');
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(12.0),
                                        height: 60,
                                        child: Text(
                                          '${subBovandak?[index2].title}',
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    );
                            }),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 20.0, left: 20.0),
                      child: Divider(
                        thickness: 1,
                        height: 1.5,
                        color: Color.fromRGBO(226, 224, 224, 1),
                      ),
                    ),
                  ],
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 5.0),
                  child: Column(children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => BookReadScreen(
                                  saveId:book?.id,
                                      readScreen: bovandak![index],
                                      isShowTitle: true,
                                    )));
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${bovandak?[index].title}',
                            style: const TextStyle(
                                fontFamily: 'GHEAGrapalat',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(84, 112, 126, 1)),
                            textAlign: TextAlign.start,
                            maxLines: 3,
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 15.0, left: 0.0),
                      child: Divider(
                        thickness: 1,
                        height: 1.5,
                        color: Color.fromRGBO(226, 224, 224, 1),
                      ),
                    ),
                  ]),
                );
              }
            })
        : Container();
  }
}
