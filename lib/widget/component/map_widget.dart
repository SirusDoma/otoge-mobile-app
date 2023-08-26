import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:otoge_mobile_app/service/location_service.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key, required this.locationService, required this.markers, this.bounds, this.onMapCreated, this.onMapMoving, this.onMapMoved});

  final LocationService locationService;
  final Function(GoogleMapController)? onMapCreated;
  final Function(CameraPosition)? onMapMoving;
  final Function()? onMapMoved;
  final Set<Marker> markers;
  final LatLngBounds? bounds;

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  final _controller = Completer<GoogleMapController>();
  Completer<LatLng> _locator = Completer<LatLng>();

  static const LatLng _defaultPosition = LatLng(35.6793168, 139.761269);

  @override
  void initState() {
    super.initState();
    setInitialLocation();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _locator.future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GoogleMap(
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
                compassEnabled: false,
                markers: widget.markers,
                cameraTargetBounds: CameraTargetBounds(widget.bounds),
                initialCameraPosition: CameraPosition(
                  target: snapshot.requireData,
                  zoom: 13,
                ),
                onCameraMove: widget.onMapMoving,
                onCameraIdle: widget.onMapMoved,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  widget.onMapCreated?.call(controller);
                },
            );
          } else if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(snapshot.error?.toString() ?? 'Unknown error occurred'),
                TextButton(
                  child: const Text('Retry'),
                  onPressed: () => setState(() {
                    _locator = Completer<LatLng>();
                    setInitialLocation();
                  }),
                )
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
    );
  }

  Future<LatLng> getCurrentLocation() async {
    bool hasPermission = await widget.locationService.requestPermission();
    if (!hasPermission) {
      throw Exception('The application does not have permission to access location feature.');
    }

    return widget.locationService.getCurrentLocation();
  }

  void setInitialLocation() async {
    try {
      _locator.complete(await getCurrentLocation());
    } catch (ex) {
      _locator.complete(_defaultPosition);
    }
  }
}
