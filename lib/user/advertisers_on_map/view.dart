import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:silah/constants.dart';
import 'package:silah/core/location/location_manager.dart';
import 'package:silah/user/advertisers_on_map/cubit/cubit.dart';
import 'package:silah/user/advertisers_on_map/cubit/states.dart';
import 'package:silah/widgets/loading_indicator.dart';

import '../../core/app_storage/app_storage.dart';
import '../../core/router/router.dart';
import '../../store/store_profile/view.dart';
import '../../widgets/app/online_status_tile.dart';
import 'model.dart';

class UAdvertiserOnMapView extends StatefulWidget {
  const UAdvertiserOnMapView({Key? key}) : super(key: key);

  @override
  State<UAdvertiserOnMapView> createState() => _UAdvertiserOnMapViewState();
}

class _UAdvertiserOnMapViewState extends State<UAdvertiserOnMapView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdvertisersOnMapCubit()..getAdvertisers(),
      child: Scaffold(
        body: BlocBuilder<AdvertisersOnMapCubit, AdvertisersOnMapStates>(
          builder: (context, state) {
            final cubit = AdvertisersOnMapCubit.of(context);
            if (state is AdvertisersOnMapLoadingStates) {
              return LoadingIndicator();
            }
            final categories = cubit.mapCategoriesModel?.mapCategories ?? [];
            return Stack(
              children: [
                CustomGoogleMapMarkerBuilder(
                  customMarkers: cubit.advertisersOnMapModel?.advertizers
                      ?.map((e) {
                    return MarkerData(
                      child: AdvertiserOnMap(
                        e: e,
                      ),
                      marker: Marker(
                        markerId: MarkerId(e.advertizerId!),
                        position: e.location!,
                        visible: e.nickname != null,
                        onTap: () {
                          AppStorage.cacheAdvertiser(e.advertizerId!);
                          setState(() {});
                          RouteManager.navigateTo(
                              StoreProfileView(storeId: e.advertizerId!));
                        },
                        // infoWindow: InfoWindow(
                        //   title: e.nickname ?? '',
                        //   onTap: () => RouteManager.navigateTo(StoreProfileView(storeId: e.advertizerId!)),
                        // ),
                      ),
                    );
                  }).toList() ??
                      [],
                  builder: (context, markers) => GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LocationManager.currentLocationFromDevice ??
                          LocationManager.currentLocationFromServer ??
                          defaultLatLng,
                      zoom: 16,
                    ),
                    markers: markers ?? {},
                    onMapCreated: (controller) =>
                    cubit.googleMapController = controller,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: InkWell(
                    onTap: cubit.showCurrentLocation,
                    child: CircleAvatar(
                      radius: 28,
                      child: Icon(Icons.gps_fixed),
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 30,
                    right: 5,
                  ),
                  height: 40,
                  child: ListView.builder(
                    key: PageStorageKey<String>('pageOne'),
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, i) {
                      // if (i == 0) {
                      //   return InkWell(
                      //       onTap: () {},
                      //       child: _CategoryTile(
                      //           isSelected: false, title: "الكل"));
                      // }
                      // final index = 0;
                      final category = categories[i];
                      final isSelected =
                          cubit.selectedMapCategory?.id == category.id;
                      return InkWell(
                        onTap: () => cubit.toggleMapCategory(category),
                        child: _CategoryTile(
                            title: category.name!, isSelected: isSelected),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AdvertiserOnMap extends StatelessWidget {
  const AdvertiserOnMap({super.key, required this.e});

  final Advertizer e;
  @override
  Widget build(BuildContext context) {
    bool? isRead = AppStorage.getAdvertisers()?.contains(e.advertizerId);
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              e.profile ??
                  'https://brandlogos.net/wp-content/uploads/2021/12/kfc-brandlogo.net_.png',
              fit: BoxFit.fill,
              width: 60,
              height: 60,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    e.nickname ?? '',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isRead == true ? Color(0xFFAA3DED) : null),
                  ),
                  SizedBox(height: 5),
                  OnlineStatusTile(userID: e.advertizerId!),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.title,
    required this.isSelected,
  });

  final String title;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          // Image.network(
          //   category.image!,
          //   width: 32,
          //   height: 32,
          // ),
          // SizedBox(width: 5),
          Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isSelected ? Colors.black : Colors.white,
        border: Border.all(color: Colors.black, width: 0.45),
      ),
    );
  }
}
