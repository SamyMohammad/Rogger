import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silah/store/store_profile/cubit/cubit.dart';
import 'package:silah/store/store_profile/cubit/states.dart';
import 'package:silah/store/store_profile/units/product_gridview_tile.dart';
import 'package:silah/widgets/loading_indicator.dart';

class ProductsGridviewSection extends StatelessWidget {
  const ProductsGridviewSection({
    super.key,
    required this.cubit,
  });

  final StoreProfileCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: cubit,
      builder: (context, state) {
        if (state is StoreProfileEmptyState) {
          return SizedBox();
        }
        if (state is StoreProfileLoadingState) {
          return SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.9,
            child: Center(
              child: LoadingIndicator(),
            ),
          );
        }
        final products = StoreProfileCubit.of(context).productsModel?.products;
        print(products);
        if (products == null || products.isEmpty) {
          return Text('لا يوجد منتجات في هذا القسم');
        } else
          return GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              itemCount: products.length,
              padding:
                  EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 168 / 220,
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemBuilder: (context, index) {
                return ProductGridviewTile(product: products[index]);
              });
      },
    );
  }
}
