import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/shared/stores/cubit.dart';
import 'package:silah/shared/stores/units/get_advertisers_model.dart';
import 'package:silah/store/store_profile/view.dart';
import 'package:silah/widgets/loading_indicator.dart';

import '../../../core/dio_manager/dio_manager.dart';
import '../../../widgets/rate_widget.dart';

class StoresSearchSection extends StatefulWidget {
  const StoresSearchSection({
    super.key,
    required this.cubit,
  });

  final StoresCubit cubit;

  @override
  State<StoresSearchSection> createState() => _StoresSearchSectionState();
}

class _StoresSearchSectionState extends State<StoresSearchSection> {
  int pageNumber = 1;
  List<Advertisers> advertisers = [];
  bool shouldLoadNextPage = false;
  late TextEditingController controller;
  int currentIndex = 0;
  PagingController<int, Advertisers> pagingController =
      PagingController<int, Advertisers>(
    // 2
    firstPageKey: 1,
  );
  GetAdvertisersModel? getAdvertisersModel;

  Future<void> filterStores(
    int page, {
    bool? verfied,
    String? type,
    String term = '',
  }) async {
    try {
      final Map<String, dynamic> requestData = {
        'page': page,
        'limit': 10,
        'trem': _searchTerm,
      };

      // Add 'verfied' to requestData if it's not null
      if (verfied != null) {
        requestData['verfied'] = verfied;
      }
      if (type != null) {
        requestData['type'] = type;
      }
      final response = await DioHelper.post('customer/account/advertisers',
          data: requestData);

      getAdvertisersModel = GetAdvertisersModel.fromJson(response.data);
      // subCategories = getSubCategory?.categories??[];
      //

      final newItems = getAdvertisersModel?.advertisers ?? [];

      newItems.forEach((element) {});

      bool isLastPage = newItems.length < 10;

      if (isLastPage) {
        // 3
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = page + 1;

        pagingController.appendPage(newItems, nextPageKey);
      }

      // pagingController.refresh();
      // emit(GetAdvertisersSuccessState(newItems));
    } catch (e) {
      // emit(GetAdvertisersErrorState(e.toString()));
    }
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: '');
    // scrollController.addListener(() {
    //   if (scrollController.position.atEdge) {
    //     bool isTop = scrollController.position.pixels == 0;
    //     if (!isTop) {
    //
    //       shouldLoadNextPage = true;
    //       setState(() {});
    //     }
    //   }
    // });
    // controller.addListener(_updateSearchTerm);

    pagingController.addPageRequestListener((pageKey) {
      filterStores(pageKey);
    });
  }

  String? _searchTerm;
  void _updateSearchTerm(String text) {
    const duration = Duration(milliseconds: 800);
    _debouncer.debounce(
      duration: duration,
      onDebounce: () {
        _searchTerm = text;
        pagingController.itemList?.clear();
        // filterStores(1, term: _searchTerm ?? '');

        pagingController.refresh();
      },
    );
  }

  final Debouncer _debouncer = Debouncer();

  @override
  Widget build(BuildContext context) {
    List storeKind = ['الكل', 'مضمون', 'سجل تجاري', 'معروف', 'عمل حر'];
    String handleCategory(int index) {
      List<String> verificationTypesList = [
        "Commercial Register",
        "Identity Document",
        "Freelancer Document"
      ];

      return verificationTypesList[index - 2];
    }

    return Expanded(
        child: Column(
      children: [
        SizedBox(
          height: 30,
          child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 6),
              separatorBuilder: (context, index) => SizedBox(width: 6),
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: kLightGreyColorEB)),
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: currentIndex == index
                          ? kLightGreyColorEB
                          : Colors.transparent,
                    ),
                    onPressed: () {
                      currentIndex = index;

                      if (index == 1) {
                        pagingController.itemList?.clear();
                        filterStores(
                          1,
                          verfied: true,
                        );
// pagingController.removePageRequestListener((pageKey) { });
//                         pagingController.refresh();
                      } else if (index == 0) {
                        pagingController.itemList?.clear();

                        filterStores(
                          1,
                        );
                        // pagingController.refresh();
                      } else {
                        pagingController.itemList?.clear();
                        filterStores(1, type: handleCategory(index));
                        // pagingController.refresh();
                      }
                      setState(() {});
                      // cubit.getCategoryProducts(
                      //     cubit.subCategories[index].id!);
                      // Navigator.pop(context);
                    },
                    child: Container(
                      // width: 80,
                      child: Center(
                        child: Text(
                          storeKind[index],
                          style: TextStyle(
                              color: currentIndex == index
                                  ? Colors.black
                                  : kLightGreyColorB4),
                        ),
                      ),
                      decoration: BoxDecoration(
                        // color: ThemeCubit.of(context).isDark?Theme.of(context).appBarTheme.backgroundColor:kDarkGreyColor ,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                );
              }),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 55),
          child: TextFormField(
            cursorHeight: 20,
            cursorColor: Theme.of(context).primaryColor,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).primaryColor,
            ),
            textInputAction: TextInputAction.search,
            controller: controller,
            onChanged: _updateSearchTerm,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: kGreyButtonColorD9)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: kGreyButtonColorD9)),
              hintText: 'البحث',
              hintStyle: TextStyle(fontSize: 14, color: Color(0xFFACAFB8)),
              hintTextDirection: TextDirection.rtl,
              constraints: BoxConstraints(
                maxHeight: 36,
              ),
              contentPadding: EdgeInsets.only(
                right: 20,
                bottom: 12,
              ),
            ),
            // onFieldSubmitted: cubit.search,
          ),
        ),
        SizedBox(height: 10),
        BlocBuilder<StoresCubit, StoresStates>(
          builder: (context, state) {
            //  if (state is GetAdvertisersSuccessState)

            return Expanded(
                child: PagedListView.separated(
              // 4
              // physics: const BouncingScrollPhysics(),

              pagingController: pagingController,
              padding: EdgeInsets.symmetric(horizontal: 13, vertical: 8),

              // padding: const EdgeInsets.all(16),
              separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
              builderDelegate: PagedChildBuilderDelegate<Advertisers>(
                animateTransitions: true,

                transitionDuration: const Duration(milliseconds: 600),
                newPageProgressIndicatorBuilder: (context) => SizedBox(
                  height: 50,
                  width: 50,
                  child: LoadingIndicator(),
                ),
                firstPageProgressIndicatorBuilder: (context) =>
                    LoadingIndicator(),
                itemBuilder: (context, advertiser, index) => InkWell(
                  onTap: () {
                    RouteManager.navigateTo(StoreProfileView(
                      storeId: advertiser.customerId!,
                    ));
                  },
                  child: Material(
                    elevation: 2, // Elevation (shadow)
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                        // border: Border.all(color: kLightGreyColorEB),
                      ),
                      height: 90,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: advertiser.profile !=
                                    'https://roogr.sa/api/image/'
                                ? Image.network(
                                    advertiser.profile ?? getAsset('person'),
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.fill,
                                  )
                                : Image.asset(
                                    getAsset('person'),
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.scaleDown,
                                    scale: 1.5,
                                  ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      advertiser.name ?? '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 2),
                                    if (advertiser.verifiedFlag ?? false)
                                      Image.asset(
                                        getAsset("verified"),
                                        height: 15,
                                      )
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    advertiser.nickname == null ||
                                            advertiser.nickname == ''
                                        ? ''
                                        : '${advertiser.nickname}@',
                                    style: TextStyle(
                                      color: Color(0xFF7C7A7A),
                                    ),
                                  ),
                                ),
                                if (advertiser.nickname != null &&
                                    advertiser.nickname != '')
                                  SizedBox(height: 10),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RateWidget(
                                          ignoreGestures: true,
                                          hItemPadding: .5,
                                          rate: double.parse(
                                              advertiser.rating ?? '0')),
                                      Row(
                                        children: [
                                          Image.asset(getAsset("unlike"),
                                              height: 13,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          SizedBox(width: 10),
                                          Image.asset(getAsset("like"),
                                              height: 13,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          SizedBox(width: 10),
                                          Text(
                                            advertiser.ratingCount ?? "0",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 10),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                // firstPageErrorIndicatorBuilder: (context) => ErrorIndicator(
                //   error: widget.pagingController.error,
                //   onTryAgain: () => widget.pagingController.refresh(),
                // ),
                noItemsFoundIndicatorBuilder: (context) => Center(
                    child: Text(
                  "لا يوجد نتائج",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                )),
              ),
            ));

            return const SizedBox.shrink();
          },
        )
      ],
    ));
  }
}
