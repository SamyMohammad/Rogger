import 'package:flutter/material.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/product_details/view.dart';
import 'package:silah/shared_models/home_products_model.dart';
import 'package:silah/widgets/app/product_list.dart';

import '../../core/app_storage/app_storage.dart';

class ListProducts extends StatefulWidget {
  const ListProducts({
    super.key,
    required this.products,
  });

  final List<Product>? products;

  @override
  State<ListProducts> createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        right: 10,
      ),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            AppStorage.cacheProduct(widget.products![index].productId!);
            setState(() {});
            RouteManager.navigateTo(ProductDetailsView(
              productId: widget.products![index].productId,
            ));
          },
          child: ProductItem(
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
      // shrinkWrap: true,
      itemCount: widget.products!.length,
    );
  }
}
