import 'package:flutter/material.dart';
import 'package:silah/core/router/router.dart';

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
  double _scale = 1.0;
  Offset _offset = Offset.zero;
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 12.0),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: urls.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      alignment: Alignment.center,
                      fit: StackFit.loose,
                      children: [
                        SizedBox(
                          // height: 800,
                          child: InteractiveViewer(
                            constrained: true,
                            child: Image.network(
                              urls[index],
                              fit: BoxFit.contain,
                              height: 800,
                              width: double.infinity,
                            ),
                          ),
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
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  onPageChanged: (value) =>
                      setState(() => currentIndex = value),
                ),
              ),
            ],
          ),
          Positioned(
            top: 50,
            right: 10,
            child: IconButton(
              onPressed: () => RouteManager.pop(),
              // padding: EdgeInsets.all(-20),
              icon: Icon(
                color: Colors.white,
                Icons.arrow_back_ios_new_sharp,
                weight: 5,
              ),
            ),
          )
        ],
      ),
    );
  }
}
