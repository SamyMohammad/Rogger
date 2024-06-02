import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/category_details/view.dart';
import 'package:silah/shared/home/grid.dart';
import 'package:silah/shared/home/list.dart';
import 'package:silah/shared/nav_bar/cubit/cubit.dart';
import 'package:silah/shared/nav_bar/cubit/states.dart';
import 'package:silah/shared_cubit/category_cubit/cubit.dart';
import 'package:silah/shared_cubit/category_cubit/states.dart';
import 'package:silah/shared_cubit/home_products/cubit.dart';
import 'package:silah/shared_cubit/home_products/states.dart';
import 'package:silah/store/add_product/view.dart';
import 'package:silah/widgets/app/category_item.dart';
import 'package:silah/widgets/loading_indicator.dart';

import '../../widgets/refresh_indicator.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final homeCubit = HomeProductsCubit.of(context);
    final categoryCubit = CategoryCubit.of(context);
    final navBarCubit = NavBarCubit.get(context);
    return Scaffold(
      body: BlocBuilder<HomeProductsCubit, HomeProductsStates>(
        builder: (context, state) => NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (homeCubit.selectedCategoryID == null &&
                !(state is HomeProductsMoreLoadingState)) {
              homeCubit.getMoreHomeProductsData(notification);
            }
            if (homeCubit.selectedCategoryID != null &&
                !(categoryCubit.state is CategoryMoreLoadingState)) {
              categoryCubit.getMoreProductsData(
                notification,
                homeCubit.selectedCategoryID!,
                homeCubit.nearestAds,
              );
            }
            return false;
          },
          child: Column(
            children: [
              BlocBuilder<CategoryCubit, CategoryStates>(
                builder: (context, state) {
                  final categoriesModel = categoryCubit.categoriesModel;
                  if (state is CategoryLoadingState &&
                      categoriesModel == null) {
                    return LoadingIndicator();
                  } else if (categoriesModel == null) {
                    return Center(
                      child: Text('لا يوجد أقسام مضافة حاليا'),
                    );
                  } else {
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: double.infinity,
                        maxHeight: 80,
                      ),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return CategoryItem(
                              isSelected: index == currentIndex,
                              title: 'الكل',
                              image: 'https://roogr.sa/api/allhome.png',
                              id: '0',
                              onPressed: () {
                                currentIndex = index;
                                homeCubit.getHomeProductsData();
                                homeCubit.selectCategory(null);
                                // homeCubit.selectCategory(category.categoryId);
                                // CategoryCubit.of(context).getCategoryProducts(category.categoryId!, homeCubit.nearestAds);
                              },
                            );
                          }
                          index = index - 1;
                          final category = categoriesModel.categories![index];
                          return CategoryItem(
                            isSelected: index + 1 == currentIndex,
                            title: category.name!,
                            image: category.image!,
                            id: category.id!,
                            onPressed: () {
                              currentIndex = index + 1;
                              if (currentIndex == 0) {
                                homeCubit.getHomeProductsData();
                                homeCubit.selectCategory(null);
                              } else {
                                final categoryID = categoryCubit
                                    .categoriesModel!
                                    .categories![currentIndex - 1]
                                    .id!;
                                homeCubit.selectCategory(categoryID);
                                CategoryCubit.of(context).getCategoryProducts(
                                    categoryID, homeCubit.nearestAds);
                              }
                              // _pageController.jumpToPage(currentIndex);
                              // homeCubit.selectCategory(category.categoryId);
                              // CategoryCubit.of(context).getCategoryProducts(category.categoryId!, homeCubit.nearestAds);
                            },
                          );
                        },
                        itemCount: categoriesModel.categories!.length + 1,
                        scrollDirection: Axis.horizontal,
                      ),
                    );
                  }
                },
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 10),
              //   child: Row(
              //     children: [
              //       // Text(
              //       //   'الاعلانات',
              //       //   style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              //       // ),
              //     ],
              //   ),
              // ),
              BlocBuilder<HomeProductsCubit, HomeProductsStates>(
                builder: (context, state) {
                  if (homeCubit.selectedCategoryID != null) {
                    return CategoryDetailsView(
                        categoryId: homeCubit.selectedCategoryID!, title: '');
                  }
                  final cubit = HomeProductsCubit.of(context);
                  final homeProducts = cubit.homeProductsModel;
                  if (state is HomeProductsLoadingState) {
                    return LoadingIndicator();
                  } else if (homeProducts == null) {
                    return Center(
                      child: Text('لا يوجد اعلانات مضافة حاليا'),
                    );
                  }
                  return Expanded(
                    child: CustomRefreshIndicator(
                      onRefresh: cubit.getHomeProductsData,
                      child: BlocBuilder<NavBarCubit, NavBarStates>(
                        builder: (context, state) {
                          return navBarCubit.isGridMode
                              ? GridProducts(products: homeProducts.products)
                              : ListProducts(products: homeProducts.products);
                        },
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder(
                bloc: HomeProductsCubit.of(context),
                builder: (context, state) =>
                    state is HomeProductsMoreLoadingState
                        ? LoadingIndicator()
                        : SizedBox(),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: !AppStorage.isLogged
          ? _NearestLocationButton()
          : (AppStorage.getUserModel()!.customerGroup == 2)
              ? Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(50)),
                  child: IconButton(
                      color: Colors.white,
                      icon: Icon(
                        FontAwesomeIcons.plus,
                        size: 22,
                      ),
                      onPressed: () =>
                          RouteManager.navigateTo(SAddProductView())),
                )
              : _NearestLocationButton(),
    );
  }
}

class _NearestLocationButton extends StatefulWidget {
  const _NearestLocationButton({Key? key}) : super(key: key);

  @override
  State<_NearestLocationButton> createState() => _NearestLocationButtonState();
}

class _NearestLocationButtonState extends State<_NearestLocationButton> {
  @override
  Widget build(BuildContext context) {
    final cubit = HomeProductsCubit.of(context);
    return Container(
      // radius: 22,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: cubit.nearestAds ? Colors.black : kPrimaryColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(50),
      ),
      child: IconButton(
        icon: Icon(
          FontAwesomeIcons.locationDot,
          size: 22,
          color: Colors.white,
        ),
        onPressed: () {
          // if (!AppStorage.isLogged) return;
          setState(() => cubit.nearestAds = !cubit.nearestAds);
          if (cubit.selectedCategoryID != null) {
            CategoryCubit.of(context).getCategoryProducts(
                cubit.selectedCategoryID!, cubit.nearestAds);
          } else {
            cubit.getHomeProductsData();
          }
        },
      ),
    );
  }
}
