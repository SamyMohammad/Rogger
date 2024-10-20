import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/store/store_profile/cubit/cubit.dart';
import 'package:silah/store/store_profile/cubit/states.dart';
import 'package:silah/store/store_profile/units/categories_listview_section.dart';
import 'package:silah/store/store_profile/units/followers_and_ratings_count.dart';
import 'package:silah/store/store_profile/units/products_gridview_section.dart';
import 'package:silah/store/store_profile/units/seller_header_section.dart';
import 'package:silah/store/store_profile/units/store_info_column.dart';
import 'package:silah/widgets/loading_indicator.dart';

class StoreProfileView extends StatefulWidget {
  const StoreProfileView({Key? key, required this.storeId}) : super(key: key);

  final String storeId;

  @override
  State<StoreProfileView> createState() => _StoreProfileViewState();
}

class _StoreProfileViewState extends State<StoreProfileView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoreProfileCubit(storeId: widget.storeId)..init(),
      child: BlocBuilder<StoreProfileCubit, StoreProfileStates>(
        builder: (context, state) {
          final cubit = StoreProfileCubit.of(context);
          final storeInfo = cubit.storeInfoModel;
          if (storeInfo == null) {
            return Scaffold(
              body: LoadingIndicator(),
            );
          }
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    SellerHeaderSection(
                        storeInfo: storeInfo,
                        cubit: cubit,
                        storeId: widget.storeId),
                    FollowersAndRatingsCount(
                        commentsModel: cubit.commentsModel,
                        storeInfo: storeInfo,
                        isFollowing: AppStorage.isLogged && cubit.isFollowing),
                    Transform.translate(
                        offset: Offset(0, -12),
                        child: StoreInfoColumn(
                            storeInfo: storeInfo,
                            cubit: cubit,
                            storeId: widget.storeId,
                            rate: cubit.getOverAllRating != null
                                ? double.parse(cubit.getOverAllRating ?? '0')
                                : null)),
                  ]),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverCategoriesDelegate(
                    child: CategoriesListviewSection(storeId: widget.storeId),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    ProductsGridviewSection(cubit: cubit),
                  ]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SliverCategoriesDelegate extends SliverPersistentHeaderDelegate {
  _SliverCategoriesDelegate({required this.child});

  final Widget child;

  @override
  double get maxExtent => 75.0; // adjust as needed

  @override
  double get minExtent =>
      75.0; // adjust as needed, make sure it's less than maxExtent

  @override
  bool shouldRebuild(_SliverCategoriesDelegate oldDelegate) {
    return false;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    double visibleExtent = maxExtent - max(minExtent, shrinkOffset);

    return SizedBox.expand(
      child: Padding(
        padding: EdgeInsets.only(top: max(0, visibleExtent - minExtent)),
        child: child,
      ),
    );
  }
}
