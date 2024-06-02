import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/shared/home/grid.dart';
import 'package:silah/shared/home/list.dart';
import 'package:silah/shared/nav_bar/cubit/cubit.dart';
import 'package:silah/shared/nav_bar/cubit/states.dart';
import 'package:silah/widgets/refresh_indicator.dart';

import '../../shared_cubit/category_cubit/cubit.dart';
import '../../shared_cubit/category_cubit/states.dart';
import '../../shared_cubit/home_products/cubit.dart';
import '../../widgets/loading_indicator.dart';

class CategoryDetailsView extends StatelessWidget {
  CategoryDetailsView({Key? key, required this.categoryId, required this.title})
      : super(key: key);

  final String categoryId;
  final String title;
  @override
  Widget build(BuildContext context) {
    final homeCubit = HomeProductsCubit.of(context);
    final categoryCubit = CategoryCubit.of(context);
    final navBarCubit = NavBarCubit.get(context);

    return Expanded(
      child: CustomRefreshIndicator(
        onRefresh: () => categoryCubit.getCategoryProducts(
            homeCubit.selectedCategoryID!, homeCubit.nearestAds),
        child: BlocBuilder<CategoryCubit, CategoryStates>(
          builder: (context, state) {
            final cubit = CategoryCubit.of(context);
            final products = cubit.categoryProductsModel?.products;
            if (state is CategoryLoadingState) {
              return Center(child: LoadingIndicator());
            } else if (products == null || products.isEmpty) {
              return Center(
                child: Text('لا يوجد اعلانات مضافة حاليا'),
              );
            }
            return BlocBuilder<NavBarCubit, NavBarStates>(
              builder: (context, state) {
                return navBarCubit.isGridMode
                    ? GridProducts(products: products)
                    : ListProducts(products: products);
              },
            );
          },
        ),
      ),
    );
  }
}
