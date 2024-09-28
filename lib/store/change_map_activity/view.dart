import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/app_storage/app_storage.dart';
import 'package:silah/core/location/location_manager.dart';
import 'package:silah/store/change_map_activity/cubit.dart';
import 'package:silah/store/change_map_activity/states.dart';
import 'package:silah/store/change_map_activity/units/location_bottom_sheet.dart';
import 'package:silah/user/advertisers_on_map/map_categories_model.dart';

import 'units/choose_bottom_sheet.dart';

class SChangeMapActivityView extends StatefulWidget {
  const SChangeMapActivityView({Key? key}) : super(key: key);

  @override
  State<SChangeMapActivityView> createState() => _SChangeMapActivityViewState();
}

class _SChangeMapActivityViewState extends State<SChangeMapActivityView> {
  final cubit = ChangeMapActivityCubit();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit..getMapCategories(),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              margin: VIEW_PADDING,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  if (AppStorage.isStore)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: BlocBuilder(
                              bloc: cubit,
                              builder: (context, state) {
                                final categories =
                                    cubit.mapCategoriesModel?.mapCategories ??
                                        [];

                                // List items = categories
                                //     .map((category) =>
                                //         CustomRadioListTile<MapCategory>(
                                //           value: category,
                                //           groupValue: cubit.selectedMapCategory,
                                //           onChanged: (MapCategory? v) {
                                //             cubit.selectedMapCategory = v;
                                //           },
                                //           title: category.name,
                                //         ))
                                //     .toList();
                                if (categories.isEmpty) {
                                  return SizedBox.shrink();
                                }

                                //  showAdaptiveDialog(context: context, builder: (context) {
                                //
                                // });
                                if (state is ChangeMapActivityInitState) {
                                  return ChooseBottomSheet<MapCategory>(
                                      title: 'أقسام الخريطة',
                                      items: categories, // List of MapCategory
                                      selectedItem: cubit
                                          .selectedMapCategory, // Initially selected category
                                      itemLabelBuilder: (category) =>
                                          category.name ??
                                          '', // Customize how the category name is shown
                                      onItemSelected: (selectedCategory) {
                                        cubit.selectedMapCategory =
                                            selectedCategory;
                                        cubit.updateMapCategory(selectedCategory
                                            .id!); // Handle selection
                                        setState(() {}); // Update the UI
                                      });
                                } // return DropMenu(
                                //   isMapDepartment: true,
                                //   label: "قسم الخريطة",
                                //   hasBorder: true,
                                //   hint: 'الرجاء الاختيار',
                                //   isItemsModel: true,
                                //   borderColor: kPrimaryColor,
                                //   value: cubit.selectedMapCategory!,
                                //   items: categories,
                                //   onChanged: (v) {
                                //     cubit.selectedMapCategory = v;
                                //     cubit.updateMapCategory(
                                //         cubit.selectedMapCategory!.id!);
                                //   },
                                // );

                                return SizedBox.shrink();
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    )),
                                    builder: (context) {
                                      return LocationBottomSheet();
                                    });
                              },
                              child: Card(
                                shape: CircleBorder(),
                                color: kLightGreyColorEB,
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Image.asset(
                                    getAsset("location"),
                                    height: 20,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45),
                    child: Row(
                      children: [
                        Text(
                          'الحالة للخريطة : ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        BlocBuilder<ChangeMapActivityCubit,
                            ChangeMapActivityStates>(
                          builder: (context, state) => CupertinoSwitch(
                            activeColor: activeSwitchColor,
                            value: LocationManager.locationInfoModel
                                    ?.locationInfo?.locActive ==
                                '1',
                            onChanged: ChangeMapActivityCubit.of(context)
                                .toggleActivityStatus,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: 10),
                  // ConfirmButton(
                  //   color: kAccentColor,
                  //   onPressed: () =>
                  //       RouteManager.navigateTo(ProfileSettingView()),
                  //   title: 'تعديل اسم قسم الخريطة',
                  // ),
                  // ConfirmButton(
                  //   onPressed: () =>
                  //       RouteManager.navigateTo(SelectLocationView()),
                  //   title: 'تعديل الموقع',
                  // ),
                ],
              ),
            ),
            Builder(
              builder: (context) {
                final cubit = ChangeMapActivityCubit.of(context);
                return Expanded(
                  child: GoogleMap(
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LocationManager.currentLocationFromDevice ??
                          LocationManager.currentLocationFromServer ??
                          defaultLatLng,
                      zoom: DEFAULT_MAP_ZOOM,
                    ),
                    markers: cubit.mapMarkers,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomRadioListTile<T> extends StatelessWidget {
  final T? value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final String? title;
  final String? subtitle;

  CustomRadioListTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    this.subtitle = '',
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      value: value!,
      groupValue: groupValue,
      onChanged: onChanged,
      title: Text(title!),
      subtitle: subtitle!.isNotEmpty ? Text(subtitle!) : null,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }
}

class ElevatedRoundedButton extends StatelessWidget {
  final String title;
  final Color titleColor;
  final Color backgroundColor;
  final Widget icon;
  final VoidCallback onTap;
  final Color borderColor;
  final bool isSignOut;
  const ElevatedRoundedButton({
    required this.backgroundColor,
    required this.icon,
    required this.title,
    required this.titleColor,
    required this.borderColor,
    this.isSignOut = false,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: borderColor),
                  borderRadius: BorderRadius.circular(isSignOut ? 10 : 20)),
              backgroundColor: backgroundColor),
          onPressed: onTap,
          icon: icon,
          label: Text(
            title,
            style: TextStyle(
                color: titleColor, fontSize: 16, fontWeight: FontWeight.bold),
          )),
    );
  }
}
