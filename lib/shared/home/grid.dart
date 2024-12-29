import 'package:flutter/material.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/product_details/view.dart';
import 'package:silah/shared_models/home_products_model.dart';
import 'package:silah/widgets/app/product_list.dart';

class GridProducts extends StatefulWidget {
  const GridProducts({
    super.key,
    required this.products,
  });

  final List<Product>? products;

  @override
  State<GridProducts> createState() => _GridProductsState();
}

class _GridProductsState extends State<GridProducts> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: VIEW_PADDING,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        //  mainAxisExtent: 220,
        childAspectRatio: MediaQuery.of(context).size.width <= 360
        
            ? .63// Adjusted for smaller screens
            : .67,
        crossAxisSpacing: 8, //18,
        mainAxisSpacing: 8, //12,
      ),
      itemCount: widget.products!.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            AppStorage.cacheProduct(widget.products![index].productId!);
            setState(() {});
            RouteManager.navigateTo(ProductDetailsView(
              productId: widget.products![index].productId,
            ));
          },
          child: GridProductItem(
            customerProfile: widget.products![index].customerProfile ?? '',
            rate: widget.products![index].advertizerRating?.toDouble() ?? 0.0,
            productId: widget.products![index].productId!,
            image: widget.products![index].thumb!,
            title: widget.products![index].name!,
            time: widget.products![index].sinceDate!,
            city: widget.products![index].location!,
            personName: widget.products![index].advertizerName!,
          ),
        );
      },
    );
  }
}
