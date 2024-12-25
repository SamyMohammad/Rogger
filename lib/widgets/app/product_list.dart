import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/widgets/loading_indicator.dart';
import 'package:silah/widgets/rate_widget.dart';

class GridProductItem extends StatelessWidget {
  final String title;

  final String time;
  final String personName;
  final String city;
  final String image;
  final String customerProfile;
  final String productId;
  final double rate;
  const GridProductItem({
    super.key,
    required this.title,
    required this.time,
    required this.personName,
    required this.city,
    required this.image,
    required this.customerProfile,
    required this.productId,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    bool? isRead = AppStorage.getProduct()?.contains(productId);
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: CachedNetworkImageProvider(image),
                fit: BoxFit.cover,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: image == "https://roogr.sa/api/image/no_image.png"
                  ? Image.asset(
                      "assets/images/no_icon.png",
                      width: double.infinity,
                      height: MediaQuery.sizeOf(context).height * 0.15,
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl: image,
                      width: double.infinity,
                      height: MediaQuery.sizeOf(context).height * 0.15,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: LoadingIndicator(),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isRead == true ? Color(0xFFAA3DED) : null),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 7),
          AbsorbPointer(
            absorbing: true,
            child: RateWidget(
              rate: rate,
              itemSize: 15,
              hItemPadding: 0,
            ),
          ),
          SizedBox(height: 7),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: SvgPicture.asset(
                    getIcon("icon3"),
                    height: 12,
                    color: Theme.of(context).primaryColor,
                  )),
              SizedBox(width: 2),
              Flexible(
                child: Text(
                  city.toString().replaceAll('\n', ' '),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(
                FontAwesomeIcons.clock,
                size: 12,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 5),
              Flexible(
                child: Text(
                  time.toString(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: customerProfile !=
                        'https://roogr.sa/api/image/user_image.png'
                    ? Image.network(
                        customerProfile,
                        height: 25,
                        width: 25,
                        fit: BoxFit.fill,
                      )
                    : Image.asset(
                        getAsset('person'),
                        height: 25,
                        width: 25,
                        fit: BoxFit.scaleDown,
                        scale: 1.5,
                      ),
              ),
              //  CachedNetworkImage(
              //   imageUrl: customerProfile,
              //   width: 24,
              //   height: 24,
              //   fit: BoxFit.cover,
              //   placeholder: (context, url) => Center(
              //     child: LoadingIndicator(),
              //   ),
              //   errorWidget: (context, url, error) =>
              //       Image.asset(getAsset('person')),
              // )),
              SizedBox(width: 5),
              Flexible(
                child: Text(
                  personName.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final String title;

  final String time;
  final String personName;
  final String city;
  final String image;
  final String customerProfile;
  final String productId;
  final double rate;
  const ProductItem({
    Key? key,
    required this.title,
    required this.time,
    required this.personName,
    required this.city,
    required this.image,
    required this.customerProfile,
    required this.productId,
    required this.rate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool? isRead = AppStorage.getProduct()?.contains(productId);
    return Container(
      padding: EdgeInsets.only(bottom: 4, top: 4),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
        color: Theme.of(context).appBarTheme.backgroundColor,
        border: Border(
            // bottom: BorderSide(
            //   width: 0.5,
            //   color: Color(0xFFCDD4D9),
            // ),
            ),
      ),
      width: double.infinity,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            child: image == "https://roogr.sa/api/image/no_image.png"
                ? Image.asset(
                    "assets/images/no_icon.png",
                    width: double.infinity,
                    height: 112,
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
                    imageUrl: image,
                    width: double.infinity,
                    height: 112,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: LoadingIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: 12),
                  Text(
                    title.toString(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isRead == true ? Color(0xFFAA3DED) : null),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: AbsorbPointer(
                  absorbing: true,
                  child: RateWidget(
                    rate: rate,
                    itemSize: 15,
                    hItemPadding: 1,
                    vItemPadding: 5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              SizedBox(width: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  customerProfile,
                  width: 24,
                  height: 24,
                  fit: BoxFit.fill,
                  errorBuilder: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(width: 5),
              Text(
                personName.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: SvgPicture.asset(getIcon("icon3"),
                      color: Theme.of(context).primaryColor, height: 12)),
              SizedBox(width: 5),
              Text(
                city.toString().replaceAll('\n', ' '),
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              Icon(
                FontAwesomeIcons.clock,
                size: 12,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 5),
              Text(
                time.toString(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 8),
            ],
          ),
          // Row(
          //   children: [
          //     SizedBox(width: 16),
          //     Expanded(
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           SizedBox(height: 30),
          //           Row(
          //             children: [
          //               Flexible(
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     SizedBox(height: 8),
          //                     InkWell(
          //                       // onTap: () => RouteManager.navigateTo(StoreProfileView(storeId: )),
          //                       child: Row(
          //                         children: [],
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               Flexible(
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     SizedBox(height: 5),
          //                     Row(
          //                       children: [
          //                         Icon(
          //                           FontAwesomeIcons.clock,
          //                           size: 12,
          //                           color: Theme.of(context).primaryColor,
          //                         ),
          //                         SizedBox(width: 5),
          //                         Flexible(
          //                           child: Text(
          //                             time.toString(),
          //                             style: TextStyle(
          //                               fontSize: 10,
          //                               fontWeight: FontWeight.w700,
          //                             ),
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                     SizedBox(height: 15),
          //                     Row(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [],
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //     )
          //   ],
          // ),
        ],
      ),
    );
  }
}
