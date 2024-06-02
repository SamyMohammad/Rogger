import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:silah/ad/view.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/search/view.dart';
import 'package:silah/shared/stores/cubit.dart';
import 'package:silah/shared_cubit/category_cubit/cubit.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared_cubit/theme_cubit/cubit.dart';

class AdsSearchSection extends StatefulWidget {
  const AdsSearchSection({
    super.key,
    required this.cubit,
  });
  final StoresCubit cubit;

  @override
  State<AdsSearchSection> createState() => _AdsSearchSectionState();
}

class _AdsSearchSectionState extends State<AdsSearchSection> {
  @override
  Widget build(BuildContext context) {
    final categories =
        CategoryCubit.of(context).paidCategoriesModel?.categories;
    return Expanded(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => RouteManager.navigateTo(SearchView()),
            child: Container(
              width: MediaQuery.of(context).size.width * .7,
              padding: EdgeInsets.only(
                right: 14,
                top: 5,
                bottom: 5,
                left: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'البحث',
                    style: TextStyle(
                      color: kDarkGreyColor,
                    ),
                  ),
                  // ),
                  // Container(
                  //   padding: EdgeInsets.symmetric(
                  //     vertical: 5,
                  //     horizontal: 16,
                  //   ),
                  //   child: Icon(
                  //     FontAwesomeIcons.magnifyingGlass,
                  //     color: Colors.white,
                  //     size: 16,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: kAccentColor,
                  //     borderRadius: BorderRadius.circular(50),
                  //   ),
                  // ),
                ],
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    width: 2,
                    color: ThemeCubit.of(context).isDarkMode()
                        ? Colors.white
                        : kAccentColor,
                  )),
            ),
          ),
          SizedBox(
            height: 22,
          ),
          if (widget.cubit.ads?.data?.isNotEmpty ?? false)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                // color: kGreyColor,
                // boxShadow: primaryBoxShadow
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    20), // Match the border radius of the parent container

                child: CarouselSlider(
                  items: widget.cubit.ads?.data
                      ?.map((e) => GestureDetector(
                            onTap: () async {
                              if (await canLaunchUrl(
                                  Uri(path: e.url!, scheme: 'https'))) {
                                await launchUrl(
                                    Uri(path: e.url!, scheme: 'https'));
                              } else {
                                throw 'Could not launch $e.url';
                              }
                            },
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: e.fullImage!,
                                  fit: BoxFit.fitWidth,
                                  width: double.infinity,
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    getAsset("pro"),
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          ))
                      .toList(),
                  options: CarouselOptions(
                    viewportFraction: 1, // Adjust this value

                    autoPlay: true, // Enable auto-play
                    enlargeCenterPage:
                        true, // Increase the size of the center item
                    enableInfiniteScroll: true,

                    // Enable infinite scroll
                    onPageChanged: (index, reason) {
                      // Optional callback when the page changes
                      // You can use it to update any additional UI components
                    },
                  ),
                ),
              ),
            ),
          SizedBox(height: 22),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 22),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 14,
                childAspectRatio: 6 / 3,
              ),
              itemCount: categories?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    RouteManager.navigateTo(AddScreen(
                      category: categories![index],
                    ));
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                            // height: 120,

                            height: double.maxFinite,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(15),
                                color: kGreyColor,
                                boxShadow: primaryBoxShadow),
                            child: CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: categories?[index].image ?? '',
                            )),
                      ),
                      // Text(
                      //   categories?[index].name ?? '',
                      //   style: TextStyle(
                      //       color: Colors.white,
                      //       fontSize: 30,
                      //       fontWeight: FontWeight.bold,
                      //       fontFamily: 'IBMPlexSansArabic'),
                      // )
                    ],
                  ),
                );
              },
              // children: List.generate(
              //   4,
              //   (index) => GestureDetector(
              //     onTap: () => RouteManager.navigateTo(AddScreen()),
              //     child: Container(
              //       height: 200,
              //       decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(20),
              //           color: kGreyColor,
              //           boxShadow: primaryBoxShadow),
              //     ),
              //   ),
              // ),
            ),
          )
        ],
      ),
    );
  }
}
