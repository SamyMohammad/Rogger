import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:photo_view/photo_view.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/widgets/loading_indicator.dart';

class ProductImagesView extends StatefulWidget {
  const ProductImagesView(
      {super.key, required this.urls, required this.initialIndex});

  final List<String> urls;
  final int initialIndex;

  @override
  State<ProductImagesView> createState() => _ProductImagesViewState();
}

class _ProductImagesViewState extends State<ProductImagesView> {
  int currentIndex = 0;
  List<String> urls = [];
  PageController _pageController = PageController();

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: [SystemUiOverlay.bottom]);
    Future.delayed(Duration.zero, () {
      urls.addAll(widget.urls.where((e) => e != 'VIDEO'));
      currentIndex = widget.initialIndex;
      _pageController.jumpToPage(currentIndex);
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: SystemUiOverlay.values);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: urls.length,
            itemBuilder: (context, index) {
              return SwipeDetector(
                onSwipeDown: ((offset) {
                  RouteManager.pop();
                }),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl: urls[index],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Center(
                        child: LoadingIndicator(),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.8),
                    ),
                    // PhotoView.customChild(
                    //   child: Image.network('https://example.com/your_image_url.jpg'),
                    //   minScale: PhotoViewComputedScale.contained * 0.8,
                    //   maxScale: PhotoViewComputedScale.covered * 2,
                    //   gestureDetectorBehavior: (context, child, controllerValue) {
                    //     return CustomPhotoViewGestureDetector(
                    //       behavior: HitTestBehavior.opaque,
                    //       child: child,
                    //       onScaleStart: controllerValue.startScale,
                    //       onScaleUpdate: controllerValue.updateScale,
                    //       onScaleEnd: controllerValue.endScale,
                    //       enablePinchZoom: true, // Enable pinch-to-zoom
                    //       enableDoubleTapZoom: false, // Disable double-tap zoom
                    //     );
                    //   },
                    // ),
                    Container(
                      child: PhotoView(
                        heroAttributes: PhotoViewHeroAttributes(tag: 'tag'),
                        imageProvider: NetworkImage(urls[index]),
                        gestureDetectorBehavior: HitTestBehavior.translucent,
                        minScale: PhotoViewComputedScale.contained * 0.8,
                        maxScale: PhotoViewComputedScale.covered * 2,
                      ),
                    ),
                    // WidgetZoom(
                    //   heroAnimationTag: 'tag',
                    //   zoomWidget: Image.network(
                    //     urls[index],
                    //     fit: BoxFit.fill,
                    //     height: 500,
                    //     width: double.infinity,
                    //   ),
                    // ),
                  ],
                ),
              );
            },
            onPageChanged: (value) => setState(() => currentIndex = value),
          ),
          Positioned(
            bottom: 6,
            width: 80,
            left: MediaQuery.sizeOf(context).width / 2 - 40,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  '${urls.length} /${currentIndex + 1}',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              //  Row(
              //   children: [
              //     InkWell(
              //       onTap: () => Navigator.pop(context),
              //       child: Icon(
              //         Icons.close,
              //         color: Colors.white,
              //       ),
              //     ),
              //     Expanded(
              //       child: Text(
              //         '${urls.length} /${currentIndex + 1}',
              //         style: TextStyle(
              //             color: Colors.white, fontWeight: FontWeight.bold),
              //         textAlign: TextAlign.center,
              //       ),
              //     ),
              //     Icon(
              //       Icons.close,
              //       color: Colors.transparent,
              //     )
              //   ],
              // ),
            ),
          ),
        ],
      ),
      // Padding(
      //   padding: const EdgeInsets.all(10.0),
      //   child: Column(
      //     children: [
      //       SizedBox(height: topDevicePadding + 32),
      //       Row(
      //         children: [
      //           InkWell(
      //             onTap: () => Navigator.pop(context),
      //             child: Icon(
      //               Icons.close,
      //               color: Colors.white,
      //             ),
      //           ),
      //           Expanded(
      //             child: Text(
      //               '${urls.length} / ${currentIndex + 1}',
      //               style: TextStyle(color: Colors.white),
      //               textAlign: TextAlign.center,
      //             ),
      //           ),
      //           Icon(
      //             Icons.close,
      //             color: Colors.transparent,
      //           )
      //         ],
      //       ),
      //       Expanded(
      //         child: PageView.builder(
      //           controller: _pageController,
      //           itemCount: urls.length,
      //           itemBuilder: (context, index) {
      //             return InteractiveViewer(
      //               child: Image.network(urls[index]),
      //             );
      //           },
      //           onPageChanged: (value) => setState(() => currentIndex = value),
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
