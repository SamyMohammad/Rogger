import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/product_details/view.dart';
import 'package:silah/shared/search/cubit.dart';
import 'package:silah/shared_cubit/theme_cubit/cubit.dart';
import 'package:silah/widgets/app_bar.dart';
import 'package:silah/widgets/loading_indicator.dart';

import '../../widgets/app/product_list.dart';

class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit()..getHistory(),
      child: Builder(builder: (context) {
        final cubit = SearchCubit.of(context);
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: appBarSize,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: appBarTopSpacing,
                    left: 10,
                    right: 10,
                  ),
                  child: Row(
                    children: [
                      BackButton(color: Theme.of(context).primaryColor),
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            cursorHeight: 20,
                            cursorColor: Theme.of(context).primaryColor,
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).primaryColor),
                            textInputAction: TextInputAction.search,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'البحث',
                              hintStyle: TextStyle(
                                  fontSize: 14, color: Color(0xFFACAFB8)),
                              hintTextDirection: TextDirection.rtl,
                              constraints: BoxConstraints(
                                maxHeight: 36,
                              ),
                              contentPadding: EdgeInsets.only(
                                right: 20,
                                bottom: 12,
                              ),
                            ),
                            onFieldSubmitted: cubit.search,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color:
                                Theme.of(context).appBarTheme.backgroundColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 1,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: ThemeCubit.of(context).isDark
                              ? Colors.transparent
                              : kGreyColor,
                          blurRadius: 1.5,
                          spreadRadius: 0.2,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: VIEW_PADDING,
            child: Column(
              children: [
                BlocBuilder(
                  bloc: cubit,
                  builder: (context, state) {
                    if (state is SearchLoading) {
                      return LoadingIndicator();
                    }
                    if (state is SearchEmpty) {
                      return Center(
                        child: Text(
                          'لا توجد نتائج!',
                        ),
                      );
                    }
                    if (cubit.searchModel == null) {
                      return Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('عمليات البحث الأخيرة'),
                                InkWell(
                                  onTap: cubit.clearHistory,
                                  child: Icon(FontAwesomeIcons.trashCan,
                                      color: Color(0xFF909090)),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Expanded(
                              child: ListView.separated(
                                itemCount: cubit.history.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    child: Text(cubit.history[index]),
                                    onTap: () => cubit.search(
                                        cubit.history[index],
                                        cache: false),
                                  );
                                },
                                separatorBuilder: (_, __) => Divider(),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: cubit.searchModel?.products.length ?? 0,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              RouteManager.navigateTo(ProductDetailsView(
                                productId: cubit
                                    .searchModel!.products[index].productId,
                              ));
                            },
                            child: ProductItem(
                              customerProfile: cubit
                                  .searchModel!.products[index].customerProfile,
                              productId:
                                  cubit.searchModel!.products[index].productId,
                              image: cubit.searchModel!.products[index].thumb,
                              title: cubit.searchModel!.products[index].name,
                              time: cubit
                                  .searchModel!.products[index].dateModified,
                              personName: cubit
                                  .searchModel!.products[index].customerName,
                              city: cubit.searchModel!.products[index].city,
                              rate: cubit.searchModel!.products[index].rate,
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          floatingActionButton: BlocBuilder(
            bloc: cubit,
            builder: (context, state) {
              return Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: cubit.nearest
                      ? Color(0xFF019CF6).withOpacity(.9)
                      : kPrimaryColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  icon: Icon(
                    FontAwesomeIcons.locationDot,
                    size: 22,
                    color: Colors.white,
                  ),
                  onPressed: cubit.toggleNearestButton,
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
