import 'dart:io';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:media_cache_manager/media_cache_manager.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/chat/cubit.dart';
import 'package:silah/shared/chat/view.dart';
import 'package:silah/shared/product_details/cubit/cubit.dart';
import 'package:silah/shared/product_details/cubit/states.dart';
import 'package:silah/shared/product_details/model.dart';
import 'package:silah/shared/product_details/report_dialog.dart';
import 'package:silah/store/add_product/view.dart';
import 'package:silah/store/store_profile/view.dart';
import 'package:silah/widgets/app/info_bottom_sheet.dart';
import 'package:silah/widgets/app_bar.dart';
import 'package:silah/widgets/loading_indicator.dart';
import 'package:video_player/video_player.dart';

import '../../constants.dart';
import '../../widgets/app/profile_avatar.dart';
import 'units/delete_product_dialog.dart';
import 'units/product_images_view.dart';

part 'units/video.dart';

class ProductDetailsView extends StatefulWidget {
  ProductDetailsView({Key? key, this.productId}) : super(key: key);
  final String? productId;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  bool isLikeVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductsDetailsCubit(widget.productId)..getProductsDetails(),
      child: BlocBuilder<ProductsDetailsCubit, ProductsDetailsStates>(
        builder: (context, state) {
          final cubit = ProductsDetailsCubit.of(context);
          if (state is ProductsDetailsLoadingState) {
            return Scaffold(body: LoadingIndicator());
          }
          final productsDetailsModel = cubit.productsDetailsModel!;
          final imagesList = productsDetailsModel.productImages;
          return RefreshIndicator(
            onRefresh: cubit.getProductsDetails,
            child: Scaffold(
              appBar: appBar(),
              body: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        children: [
                          ProfileAvatar(
                            image: productsDetailsModel.advertizerProfile!,
                            userID: productsDetailsModel.advertizerId!,
                            height: 35,
                            width: 35,
                            onlineDotRadius: 5,
                            onTap: () =>
                                RouteManager.navigateTo(StoreProfileView(
                              storeId: productsDetailsModel.advertizerId!,
                            )),
                          ),
                          SizedBox(width: 15),
                          InkWell(
                              onTap: () {
                                RouteManager.navigateTo(StoreProfileView(
                                  storeId: productsDetailsModel.advertizerId!,
                                ));
                              },
                              child: Text(
                                productsDetailsModel.advertizerName!,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w700),
                              )),
                          Spacer(),
                          if (cubit.productsDetailsModel!.advertizerId ==
                              AppStorage.getUserModel()?.customerId.toString())
                            PopupMenuButton(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.8),
                              onSelected: (value) {
                                switch (value) {
                                  case 1:
                                    RouteManager.navigateTo(
                                      SAddProductView(
                                        productsDetailsModel:
                                            cubit.productsDetailsModel,
                                      ),
                                    );
                                    break;
                                  case 2:
                                    showDeleteProductDialog().then((value) {
                                      if (value) {
                                        cubit.deleteProduct();
                                      }
                                    });
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  height: 25,
                                  child: Text(
                                    'تعديل',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  value: 1,
                                ),
                                PopupMenuItem(
                                    height: 3,
                                    child: Divider(
                                      color: Colors.white,
                                    )),
                                PopupMenuItem(
                                  height: 25,
                                  child: Text(
                                    'حذف',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                    ),
                                  ),
                                  value: 2,
                                ),
                              ],
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(
                                  FontAwesomeIcons.ellipsis,
                                  size: 16,
                                ),
                              ),
                            ),
                          if (AppStorage.isLogged &&
                              cubit.productsDetailsModel!.advertizerId !=
                                  AppStorage.getUserModel()
                                      ?.customerId
                                      .toString())
                            //  !AppStorage.isStore)
                            GestureDetector(
                              onTap: () => showReportDialog(
                                  productsDetailsModel.productId!),
                              child: Center(
                                child: SvgPicture.asset(
                                  getIcon("exclamation"),
                                  color: Theme.of(context).primaryColor,
                                  height: 20,
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 350,
                      child: CarouselSlider(
                        controller: _controller,
                        items: imagesList!.map((e) {
                          if (e == 'VIDEO') {
                            return DownloadMediaBuilder(
                              url: productsDetailsModel.video!,
                              onLoading: (snapshot) {
                                return UnconstrainedBox(
                                  child: CircularProgressIndicator(
                                    value: snapshot.progress,
                                    color: kAccentColor,
                                    valueColor:
                                        AlwaysStoppedAnimation(kPrimaryColor),
                                  ),
                                );
                              },
                              onSuccess: (snapshot) {
                                return _VideoBubble(
                                  filePath: snapshot.filePath!,
                                );
                              },
                            );
                          }
                          return Stack(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  //  Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => ProductImagesView(
                                  //             initialIndex: imagesList.indexOf(e),
                                  //             urls: imagesList,
                                  //           )));
                                },
                                child: OpenContainer(
                                  openBuilder: (context, action) =>
                                      ProductImagesView(
                                    initialIndex: imagesList.indexOf(e),
                                    urls: imagesList,
                                  ),
                                  closedBuilder: (context, action) =>
                                      CachedNetworkImage(
                                    imageUrl: e,
                                    height: 350,
                                    width: double.infinity,
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) => Center(
                                      child: LoadingIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ),
                              Center(
                                child: AnimatedScale(
                                  scale: productsDetailsModel.inWishlist == true
                                      ? 1
                                      : 0,
                                  onEnd: () {
                                    setState(() {
                                      isLikeVisible = false;
                                    });
                                  },
                                  curve: Curves.easeInOutBack,
                                  duration: Duration(seconds: 1),
                                  child: Visibility(
                                    visible: isLikeVisible,
                                    child: Icon(
                                      FontAwesomeIcons.solidHeart,
                                      color: Color(0xffF64141),
                                      size: 100,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        }).toList(),
                        options: CarouselOptions(
                            autoPlay: false,
                            enableInfiniteScroll: false,
                            initialPage: 0,
                            aspectRatio: 2 / 5,
                            viewportFraction: 1,
                            enlargeCenterPage: false,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            }),
                      ),
                    ),
                  ),
                  // Indicators Row

                  SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Row(
                          children: [
                            _DescriptionTile(
                              description: productsDetailsModel.description,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            if (productsDetailsModel.price != "S.R 0")
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      (productsDetailsModel.price!)
                                          .replaceAll("S.R", ""),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      " ريال ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: imagesList.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () => _controller.animateToPage(entry.key),
                              child: Container(
                                width: 8.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 14.0, horizontal: 5.0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (Theme.of(context).primaryColor)
                                        .withOpacity(
                                            _current == entry.key ? 1 : .3)),
                              ),
                            );
                          }).toList(),
                        ),
                        Spacer(),
                        if (AppStorage.isLogged)
                          Row(
                            children: [
                              Text(
                                productsDetailsModel.totalWishlist!,
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              SizedBox(width: 0),
                              IconButton(
                                onPressed: () {
                                  productsDetailsModel.inWishlist =
                                      !productsDetailsModel.inWishlist!;
                                  if (productsDetailsModel.inWishlist!) {
                                    productsDetailsModel.totalWishlist =
                                        (int.parse(productsDetailsModel
                                                    .totalWishlist!) +
                                                1)
                                            .toString();
                                  } else {
                                    productsDetailsModel.totalWishlist =
                                        (int.parse(productsDetailsModel
                                                    .totalWishlist!) -
                                                1)
                                            .toString();
                                  }
                                  print(productsDetailsModel.inWishlist);
                                  setState(() {
                                    isLikeVisible = true;
                                    if (productsDetailsModel.inWishlist !=
                                        true) {
                                      isLikeVisible = true;
                                    }
                                  });
                                  cubit.toggleFavorite(
                                      baseModel: productsDetailsModel,
                                      productId: productsDetailsModel.productId
                                          .toString());
                                },
                                icon: Icon(
                                  productsDetailsModel.inWishlist!
                                      ? FontAwesomeIcons.solidHeart
                                      : FontAwesomeIcons.heart,
                                  color: productsDetailsModel.inWishlist!
                                      ? Colors.red
                                      : Theme.of(context).primaryColor,
                                  size: 18,
                                ),
                              ),
                              if (AppStorage.isLogged && !AppStorage.isStore)
                                IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.repeat,
                                    color: Theme.of(context).primaryColor,
                                    size: 16,
                                  ),
                                  onPressed: () async {
                                    final chatID = await ChatCubit.getChatID(
                                        productsDetailsModel.advertizerId!);
                                    RouteManager.navigateTo(
                                      ChatView(
                                        profileImage: productsDetailsModel
                                            .advertizerProfile!,
                                        chatID: chatID,
                                        username: productsDetailsModel
                                            .advertizerName!,
                                        productID: productsDetailsModel
                                            .productId
                                            .toString(),
                                        userID:
                                            productsDetailsModel.advertizerId!,
                                        messagesCubit: null,
                                        productImage: productsDetailsModel
                                            .productImages![0],
                                      ),
                                    );
                                  },
                                ),
                              if (AppStorage.isStore &&
                                  AppStorage.customerID.toString() ==
                                      productsDetailsModel.advertizerId)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 20),
                                  child: InkWell(
                                    onTap: () {
                                      showDialogCommission(
                                          cubit: cubit, context: context);
                                    },
                                    child: Icon(
                                      FontAwesomeIcons.clockRotateLeft,
                                      size: 16,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        productsDetailsModel.productName.toString(),
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      var relatedProduct =
                          cubit.productsDetailsModel?.realted?[index];
                      return buildRelatedItem(relatedProduct, cubit, context);
                    }, childCount: productsDetailsModel.realted?.length ?? 0),
                  )
                ],
                // children: [
                //   Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                //     child: Row(
                //       children: [
                //         ProfileAvatar(
                //           image: productsDetailsModel.advertizerProfile!,
                //           userID: productsDetailsModel.advertizerId!,
                //           height: 35,
                //           width: 35,
                //           onlineDotRadius: 5,
                //           onTap: () => RouteManager.navigateTo(StoreProfileView(
                //             storeId: productsDetailsModel.advertizerId!,
                //           )),
                //         ),
                //         SizedBox(width: 15),
                //         InkWell(
                //             onTap: () {
                //               RouteManager.navigateTo(StoreProfileView(
                //                 storeId: productsDetailsModel.advertizerId!,
                //               ));
                //             },
                //             child: Text(
                //               productsDetailsModel.advertizerName!,
                //               style: TextStyle(
                //                   fontSize: 12, fontWeight: FontWeight.w700),
                //             )),
                //         Spacer(),
                //         if (cubit.productsDetailsModel!.advertizerId ==
                //             AppStorage.getUserModel()?.customerId.toString())
                //           PopupMenuButton(
                //             color: Colors.black.withOpacity(0.8),
                //             onSelected: (value) {
                //               switch (value) {
                //                 case 1:
                //                   RouteManager.navigateTo(
                //                     SAddProductView(
                //                       productsDetailsModel:
                //                           cubit.productsDetailsModel,
                //                     ),
                //                   );
                //                   break;
                //                 case 2:
                //                   showDeleteProductDialog().then((value) {
                //                     if (value) {
                //                       cubit.deleteProduct();
                //                     }
                //                   });
                //                   break;
                //               }
                //             },
                //             itemBuilder: (context) => [
                //               PopupMenuItem(
                //                 height: 25,
                //                 child: Text(
                //                   'تعديل',
                //                   style: TextStyle(
                //                     color: Colors.white,
                //                     fontWeight: FontWeight.w700,
                //                     fontSize: 14,
                //                   ),
                //                 ),
                //                 value: 1,
                //               ),
                //               PopupMenuItem(
                //                   height: 3,
                //                   child: Divider(
                //                     color: Colors.white,
                //                   )),
                //               PopupMenuItem(
                //                 height: 25,
                //                 child: Text(
                //                   'حذف',
                //                   style: TextStyle(
                //                     color: Colors.white,
                //                     fontWeight: FontWeight.w900,
                //                     fontSize: 14,
                //                   ),
                //                 ),
                //                 value: 2,
                //               ),
                //             ],
                //             child: Padding(
                //               padding:
                //                   const EdgeInsets.symmetric(horizontal: 10),
                //               child: Icon(
                //                 FontAwesomeIcons.ellipsis,
                //                 size: 16,
                //               ),
                //             ),
                //           ),
                //         if (AppStorage.isLogged &&
                //             cubit.productsDetailsModel!.advertizerId !=
                //                 AppStorage.getUserModel()
                //                     ?.customerId
                //                     .toString())
                //           //  !AppStorage.isStore)
                //           GestureDetector(
                //             onTap: () => showReportDialog(
                //                 productsDetailsModel.productId!),
                //             child: Center(
                //               child: SvgPicture.asset(
                //                 getIcon("exclamation"),
                //                 height: 20,
                //               ),
                //             ),
                //           )
                //       ],
                //     ),
                //   ),
                //   Container(
                //     height: 350,
                //     child: CarouselSlider(
                //       carouselController: _controller,
                //       items: imagesList!.map((e) {
                //         if (e == 'VIDEO') {
                //           return DownloadMediaBuilder(
                //             url: productsDetailsModel.video!,
                //             builder: (context, snapshot) {
                //               if (snapshot.status ==
                //                   DownloadMediaStatus.loading) {
                //                 return UnconstrainedBox(
                //                   child: CircularProgressIndicator(
                //                     value: snapshot.progress,
                //                     color: kAccentColor,
                //                     valueColor:
                //                         AlwaysStoppedAnimation(kPrimaryColor),
                //                   ),
                //                 );
                //               }
                //               if (snapshot.status ==
                //                   DownloadMediaStatus.success) {
                //                 return _VideoBubble(
                //                   filePath: snapshot.filePath!,
                //                 );
                //               }
                //               return null;
                //             },
                //           );
                //         }
                //         return Stack(
                //           children: <Widget>[
                //             GestureDetector(
                //               onTap: () {
                //                 //  Navigator.push(
                //                 //   context,
                //                 //   MaterialPageRoute(
                //                 //       builder: (context) => ProductImagesView(
                //                 //             initialIndex: imagesList.indexOf(e),
                //                 //             urls: imagesList,
                //                 //           )));
                //               },
                //               child: OpenContainer(
                //                 openBuilder: (context, action) =>
                //                     ProductImagesView(
                //                   initialIndex: imagesList.indexOf(e),
                //                   urls: imagesList,
                //                 ),
                //                 closedBuilder: (context, action) =>
                //                     CachedNetworkImage(
                //                   imageUrl: e,
                //                   height: 350,
                //                   width: double.infinity,
                //                   fit: BoxFit.fill,
                //                   placeholder: (context, url) => Center(
                //                     child: LoadingIndicator(),
                //                   ),
                //                   errorWidget: (context, url, error) =>
                //                       Icon(Icons.error),
                //                 ),
                //               ),
                //             ),
                //             Center(
                //               child: AnimatedScale(
                //                 scale: productsDetailsModel.inWishlist == true
                //                     ? 1
                //                     : 0,
                //                 onEnd: () {
                //                   setState(() {
                //                     isLikeVisible = false;
                //                   });
                //                 },
                //                 curve: Curves.easeInOutBack,
                //                 duration: Duration(seconds: 1),
                //                 child: Visibility(
                //                   visible: isLikeVisible,
                //                   child: Icon(
                //                     FontAwesomeIcons.solidHeart,
                //                     color: Color(0xffF64141),
                //                     size: 100,
                //                   ),
                //                 ),
                //               ),
                //             )
                //           ],
                //         );
                //       }).toList(),
                //       options: CarouselOptions(
                //           autoPlay: false,
                //           enableInfiniteScroll: false,
                //           initialPage: 0,
                //           aspectRatio: 2 / 5,
                //           viewportFraction: 1,
                //           enlargeCenterPage: false,
                //           onPageChanged: (index, reason) {
                //             setState(() {
                //               _current = index;
                //             });
                //           }),
                //     ),
                //   ),
                //   // Indicators Row
                //
                //   Row(
                //     children: [
                //       Row(
                //         children: [
                //           _DescriptionTile(
                //             description: productsDetailsModel.description,
                //           ),
                //           SizedBox(
                //             width: 10,
                //           ),
                //           if (productsDetailsModel.price != "S.R 0")
                //             Align(
                //               alignment: Alignment.centerLeft,
                //               child: Row(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: [
                //                   Text(
                //                     (productsDetailsModel.price!)
                //                         .replaceAll("S.R", ""),
                //                     style: TextStyle(
                //                       fontWeight: FontWeight.w700,
                //                       fontSize: 18,
                //                     ),
                //                   ),
                //                   Text(
                //                     " ريال ",
                //                     style: TextStyle(
                //                       fontWeight: FontWeight.w700,
                //                       fontSize: 12,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //         ],
                //       ),
                //       Spacer(),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: imagesList.asMap().entries.map((entry) {
                //           return GestureDetector(
                //             onTap: () => _controller.animateToPage(entry.key),
                //             child: Container(
                //               width: 8.0,
                //               height: 8.0,
                //               margin: EdgeInsets.symmetric(
                //                   vertical: 14.0, horizontal: 5.0),
                //               decoration: BoxDecoration(
                //                   shape: BoxShape.circle,
                //                   color: (Theme.of(context).brightness ==
                //                               Brightness.dark
                //                           ? Colors.white
                //                           : kPrimaryColor)
                //                       .withOpacity(
                //                           _current == entry.key ? 1 : .3)),
                //             ),
                //           );
                //         }).toList(),
                //       ),
                //       Spacer(),
                //       if (AppStorage.isLogged)
                //         Row(
                //           children: [
                //             Text(
                //               productsDetailsModel.totalWishlist!,
                //               style: TextStyle(fontWeight: FontWeight.w700),
                //             ),
                //             SizedBox(width: 0),
                //             IconButton(
                //               onPressed: () {
                //                 productsDetailsModel.inWishlist =
                //                     !productsDetailsModel.inWishlist!;
                //                 if (productsDetailsModel.inWishlist!) {
                //                   productsDetailsModel.totalWishlist =
                //                       (int.parse(productsDetailsModel
                //                                   .totalWishlist!) +
                //                               1)
                //                           .toString();
                //                 } else {
                //                   productsDetailsModel.totalWishlist =
                //                       (int.parse(productsDetailsModel
                //                                   .totalWishlist!) -
                //                               1)
                //                           .toString();
                //                 }
                //                 print(productsDetailsModel.inWishlist);
                //                 setState(() {
                //                   isLikeVisible = true;
                //                   if (productsDetailsModel.inWishlist != true) {
                //                     isLikeVisible = true;
                //                   }
                //                 });
                //                 cubit.toggleFavorite();
                //               },
                //               icon: Icon(
                //                 productsDetailsModel.inWishlist!
                //                     ? FontAwesomeIcons.solidHeart
                //                     : FontAwesomeIcons.heart,
                //                 color: productsDetailsModel.inWishlist!
                //                     ? Colors.red
                //                     : Colors.black,
                //                 size: 18,
                //               ),
                //             ),
                //             if (AppStorage.isLogged && !AppStorage.isStore)
                //               IconButton(
                //                 icon: Icon(
                //                   FontAwesomeIcons.repeat,
                //                   color: Colors.black,
                //                   size: 16,
                //                 ),
                //                 onPressed: () async {
                //                   final chatID = await ChatCubit.getChatID(
                //                       productsDetailsModel.advertizerId!);
                //                   RouteManager.navigateTo(
                //                     ChatView(
                //                       profileImage: productsDetailsModel
                //                           .advertizerProfile!,
                //                       chatID: chatID,
                //                       username:
                //                           productsDetailsModel.advertizerName!,
                //                       productID: productsDetailsModel.productId
                //                           .toString(),
                //                       userID:
                //                           productsDetailsModel.advertizerId!,
                //                       messagesCubit: null,
                //                     ),
                //                   );
                //                 },
                //               ),
                //             if (AppStorage.isStore &&
                //                 AppStorage.customerID.toString() ==
                //                     productsDetailsModel.advertizerId)
                //               Padding(
                //                 padding:
                //                     const EdgeInsets.only(right: 10, left: 20),
                //                 child: InkWell(
                //                   onTap: cubit.refreshProduct,
                //                   child: Icon(
                //                     FontAwesomeIcons.clockRotateLeft,
                //                     size: 16,
                //                     color: Colors.black,
                //                   ),
                //                 ),
                //               ),
                //           ],
                //         ),
                //     ],
                //   ),
                //
                //   Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 12),
                //     child: Text(
                //       productsDetailsModel.productName.toString(),
                //       style: TextStyle(fontWeight: FontWeight.w700),
                //     ),
                //   ),
                //
                //   // if (productsDetailsModel.video != null && productsDetailsModel.video!.isNotEmpty)
                //   //   DownloadMediaBuilder(
                //   //     url: productsDetailsModel.video!,
                //   //     builder: (context, snapshot) {
                //   //       if (snapshot.status == DownloadMediaStatus.loading) {
                //   //         return LinearProgressIndicator(
                //   //           value: snapshot.progress,
                //   //           color: kAccentColor,
                //   //           valueColor: AlwaysStoppedAnimation(kPrimaryColor),
                //   //         );
                //   //       }
                //   //       if (snapshot.status == DownloadMediaStatus.success) {
                //   //         return VideoBubble(file: snapshot.filePath);
                //   //       }
                //   //       return null;
                //   //     },
                //   //   ),
                //   ListView.builder(
                //     shrinkWrap: true,
                //     itemBuilder: (context, index) {
                //       return Column(
                //         children: [
                //           Padding(
                //             padding: EdgeInsets.symmetric(
                //                 horizontal: 12, vertical: 10),
                //             child: Row(
                //               children: [
                //                 ProfileAvatar(
                //                   image:
                //                       productsDetailsModel.advertizerProfile!,
                //                   userID: productsDetailsModel.advertizerId!,
                //                   height: 35,
                //                   width: 35,
                //                   onlineDotRadius: 5,
                //                   onTap: () =>
                //                       RouteManager.navigateTo(StoreProfileView(
                //                     storeId: productsDetailsModel.advertizerId!,
                //                   )),
                //                 ),
                //                 SizedBox(width: 15),
                //                 InkWell(
                //                     onTap: () {
                //                       RouteManager.navigateTo(StoreProfileView(
                //                         storeId:
                //                             productsDetailsModel.advertizerId!,
                //                       ));
                //                     },
                //                     child: Text(
                //                       productsDetailsModel.advertizerName!,
                //                       style: TextStyle(
                //                           fontSize: 12,
                //                           fontWeight: FontWeight.w700),
                //                     )),
                //                 Spacer(),
                //                 if (cubit.productsDetailsModel!.advertizerId ==
                //                     AppStorage.getUserModel()
                //                         ?.customerId
                //                         .toString())
                //                   PopupMenuButton(
                //                     color: Colors.black.withOpacity(0.8),
                //                     onSelected: (value) {
                //                       switch (value) {
                //                         case 1:
                //                           RouteManager.navigateTo(
                //                             SAddProductView(
                //                               productsDetailsModel:
                //                                   cubit.productsDetailsModel,
                //                             ),
                //                           );
                //                           break;
                //                         case 2:
                //                           showDeleteProductDialog()
                //                               .then((value) {
                //                             if (value) {
                //                               cubit.deleteProduct();
                //                             }
                //                           });
                //                           break;
                //                       }
                //                     },
                //                     itemBuilder: (context) => [
                //                       PopupMenuItem(
                //                         height: 25,
                //                         child: Text(
                //                           'تعديل',
                //                           style: TextStyle(
                //                             color: Colors.white,
                //                             fontWeight: FontWeight.w700,
                //                             fontSize: 14,
                //                           ),
                //                         ),
                //                         value: 1,
                //                       ),
                //                       PopupMenuItem(
                //                           height: 3,
                //                           child: Divider(
                //                             color: Colors.white,
                //                           )),
                //                       PopupMenuItem(
                //                         height: 25,
                //                         child: Text(
                //                           'حذف',
                //                           style: TextStyle(
                //                             color: Colors.white,
                //                             fontWeight: FontWeight.w900,
                //                             fontSize: 14,
                //                           ),
                //                         ),
                //                         value: 2,
                //                       ),
                //                     ],
                //                     child: Padding(
                //                       padding: const EdgeInsets.symmetric(
                //                           horizontal: 10),
                //                       child: Icon(
                //                         FontAwesomeIcons.ellipsis,
                //                         size: 16,
                //                       ),
                //                     ),
                //                   ),
                //                 if (AppStorage.isLogged &&
                //                     cubit.productsDetailsModel!.advertizerId !=
                //                         AppStorage.getUserModel()
                //                             ?.customerId
                //                             .toString())
                //                   //  !AppStorage.isStore)
                //                   GestureDetector(
                //                     onTap: () => showReportDialog(
                //                         productsDetailsModel.productId!),
                //                     child: Center(
                //                       child: SvgPicture.asset(
                //                         getIcon("exclamation"),
                //                         height: 20,
                //                       ),
                //                     ),
                //                   )
                //               ],
                //             ),
                //           ),
                //           Container(
                //             height: 350,
                //             child: CarouselSlider(
                //               carouselController: _controller,
                //               items: imagesList!.map((e) {
                //                 if (e == 'VIDEO') {
                //                   return DownloadMediaBuilder(
                //                     url: productsDetailsModel.video!,
                //                     builder: (context, snapshot) {
                //                       if (snapshot.status ==
                //                           DownloadMediaStatus.loading) {
                //                         return UnconstrainedBox(
                //                           child: CircularProgressIndicator(
                //                             value: snapshot.progress,
                //                             color: kAccentColor,
                //                             valueColor: AlwaysStoppedAnimation(
                //                                 kPrimaryColor),
                //                           ),
                //                         );
                //                       }
                //                       if (snapshot.status ==
                //                           DownloadMediaStatus.success) {
                //                         return _VideoBubble(
                //                           filePath: snapshot.filePath!,
                //                         );
                //                       }
                //                       return null;
                //                     },
                //                   );
                //                 }
                //                 return Stack(
                //                   children: <Widget>[
                //                     GestureDetector(
                //                       onTap: () {
                //                         //  Navigator.push(
                //                         //   context,
                //                         //   MaterialPageRoute(
                //                         //       builder: (context) => ProductImagesView(
                //                         //             initialIndex: imagesList.indexOf(e),
                //                         //             urls: imagesList,
                //                         //           )));
                //                       },
                //                       child: OpenContainer(
                //                         openBuilder: (context, action) =>
                //                             ProductImagesView(
                //                           initialIndex: imagesList.indexOf(e),
                //                           urls: imagesList,
                //                         ),
                //                         closedBuilder: (context, action) =>
                //                             CachedNetworkImage(
                //                           imageUrl: e,
                //                           height: 350,
                //                           width: double.infinity,
                //                           fit: BoxFit.fill,
                //                           placeholder: (context, url) => Center(
                //                             child: LoadingIndicator(),
                //                           ),
                //                           errorWidget: (context, url, error) =>
                //                               Icon(Icons.error),
                //                         ),
                //                       ),
                //                     ),
                //                     Center(
                //                       child: AnimatedScale(
                //                         scale:
                //                             productsDetailsModel.inWishlist ==
                //                                     true
                //                                 ? 1
                //                                 : 0,
                //                         onEnd: () {
                //                           setState(() {
                //                             isLikeVisible = false;
                //                           });
                //                         },
                //                         curve: Curves.easeInOutBack,
                //                         duration: Duration(seconds: 1),
                //                         child: Visibility(
                //                           visible: isLikeVisible,
                //                           child: Icon(
                //                             FontAwesomeIcons.solidHeart,
                //                             color: Color(0xffF64141),
                //                             size: 100,
                //                           ),
                //                         ),
                //                       ),
                //                     )
                //                   ],
                //                 );
                //               }).toList(),
                //               options: CarouselOptions(
                //                   autoPlay: false,
                //                   enableInfiniteScroll: false,
                //                   initialPage: 0,
                //                   aspectRatio: 2 / 5,
                //                   viewportFraction: 1,
                //                   enlargeCenterPage: false,
                //                   onPageChanged: (index, reason) {
                //                     setState(() {
                //                       _current = index;
                //                     });
                //                   }),
                //             ),
                //           ),
                //           // Indicators Row
                //
                //           Row(
                //             children: [
                //               Row(
                //                 children: [
                //                   _DescriptionTile(
                //                     description:
                //                         productsDetailsModel.description,
                //                   ),
                //                   SizedBox(
                //                     width: 10,
                //                   ),
                //                   if (productsDetailsModel.price != "S.R 0")
                //                     Align(
                //                       alignment: Alignment.centerLeft,
                //                       child: Row(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.center,
                //                         children: [
                //                           Text(
                //                             (productsDetailsModel.price!)
                //                                 .replaceAll("S.R", ""),
                //                             style: TextStyle(
                //                               fontWeight: FontWeight.w700,
                //                               fontSize: 18,
                //                             ),
                //                           ),
                //                           Text(
                //                             " ريال ",
                //                             style: TextStyle(
                //                               fontWeight: FontWeight.w700,
                //                               fontSize: 12,
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ),
                //                 ],
                //               ),
                //               Spacer(),
                //               Row(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children:
                //                     imagesList.asMap().entries.map((entry) {
                //                   return GestureDetector(
                //                     onTap: () =>
                //                         _controller.animateToPage(entry.key),
                //                     child: Container(
                //                       width: 8.0,
                //                       height: 8.0,
                //                       margin: EdgeInsets.symmetric(
                //                           vertical: 14.0, horizontal: 5.0),
                //                       decoration: BoxDecoration(
                //                           shape: BoxShape.circle,
                //                           color: (Theme.of(context)
                //                                           .brightness ==
                //                                       Brightness.dark
                //                                   ? Colors.white
                //                                   : kPrimaryColor)
                //                               .withOpacity(_current == entry.key
                //                                   ? 1
                //                                   : .3)),
                //                     ),
                //                   );
                //                 }).toList(),
                //               ),
                //               Spacer(),
                //               if (AppStorage.isLogged)
                //                 Row(
                //                   children: [
                //                     Text(
                //                       productsDetailsModel.totalWishlist!,
                //                       style: TextStyle(
                //                           fontWeight: FontWeight.w700),
                //                     ),
                //                     SizedBox(width: 0),
                //                     IconButton(
                //                       onPressed: () {
                //                         productsDetailsModel.inWishlist =
                //                             !productsDetailsModel.inWishlist!;
                //                         if (productsDetailsModel.inWishlist!) {
                //                           productsDetailsModel.totalWishlist =
                //                               (int.parse(productsDetailsModel
                //                                           .totalWishlist!) +
                //                                       1)
                //                                   .toString();
                //                         } else {
                //                           productsDetailsModel.totalWishlist =
                //                               (int.parse(productsDetailsModel
                //                                           .totalWishlist!) -
                //                                       1)
                //                                   .toString();
                //                         }
                //                         print(productsDetailsModel.inWishlist);
                //                         setState(() {
                //                           isLikeVisible = true;
                //                           if (productsDetailsModel.inWishlist !=
                //                               true) {
                //                             isLikeVisible = true;
                //                           }
                //                         });
                //                         cubit.toggleFavorite();
                //                       },
                //                       icon: Icon(
                //                         productsDetailsModel.inWishlist!
                //                             ? FontAwesomeIcons.solidHeart
                //                             : FontAwesomeIcons.heart,
                //                         color: productsDetailsModel.inWishlist!
                //                             ? Colors.red
                //                             : Colors.black,
                //                         size: 18,
                //                       ),
                //                     ),
                //                     if (AppStorage.isLogged &&
                //                         !AppStorage.isStore)
                //                       IconButton(
                //                         icon: Icon(
                //                           FontAwesomeIcons.repeat,
                //                           color: Colors.black,
                //                           size: 16,
                //                         ),
                //                         onPressed: () async {
                //                           final chatID =
                //                               await ChatCubit.getChatID(
                //                                   productsDetailsModel
                //                                       .advertizerId!);
                //                           RouteManager.navigateTo(
                //                             ChatView(
                //                               profileImage: productsDetailsModel
                //                                   .advertizerProfile!,
                //                               chatID: chatID,
                //                               username: productsDetailsModel
                //                                   .advertizerName!,
                //                               productID: productsDetailsModel
                //                                   .productId
                //                                   .toString(),
                //                               userID: productsDetailsModel
                //                                   .advertizerId!,
                //                               messagesCubit: null,
                //                             ),
                //                           );
                //                         },
                //                       ),
                //                     if (AppStorage.isStore &&
                //                         AppStorage.customerID.toString() ==
                //                             productsDetailsModel.advertizerId)
                //                       Padding(
                //                         padding: const EdgeInsets.only(
                //                             right: 10, left: 20),
                //                         child: InkWell(
                //                           onTap: cubit.refreshProduct,
                //                           child: Icon(
                //                             FontAwesomeIcons.clockRotateLeft,
                //                             size: 16,
                //                             color: Colors.black,
                //                           ),
                //                         ),
                //                       ),
                //                   ],
                //                 ),
                //             ],
                //           ),
                //
                //           Padding(
                //             padding: EdgeInsets.symmetric(horizontal: 12),
                //             child: Text(
                //               productsDetailsModel.productName.toString(),
                //               style: TextStyle(fontWeight: FontWeight.w700),
                //             ),
                //           ),
                //         ],
                //       );
                //     },
                //     itemCount: 5,
                //   )
                // ],
              ),
            ),
          );
        },
      ),
    );
  }

  Column buildRelatedItem(Realted? relatedProduct, ProductsDetailsCubit cubit,
      BuildContext context) {
    final CarouselSliderController _controllerRelated =
        CarouselSliderController();
    int _currentRelatedRelated = 0;
    bool isLikeVisibleRelated = false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              ProfileAvatar(
                image: relatedProduct!.advertizerProfile!,
                userID: relatedProduct.advertizerId!,
                height: 35,
                width: 35,
                onlineDotRadius: 5,
                onTap: () => RouteManager.navigateTo(StoreProfileView(
                  storeId: relatedProduct.advertizerId!,
                )),
              ),
              SizedBox(width: 15),
              InkWell(
                  onTap: () {
                    RouteManager.navigateTo(StoreProfileView(
                      storeId: relatedProduct.advertizerId!,
                    ));
                  },
                  child: Text(
                    relatedProduct.advertizerName!,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  )),
              Spacer(),
              if (relatedProduct.advertizerId ==
                  AppStorage.getUserModel()?.customerId.toString())
                PopupMenuButton(
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                  onSelected: (value) {
                    switch (value) {
                      case 1:
                        RouteManager.navigateTo(
                          SAddProductView(
                            productsDetailsModel: relatedProduct,
                          ),
                        );
                        break;
                      case 2:
                        showDeleteProductDialog().then((value) {
                          if (value) {
                            cubit.deleteProduct();
                          }
                        });
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      height: 25,
                      child: Text(
                        'تعديل',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      value: 1,
                    ),
                    PopupMenuItem(
                        height: 3,
                        child: Divider(
                          color: Colors.white,
                        )),
                    PopupMenuItem(
                      height: 25,
                      child: Text(
                        'حذف',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                      value: 2,
                    ),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      FontAwesomeIcons.ellipsis,
                      size: 16,
                    ),
                  ),
                ),
              if (AppStorage.isLogged &&
                  relatedProduct.advertizerId !=
                      AppStorage.getUserModel()?.customerId.toString())
                //  !AppStorage.isStore)
                GestureDetector(
                  onTap: () => showReportDialog(relatedProduct.productId!),
                  child: Center(
                    child: SvgPicture.asset(
                      getIcon("exclamation"),
                      height: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
            ],
          ),
        ),
        Container(
          height: 350,
          child: CarouselSlider(
            controller: _controllerRelated,
            items: relatedProduct.productImages!.map((e) {
              if (e == 'VIDEO') {
                return DownloadMediaBuilder(
                  url: relatedProduct.video!,
                  onLoading: (snapshot) {
                    return UnconstrainedBox(
                      child: CircularProgressIndicator(
                        value: snapshot.progress,
                        color: kAccentColor,
                        valueColor: AlwaysStoppedAnimation(kPrimaryColor),
                      ),
                    );
                  },
                  onSuccess: (snapshot) {
                    return _VideoBubble(
                      filePath: snapshot.filePath!,
                    );
                  },
                );
              }
              return Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      //  Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => ProductImagesView(
                      //             initialIndex: imagesList.indexOf(e),
                      //             urls: imagesList,
                      //           )));
                    },
                    child: OpenContainer(
                      openBuilder: (context, action) => ProductImagesView(
                        initialIndex: relatedProduct.productImages!.indexOf(e),
                        urls: relatedProduct.productImages!,
                      ),
                      closedBuilder: (context, action) => CachedNetworkImage(
                        imageUrl: e,
                        height: 350,
                        width: double.infinity,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Center(
                          child: LoadingIndicator(),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  Center(
                    child: AnimatedScale(
                      scale: relatedProduct.inWishlist == true ? 1 : 0,
                      onEnd: () {
                        setState(() {
                          isLikeVisibleRelated = false;
                        });
                      },
                      curve: Curves.easeInOutBack,
                      duration: Duration(seconds: 1),
                      child: Visibility(
                        visible: isLikeVisibleRelated,
                        child: Icon(
                          FontAwesomeIcons.solidHeart,
                          color: Color(0xffF64141),
                          size: 100,
                        ),
                      ),
                    ),
                  )
                ],
              );
            }).toList(),
            options: CarouselOptions(
                autoPlay: false,
                enableInfiniteScroll: false,
                initialPage: 0,
                aspectRatio: 2 / 5,
                viewportFraction: 1,
                enlargeCenterPage: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentRelatedRelated = index;
                  });
                }),
          ),
        ),
        // Indicators Row

        Row(
          children: [
            Row(
              children: [
                _DescriptionTile(
                  description: relatedProduct.description,
                ),
                SizedBox(
                  width: 10,
                ),
                if (relatedProduct.price != "S.R 0")
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (relatedProduct.price!).replaceAll("S.R", ""),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          " ريال ",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  relatedProduct.productImages!.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controllerRelated.animateToPage(entry.key),
                  child: Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 14.0, horizontal: 5.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).primaryColor).withOpacity(
                            _currentRelatedRelated == entry.key ? 1 : .3)),
                  ),
                );
              }).toList(),
            ),
            Spacer(),
            if (AppStorage.isLogged)
              Row(
                children: [
                  Text(
                    relatedProduct.totalWishlist!,
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 0),
                  IconButton(
                    onPressed: () {
                      relatedProduct.inWishlist = !relatedProduct.inWishlist!;
                      if (relatedProduct.inWishlist!) {
                        relatedProduct.totalWishlist =
                            (int.parse(relatedProduct.totalWishlist!) + 1)
                                .toString();
                      } else {
                        relatedProduct.totalWishlist =
                            (int.parse(relatedProduct.totalWishlist!) - 1)
                                .toString();
                      }
                      print(relatedProduct.inWishlist);
                      setState(() {
                        isLikeVisibleRelated = true;
                        if (relatedProduct.inWishlist != true) {
                          isLikeVisibleRelated = true;
                        }
                      });
                      cubit.toggleFavorite(
                          baseModel: relatedProduct,
                          productId: relatedProduct.productId.toString());
                    },
                    icon: Icon(
                      relatedProduct.inWishlist!
                          ? FontAwesomeIcons.solidHeart
                          : FontAwesomeIcons.heart,
                      color: relatedProduct.inWishlist!
                          ? Colors.red
                          : Theme.of(context).primaryColor,
                      size: 18,
                    ),
                  ),
                  if (AppStorage.isLogged && !AppStorage.isStore)
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.repeat,
                        color: Theme.of(context).primaryColor,
                        size: 16,
                      ),
                      onPressed: () async {
                        final chatID = await ChatCubit.getChatID(
                            relatedProduct.advertizerId!);
                        RouteManager.navigateTo(
                          ChatView(
                            profileImage: relatedProduct.advertizerProfile!,
                            chatID: chatID,
                            username: relatedProduct.advertizerName!,
                            productID: relatedProduct.productId.toString(),
                            productImage: relatedProduct.productImages![0],
                            userID: relatedProduct.advertizerId!,
                            messagesCubit: null,
                          ),
                        );
                      },
                    ),
                  if (AppStorage.isStore &&
                      AppStorage.customerID.toString() ==
                          relatedProduct.advertizerId)
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 20),
                      child: InkWell(
                        onTap: () {
                          showDialogCommission(cubit: cubit, context: context);
                        },
                        child: Icon(
                          FontAwesomeIcons.clockRotateLeft,
                          size: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            relatedProduct.productName.toString(),
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}

class _DescriptionTile extends StatefulWidget {
  const _DescriptionTile({Key? key, required this.description})
      : super(key: key);

  final String? description;

  @override
  State<_DescriptionTile> createState() => _DescriptionTileState();
}

class _DescriptionTileState extends State<_DescriptionTile> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.description == null || widget.description!.trim().isEmpty) {
      return SizedBox.shrink();
    }
    return InkWell(
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () => InfoBottomSheet.show(
        title: 'الوصف',
        info: widget.description!,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon(expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              IconButton(
                onPressed: () => InfoBottomSheet.show(
                  title: 'الوصف',
                  info: widget.description!,
                ),
                icon: Icon(
                  FontAwesomeIcons.message,
                  size: 16,
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 6),
              child: Text(widget.description!, style: TextStyle(fontSize: 18)),
            ),
        ],
      ),
    );
  }
}

void showDialogCommission(
    {required BuildContext context, required ProductsDetailsCubit cubit}) {
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(
        'أتعهد بدفع العمولة عند كل بيعة تتم',
        style: TextStyle(fontSize: 14, fontFamily: ''),
      ),

      actions: [
        CupertinoButton(
          child: Text(
            'موافق',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            cubit.refreshProduct();
            RouteManager.pop();
          },
        ),
        // CupertinoButton(
        //   child: Text(
        //     'نعم',
        //     style: TextStyle(color: Colors.green),
        //   ),
        //   onPressed: () async {
        //     RouteManager.pop();
        //     await DioHelper.post('provider/banks/delete_all_commission',
        //         data: {
        //           'provider_id': AppStorage.customerID,
        //         });
        //     // getCommissions();
        //   },
        // ),
      ],
      // color: Colors.white,
      // child: Column(
      //   children: [
      //     Text('يمكن لزبون المتابعة'),
      //     // Row(
      //     //   children: [
      //     //
      //     //   ],
      //     // )
      //   ],
      // ),
    ),
  );
}
