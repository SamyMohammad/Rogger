import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/constants.dart';
import 'package:silah/shared/home/grid.dart';
import 'package:silah/shared/stores/cubit.dart';
import 'package:silah/shared_models/categories_model.dart';
import 'package:silah/shared_models/home_products_model.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({
    super.key,
    required this.category,
  });
  final Category category;

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  int currentIndex = 0;
  bool isSelected = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoresCubit()
        ..getSubCategories(widget.category.id)
        ..getCategoryProducts(id:  widget.category.id!)..init(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.category.name!),
          elevation: 1,
        ),
        body: Column(
          children: [
            SizedBox(height: 10),
            SizedBox(
              height: 30,
              child: BlocBuilder<StoresCubit, StoresStates>(
                builder: (context, state) {
                  final cubit = StoresCubit.of(context);
                  // cubit.getCategoryProducts();
                  // cubit.getCategoryProducts();
                  return ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      separatorBuilder: (context, index) => SizedBox(width: 6),
                      itemCount: cubit.subCategories.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        // if (index == 0) {
                        //   StoresCubit.of(context).getCategoryProducts();
                        // }
                        return InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onTap: () {
                            // final categoryId = category.categoryId ?? '';
                            currentIndex = index;

                            cubit.getCategoryProducts(
                                id: cubit.subCategories[index].id!);
                            // Navigator.pop(context);
                          },
                          child: Container(
                            width: 80,
                            child: Center(
                              child: Text(
                                cubit.subCategories[index].name!,
                                style: TextStyle(
                                    color: currentIndex == index
                                        ? kBackgroundCDarkColor
                                        : kDarkGreyColor),
                              ),
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: currentIndex == index
                                    ? Theme.of(context).scaffoldBackgroundColor
                                    : Theme.of(context).primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(25),
                              color: currentIndex == index
                                  ? kLightGreyColorEB
                                  : Theme.of(context).scaffoldBackgroundColor,
                              // color: kLightGreyColorEB,
                              // borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        );
                      });
                },
              ),
            ),
            SizedBox(height: 10),
            BlocBuilder<StoresCubit, StoresStates>(
              builder: (context, state) {
                final cubit = StoresCubit.of(context);

                return Expanded(
                    child: GridProducts(
                        products: List.generate(
                            cubit.categoryProductsModel?.products?.length ?? 0,
                                (index) => Product(
                                advertizerName: cubit.categoryProductsModel
                                    ?.products?[index].advertizerName,
                                advertizerRating: 4,
                                customerProfile: cubit.categoryProductsModel
                                    ?.products?[index].customerProfile,
                                location: cubit.categoryProductsModel
                                    ?.products?[index].location,
                                name: cubit.categoryProductsModel
                                    ?.products?[index].name,
                                price: cubit.categoryProductsModel
                                    ?.products?[index].price,
                                productId: cubit.categoryProductsModel
                                    ?.products?[index].productId,
                                sinceDate: cubit.categoryProductsModel
                                    ?.products?[index].sinceDate,
                                thumb: cubit.categoryProductsModel
                                    ?.products?[index].thumb))));
              },
            )
          ],
        ),
      ),
    );
  }
}
