import 'package:flutter/material.dart';

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
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: urls.length,
              itemBuilder: (context, index) {
                return Stack(
                  alignment: Alignment.center,
                  fit: StackFit.loose,
                  children: [
                    InteractiveViewer(
                        
                        constrained: true,
                        child: Image.network(
                          urls[index],
                          fit: BoxFit.contain,
                          height: 800,
                          width: double.infinity,
                          // width: double.infinity,
                        )

                        // fullScreenDoubleTapZoomScale: 0,
                        // heroAnimationTag: 'tag',
                        ),
                    Positioned(
                      bottom: 50,

                      child: Container(
                        height: 40,
                        width: 50,
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
                );
              },
              onPageChanged: (value) => setState(() => currentIndex = value),
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
