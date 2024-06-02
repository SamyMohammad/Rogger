import 'package:flutter/material.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/product_details/view.dart';
import 'package:silah/shared_models/products_model.dart';

class ProductGridviewTile extends StatelessWidget {
  final Product product;
  const ProductGridviewTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        RouteManager.navigateTo(ProductDetailsView(
          productId: product.productId,
        ));
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              product.thumb.toString(),
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: UnconstrainedBox(
              constrainedAxis: Axis.horizontal,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                alignment: Alignment.centerRight,
                child: Text(
                  product.name.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.0, 0.8, 1.0],
                    colors: [
                      Color.fromRGBO(0, 0, 0, 0.6),
                      Color.fromRGBO(0, 0, 0, 0.3),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(10),
                  ),
                  // color: Color.fromRGBO(0, 0, 0, 0.7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
