import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/store/add_product/view.dart';
import 'package:silah/store/store_profile/cubit/cubit.dart';
import 'package:silah/store/store_profile/cubit/states.dart';
import 'package:silah/store/store_profile/units/category_listview_item.dart';
import 'package:silah/widgets/confirm_button.dart';

class CategoriesListviewSection extends StatelessWidget {
  final String storeId;
  const CategoriesListviewSection({super.key, required this.storeId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreProfileCubit, StoreProfileStates>(
      builder: (context, state) {
        final categories = StoreProfileCubit.of(context).categories?.categories;
        if (state is StoreProfileEmptyState) {
          if (storeId == AppStorage.getUserModel()!.customerId.toString()) {
            return Text('لا توجد اعلانات!');
          }
          return Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Text('يرجي اضافة اعلان اولا'),
              ConfirmButton(
                verticalMargin: 20,
                title: 'اضف اعلانك',
                color: kPrimaryColor,
                onPressed: () {
                  RouteManager.navigateTo(SAddProductView());
                },
              )
            ],
          );
        }
        if (categories == null) {
          return SizedBox();
        } else {
          //      WidgetsBinding.instance.addPostFrameCallback((_) {
          //   // This will ensure the first index is selected and its products are fetched
          //   StoreProfileCubit.of(context)
          //       .getCategoryProducts(categories.first.categoryId!,false);
          // });
          return Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 20, left: 12, right: 12),
            height: 55,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Center(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cubit = StoreProfileCubit.of(context);
                  final category = categories[index];
                  final categoryId = category.categoryId!;
                  final isSelected = categoryId == cubit.selectedCategory;
                  return CategoryListviewItem(
                    isSelected: isSelected,
                    categoryName: categories[index].name.toString(),
                    onTap: () => cubit.getCategoryProducts(categoryId),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
