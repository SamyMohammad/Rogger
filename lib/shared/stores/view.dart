import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:silah/shared/stores/cubit.dart';
import 'package:silah/shared/stores/units/ads_search_section.dart';
import 'package:silah/shared/stores/units/get_advertisers_model.dart';
import 'package:silah/shared/stores/units/stores_search_section.dart';
import 'package:silah/widgets/app_bar.dart';
import 'package:silah/widgets/custom_tabview.dart';

class StoresView extends StatelessWidget {
  const StoresView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoresCubit()
        ..getAds()
        ..filterStores(
            '', 1, PagingController<int, Advertisers>(firstPageKey: 1)),
      child: Builder(builder: (context) {
        final cubit = StoresCubit.of(context);
        return Scaffold(
          appBar: appBar(),
          body: Column(
            children: [
              CustomTabview(
                  firstTabTitle: "متاجر",
                  onTap: cubit.toggleSelection,
                  secondTabTitle: "إعلانات"),
              const SizedBox(height: 20),
              BlocBuilder<StoresCubit, StoresStates>(
                  builder: (context, states) {
                return cubit.isStoresSelected
                    ? StoresSearchSection(cubit: cubit)
                    : AdsSearchSection(
                        cubit: cubit,
                      );
              }),
            ],
          ),
          // floatingActionButton: BlocBuilder(
          //   bloc: cubit,
          //   builder: (context, state) {
          //     return Container(
          //       padding: EdgeInsets.all(5),
          //       decoration: BoxDecoration(
          //         color: cubit.nearest ? Colors.black : kGreyColor,
          //         borderRadius: BorderRadius.circular(50),
          //       ),
          //       child: IconButton(
          //         icon: Icon(
          //           FontAwesomeIcons.locationDot,
          //           size: 22,
          //           color: Colors.white,
          //         ),
          //         onPressed: cubit.toggleNearestButton,
          //       ),
          //     );
          //   },
          // ),
        );
      }),
    );
  }
}
