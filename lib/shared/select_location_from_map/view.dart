import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:silah/constants.dart';
import 'package:silah/shared/select_location_from_map/cubit.dart';
import 'package:silah/shared/select_location_from_map/states.dart';
import 'package:silah/widgets/app_bar.dart';
import 'package:silah/widgets/confirm_button.dart';
import 'package:silah/widgets/loading_indicator.dart';

class SelectLocationFromMapView extends StatelessWidget {
  const SelectLocationFromMapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectLocationFromMapCubit()..initialize(),
      child: Scaffold(
        appBar: appBar(title: "حدد موقعك"),
        body: BlocBuilder<SelectLocationFromMapCubit,
            SelectLocationFromMapStates>(
          builder: (context, state) {
            final cubit = SelectLocationFromMapCubit.of(context);
            return Column(
              children: [
                if (cubit.initialLocation != null)
                  Expanded(
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: cubit.initialLocation!,
                        zoom: DEFAULT_MAP_ZOOM,
                      ),
                      myLocationEnabled: true,
                      markers: cubit.mapMarkers,
                      onTap: cubit.pickLocation,
                    ),
                  ),
                state is SelectLocationLoadingStates
                    ? LoadingIndicator()
                    : ConfirmButton(
                        title: 'حفظ',
                        horizontalMargin: VIEW_PADDING.horizontal,
                        onPressed: cubit.updateLocation,
                        verticalMargin: 10,
                        color: activeButtonColor),
                SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}
