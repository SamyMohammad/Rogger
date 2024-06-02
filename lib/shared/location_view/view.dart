import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:silah/core/location/location_manager.dart';
import 'package:silah/core/router/router.dart';
import 'package:silah/widgets/app_bar.dart';
import 'package:silah/widgets/confirm_button.dart';

import '../../constants.dart';

class LocationView extends StatefulWidget {
  const LocationView(
      {Key? key, this.location, this.onConfirm, required this.viewOnly})
      : super(key: key);

  final LatLng? location;
  final Function(LatLng)? onConfirm;
  final bool viewOnly;

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: '',
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              markers: markers,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: widget.location ??
                    LocationManager.currentLocationFromServer ??
                    defaultLatLng,
                zoom: 16,
              ),
              onTap: (value) {
                if (widget.viewOnly) return;
                markers
                    .add(Marker(markerId: MarkerId('marker'), position: value));
                setState(() {});
              },
              onMapCreated: (controller) {
                if (widget.location != null) {
                  markers.add(Marker(
                      markerId: MarkerId('marker'),
                      position: widget.location!));
                  setState(() {});
                }
              },
            ),
          ),
          if (!widget.viewOnly)
            ConfirmButton(
              horizontalMargin: VIEW_PADDING.horizontal,
              title: 'ارسال الموقع',
              onPressed: markers.isEmpty
                  ? null
                  : () {
                      if (markers.isNotEmpty) {
                        RouteManager.pop();
                        widget.onConfirm!(markers.first.position);
                      }
                    },
            ),
        ],
      ),
    );
  }
}
