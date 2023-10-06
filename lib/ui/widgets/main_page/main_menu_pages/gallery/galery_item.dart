import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mashtoz_flutter/config/palette.dart';
import 'package:mashtoz_flutter/domens/models/book_data/gallery_data.dart'
    as Gallery;
import 'package:mashtoz_flutter/domens/repository/book_data_provdier.dart';
import 'package:mashtoz_flutter/ui/widgets/helper_widgets/menuShow.dart';

class GalleryItem extends StatefulWidget {
  const GalleryItem({Key? key}) : super(key: key);

  @override
  State<GalleryItem> createState() => _GalleryItemState();
}

class _GalleryItemState extends State<GalleryItem> {
  bool isExpanded = false;
  //void open(BuildContext context, final int index) {
  // Navigator.push(
  //   context,
  //   MaterialPageRoute(
  //     builder: (context) => GalleryPhotoViewWrapper(
  //       galleryItems: galleryItems,
  //       backgroundDecoration: const BoxDecoration(
  //         color: Color.fromRGBO(31, 31, 31, 0.9),
  //       ),
  //       initialIndex: index,
  //     ),
  //   ),
  // );
  //}

  Future<List<dynamic>>? galleryFuture;
  final bookDataProvider = BookDataProvider();

  @override
  void initState() {
    galleryFuture = bookDataProvider.fetchGalleryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(slivers: [
          SliverAppBar(
            title: Text(
              'Պատկերադարան',
              style: TextStyle(
                  fontSize: 16.0,
                  letterSpacing: 1,
                  fontFamily: 'GHEAGrapalat',
                  fontWeight: FontWeight.w700,
                  color: Palette.appBarTitleColor),
            ),
            pinned: false,
            floating: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Palette.appBarTitleColor,
              ),
            ),
            expandedHeight: 73,
            backgroundColor: Palette.textLineOrBackGroundColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Color.fromRGBO(25, 4, 18, 1)),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: MenuShow(),
              ),
            ],
          ),
          SliverFillRemaining(
            child: SingleChildScrollView(
              child: FutureBuilder<List<dynamic>>(
                future: galleryFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                        child: Center(
                            child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: Palette.main,
                    )));
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Text('Error');
                    } else if (snapshot.hasData) {
                      var data = snapshot.data;

                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            dynamic newData = data?[index];
                            dynamic galery = newData[1];
                            print(galery.runtimeType);
                            return ExpansionTile(
                              title: Container(
                                child: Text(
                                  '${newData[0]}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'GHEAGrapalat',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.0,
                                      color: Color.fromRGBO(113, 141, 156, 1)),
                                ),
                              ),
                              onExpansionChanged: (bool expandint) =>
                                  setState(() => this.isExpanded = expandint),
                              leading:
                                  SvgPicture.asset('assets/images/line24.svg'),
                              controlAffinity: ListTileControlAffinity.leading,
                              children: [
                                Container(
                                  color: Color.fromRGBO(246, 246, 246, 1),
                                  child: Stack(
                                    children: [
                                      GridView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: (galery is Gallery.Gallery)
                                            ? galery.images?.length
                                            : 0,
                                        itemBuilder: (context, index) {
                                          print(galery);
                                          return Container(
                                              color: Color.fromRGBO(
                                                  246, 246, 246, 1),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          GalleryView(
                                                        url: (galery is Gallery
                                                                .Gallery)
                                                            ? galery
                                                                .images![index]
                                                                .img
                                                            : galery,
                                                        imagesUrl: (galery
                                                                is Gallery
                                                                .Gallery)
                                                            ? galery.images
                                                            : [],
                                                        currentIndex: index,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  child: (galery
                                                          is Gallery.Gallery)
                                                      ? CachedNetworkImage(
                                                          placeholder: (context,
                                                                  url) =>
                                                              Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                color: Palette
                                                                    .main,
                                                              )),
                                                          imageUrl:
                                                              '${galery.images?[index].img}')
                                                      : Text(
                                                          'Այս բաժնում նկարներ չկան',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                ),
                                              ));
                                        },
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 20.0,
                                        ),
                                      ),
                                      if (galery is List<dynamic>)
                                        Positioned.fill(
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Center(
                                                  child: Text(
                                                'Այս բաժնում նկարներ չկան',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Palette.barColor),
                                              ))),
                                        ),
                                    ],
                                  ),
                                ),

                                // if(galery is  Gallery.Gallery)  Container(
                                //     padding: EdgeInsets.only(
                                //         left: 25.0, right: 25.0),
                                //     color: Color.fromRGBO(255, 255, 255, 1),
                                //     width: double.infinity,
                                //     height: 49,
                                //     child: Row(
                                //       children: [
                                //         InkWell(
                                //           onTap: () async {
                                //             print('kisvel');
                                //             await Share.share(
                                //                 (galery is Gallery.Gallery)
                                //                     ? galery.images![index].img
                                //                     : 'empty');
                                //             // showDialog
                                //             //     context: context,
                                //             //     barrierDismissible: true,
                                //             //     builder: (
                                //             //       context,
                                //             //     ) =>
                                //             //         SaveShowDialog(
                                //             //           isShow: false,
                                //             //         ));
                                //           },
                                //           child: Row(
                                //             children: [
                                //               SvgPicture.asset(
                                //                   'assets/images/այքըններ.svg'),
                                //               const SizedBox(width: 6),
                                //               const Text('Կիսվել')
                                //             ],
                                //           ),
                                //         ),
                                //         Spacer(),
                                //         InkWell(
                                //           onTap: () {
                                //             // var data = <String, dynamic>{
                                //             //   'type': 'audiolibraries',
                                //             //   'type_id': dataCharacter?.id,
                                //             //   'customer_id': 38,
                                //             // };
                                //             // setState(() {
                                //             //   userIsSign(data);
                                //             // });
                                //             print('share anel paterin');
                                //             //    showDialog(
                                //             // context: context,
                                //             // barrierDismissible: false,
                                //             // builder: (
                                //             //   context,
                                //             // ) =>
                                //             //     SaveShowDialog(isShow: true));
                                //           },
                                //           child: Row(
                                //             children: [
                                //               SvgPicture.asset(
                                //                   'assets/images/վելացնել1.svg'),
                                //               const SizedBox(width: 6),
                                //               const Text('Պահել'),
                                //             ],
                                //           ),
                                //         ),
                                //       ],
                                //     )),
                              ],
                            );
                          });
                    } else {
                      return const Text('Empty data');
                    }
                  } else {
                    return Text('State: ${snapshot.connectionState}');
                  }
                },
              ),
            ),
          )

          // SliverFillRemaining(
          //     child: GridView.builder(
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2,
          //     mainAxisSpacing: 20.0,
          //   ),
          //   shrinkWrap: true,
          //   scrollDirection: Axis.vertical,
          //   itemCount: galleryItems.length,
          //   itemBuilder: (context, index) {
          //     Gellerys gallery = galleryItems[index];
          //     print(gallery.resource);
          //     // return Text('data');
          //     return GalleryExampleItemThumbnail(
          //       galleryExampleItem: galleryItems[index],
          //       onTap: () {
          //         open(context, index);
          //       },
          //     );
          //   },
          // )),

          //       ],
          //     ),
          //   );
          // }
        ]));
  }
}

class GalleryView extends StatefulWidget {
  final String url;

  final List<Gallery.Image>? imagesUrl;
  final int currentIndex;

  const GalleryView({
    Key? key,
    required this.url,
    required this.imagesUrl,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  int? _currnetInex;
  bool isShowCanc = false;
  bool isShowPlay = false;
  bool isShowFullScreen = false;

  CarouselController? _pageController;

  @override
  void initState() {
    _currnetInex = widget.currentIndex;
    _pageController = CarouselController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(31, 31, 31, 0.9),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(14, 14, 14, 0.7),
        leading: Container(
          width: 0.1,
          height: 0.1,
        ),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isShowCanc = false;
                  isShowFullScreen = false;
                  isShowPlay = !isShowPlay;
                });
              },
              icon: SvgPicture.asset(
                'assets/images/Play 1.svg',
                color: isShowPlay ? Palette.whenTapedButton : null,
              )),
          IconButton(
              onPressed: () {
                setState(() {
                  isShowCanc = false;
                  isShowFullScreen = !isShowFullScreen;
                  isShowPlay = false;
                });
              },
              icon: SvgPicture.asset(
                'assets/images/Full screen 1.svg',
                color: isShowFullScreen ? Palette.whenTapedButton : null,
              )),
          IconButton(
              onPressed: () {
                setState(() {
                  isShowCanc = !isShowCanc;
                  isShowFullScreen = false;
                  isShowPlay = false;
                });
              },
              icon: SvgPicture.asset(
                'assets/images/Canc.svg',
                color: isShowCanc ? Palette.whenTapedButton : null,
              )),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset('assets/images/Close.svg')),
        ],
      ),
      body: Center(
        child: Container(
          color: Color.fromRGBO(51, 51, 51, 1),
          child: Stack(
            children: [
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Stack(
      children: <Widget>[
        Positioned.fill(
            top: 35,
            left: isShowFullScreen ? 0.0 : 46,
            right: isShowFullScreen ? 0.0 : 64,
            bottom: 130,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                  color: Color.fromRGBO(51, 51, 51, 1),
                  child: Stack(
                    children: [
                      Align(
                          alignment: Alignment.topCenter,
                          child: _buildPhotoViewGallery()),
                      !isShowFullScreen
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          _pageController?.previousPage(
                                              duration:
                                                  Duration(milliseconds: 500));
                                        },
                                        icon: SvgPicture.asset(
                                          'assets/images/Vector 96.svg',
                                          fit: BoxFit.none,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          print('dadas');
                                          _pageController?.nextPage(
                                              duration:
                                                  Duration(milliseconds: 500));
                                        },
                                        icon: SvgPicture.asset(
                                          'assets/images/Vector 97.svg',
                                          fit: BoxFit.none,
                                        )),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              height: 0.1,
                              width: 0.1,
                            )
                    ],
                  )),
            )),
        isShowCanc
            ? Positioned.fill(
                top: 400,
                bottom: 25.0,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildIndicator()))
            : Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 0.1,
                  ),
                ),
              ),
      ],
    );
  }

  CarouselSlider _buildPhotoViewGallery() {
    return CarouselSlider.builder(
      itemCount: widget.imagesUrl!.length,
      itemBuilder: (ctx, index, realIndex) {
        return Container(
          padding: EdgeInsets.only(bottom: 50),
          child: CachedNetworkImage(imageUrl: widget.imagesUrl![index].img),
        );
      },
      carouselController: _pageController,
      options: CarouselOptions(
          height: 400,
          autoPlay: isShowPlay,
          autoPlayInterval: Duration(seconds: 2),
          viewportFraction: 1,
          enableInfiniteScroll: false,
          initialPage: _currnetInex!,
          onPageChanged: (int value, CarouselPageChangedReason) {
            _currnetInex = value;
          }),
    );
  }

  Widget _buildIndicator() {
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: _buildImageCarouselSlider(),
    );
  }

  Widget _buildImageCarouselSlider() {
    return CarouselSlider.builder(
      itemCount: widget.imagesUrl?.length,
      itemBuilder: (ctx, index, realIdx) {
        return PortfolioGalleryImageWidget(
            imagePath: widget.imagesUrl![index].img,
            onImageTap: () => _pageController!.jumpToPage(index));
      },
      options: CarouselOptions(
          viewportFraction: 0.21,
          enlargeCenterPage: false,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          autoPlay: false,
          height: 100,
          initialPage: _currnetInex!),
    );
  }
}

class PortfolioGalleryImageWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onImageTap;

  const PortfolioGalleryImageWidget(
      {Key? key, required this.imagePath, required this.onImageTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(14, 14, 14, 0.7),
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Material(
          child: Ink.image(
            image: NetworkImage(imagePath),
            fit: BoxFit.cover,
            child: InkWell(onTap: onImageTap),
          ),
        ),
      ),
    );
  }
}
