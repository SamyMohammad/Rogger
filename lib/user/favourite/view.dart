import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/product_details/view.dart';
import 'package:silah/user/favourite/cubit/cubit.dart';
import 'package:silah/user/favourite/cubit/states.dart';
import 'package:silah/widgets/app_bar.dart';
import 'package:silah/widgets/loading_indicator.dart';

import '../../shared/product_details/cubit/cubit.dart';
import 'model.dart';

class FavouriteView extends StatelessWidget {
  const FavouriteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavouriteCubit()..getFavourites(),
      child: Scaffold(
        appBar: appBar(title: 'الاعلانات المفضلة'),
        body: BlocBuilder<FavouriteCubit, FavouriteStates>(
          builder: (context, state) {
            final favouriteData =
                FavouriteCubit.of(context).favouriteModel?.wishlistProducts;
            if (state is FavouriteLoadingStates) {
              return LoadingIndicator();
            } else if (favouriteData == null) {
              return Center(
                  child: Text(
                'المفضلة فارغة!',
              ));
            }
            return GridView.builder(
              shrinkWrap: true,
              padding: VIEW_PADDING,
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              itemCount: favouriteData.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.2),
              itemBuilder: (context, index) {
                return _FavouriteCard(item: favouriteData[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

class _FavouriteCard extends StatefulWidget {
  const _FavouriteCard({Key? key, required this.item}) : super(key: key);

  final WishlistProduct item;

  @override
  State<_FavouriteCard> createState() => _FavouriteCardState();
}

class _FavouriteCardState extends State<_FavouriteCard> {
  bool favourite = true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => RouteManager.navigateTo(ProductDetailsView(
        productId: widget.item.productId!,
      )),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.item.thumb.toString(),
                    fit: BoxFit.fill,
                    width: double.infinity,
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Text(
              //   widget.item.name.toString(),
              //   style: TextStyle(fontSize: 12),
              // )
            ],
          ),
          Positioned(
            top: 6,
            left: 6,
            child: InkWell(
              onTap: () {
                favourite = !favourite;
                setState(() {});
                ProductsDetailsCubit(widget.item.productId).toggleFavorite();
              },
              child: Container(
                padding: EdgeInsets.all(4),
                child: favourite
                    ? Icon(
                        favourite ? Icons.favorite : Icons.favorite_border,
                        color: favourite ? Colors.red : Colors.white,

                        // fill: favourite ? Colors.red : Colors.black,
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.favorite, // Filled heart icon
                            // size: 40, // Set the size of the icon
                            color: Colors.black
                                .withOpacity(.5), // Fill the inside with black
                          ),
                          Icon(
                            Icons.favorite_border, // Outlined heart icon
                            // size:
                            //     45, // Slightly larger size for the white border effect
                            color:
                                Colors.white, // Set the border color to white
                          ),
                        ],
                      ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // color: Color.fromRGBO(0, 0, 0, 0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
