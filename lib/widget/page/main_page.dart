import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:otoge_mobile_app/model/store.dart';
import 'package:otoge_mobile_app/service/otoge_api.dart';
import 'package:otoge_mobile_app/service/location_service.dart';
import 'package:otoge_mobile_app/widget/component/search_app_bar.dart';
import 'package:otoge_mobile_app/widget/component/map_widget.dart';
import 'package:otoge_mobile_app/widget/component/location_list.dart';
import 'package:otoge_mobile_app/widget/component/search_nearby_button.dart';
import 'package:otoge_mobile_app/widget/component/store_card.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title, required this.otogeApi, required this.locationService});

  final String title;
  final OtogeApi otogeApi;
  final LocationService locationService;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _mapController = Completer<GoogleMapController>();
  final _pageController = PageController(viewportFraction: 0.8);
  PersistentBottomSheetController? _bottomSheetController;


  List<Store> _stores = [];
  Set<Marker> _markers = {};
  LatLngBounds? _bounds;
  bool _mapMoving = false, _mapDragging = false, _scrolling = false;
  LatLng _currentPosition = const LatLng(0, 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: SearchAppBar(
        onSearchQuerySubmitted: (context, query) async {
          if (query.isNotEmpty) {
            await searchByText(context, query);
          }
        },
        onActionButtonTap: (context) async {
          await searchByPosition(context, await widget.locationService.getCurrentLocation());
        },
      ),
      body: Stack(
        children: [
          Builder(builder: (context) {
            applyMapTheme();
            return MapWidget(
              locationService: widget.locationService,
              markers: _markers,
              onMapCreated: (controller) async {
                _mapController.complete(controller);
                final position = await widget.locationService.getCurrentLocation();
                if (context.mounted) {
                  await searchByPosition(context, position);
                  setState(() => _currentPosition = position);
                }
              },
              onMapMoving: (cameraPosition) {
                _currentPosition = cameraPosition.target;
                if (!_mapDragging) {
                  setState(() => _mapDragging = true);
                }
              },
              onMapMoved: () async {
                setState(() {
                  _mapMoving = false;
                  _mapDragging = false;
                });
              }
            );
          }),
        ],
      ),
      bottomNavigationBar: Visibility(
        visible: _bottomSheetController == null && !_mapMoving && _stores.isNotEmpty,
        child: SafeArea(
          child: Builder(builder: (context) {
            return Container(
              alignment: Alignment.centerLeft,
              height: 50,
              child: SizedBox.expand(
                child: TextButton(
                  style: TextButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero),
                  ),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Show List', textAlign: TextAlign.left)),
                  onPressed: () async {
                    await _showList(context);
                  },
                ),
              )
            );
          }),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Builder(builder: (context) {
        return SearchNearbyButton(
          visible: !_mapMoving && !_mapDragging && _bottomSheetController == null && (_bounds == null || !_bounds!.contains(_currentPosition)),
          enabled: !_mapMoving && !_mapDragging && _bottomSheetController == null,
          onPressed: () async {
            await searchByPosition(context, _currentPosition);
          },
        );
      })
    );
  }

  Future applyMapTheme() async {
    final controller = await _mapController.future;
    if (!context.mounted) {
      return;
    }

    if (Theme.of(context).brightness == Brightness.dark) {
      String darkStyle = await rootBundle.loadString('assets/style.dark.json');
      await controller.setMapStyle(darkStyle);
    } else {
      await controller.setMapStyle("[]");
    }
  }

  Future searchByText(BuildContext context, String text) async {
    await _performSearch(context, widget.otogeApi.searchByText(text));
  }

  Future searchByPosition(BuildContext context, LatLng position) async {
    await _performSearch(context, widget.otogeApi.searchByPosition(
        position.latitude,
        position.longitude
    ));
  }

  Future _performSearch(BuildContext context, Future<List<Store>> searchFun, {String? emptyMessage}) async {
    try {
      _bottomSheetController?.close();
      await _updateStates(context,  await searchFun);
    } on HttpException catch (ex) {
      _handleError("${ex.message} (${ex.statusCode})");
    } catch (ex, trace) {
      _handleError("${ex.toString()}\n\n$trace");
    } finally {
      if (context.mounted) {
        if (_stores.isEmpty) {
          emptyMessage ??= 'No location found';
          Scaffold.of(context).showBottomSheet(
            enableDrag: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            (context) {
              return Container(
                height: 35,
                margin: const EdgeInsets.only(top: 40),
                child: Material(
                  child: Center(child: Text(emptyMessage!))
                )
              );
            },
          );
        } else {
          _showList(context);
        }
      }
    }
  }

  Future _showList(BuildContext context) async {
    if (_bottomSheetController != null) {
      return;
    }

    if (_stores.isEmpty) {
      setState(() => _bottomSheetController = null);
      return;
    }

    final controller = Scaffold.of(context).showBottomSheet(
      elevation: 1,
      shape: const Border(),
      enableDrag: true,
      backgroundColor: Colors.transparent,
      (context) {
        return LocationList(
          stores: _stores,
          pageController: _pageController,
          itemBuilder: (context, store) {
            return GestureDetector(
              child: StoreCard(store: store),
              onTap: () async {
                await _focusTo(store: store);
              },
            );
          },
          onPageChanged: (store) async {
            if (!_scrolling) {
              await _focusTo(store: store, zoom: 16.0);
            }
          },
        );
      }
    );

    setState(() => _bottomSheetController = controller);

    _watchBottomSheet();
  }

  Future _watchBottomSheet() async {
    await _bottomSheetController!.closed;
    setState(() => _bottomSheetController = null);
  }

  Future _updateStates(BuildContext context, List<Store> stores) async {
    final markers = _computeMarkers(stores, (store) async {
      final index = stores.indexOf(store);
      if (_bottomSheetController == null) {
        await _showList(context);
        await Future.delayed(const Duration(milliseconds: 200)); // Hack: wait PageBuilder built
      }

      if (_pageController.hasClients) {
        _scrolling = true;
        await _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );

        _scrolling = false;
      }
    });

    final bounds  = _computeBounds(stores.map((store) => LatLng(store.lat, store.lng)).toList());
    if (bounds != null) {
      setState(() => _mapMoving = true);

      final controller = await _mapController.future;
      await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    }

    setState(() {
      _stores  = stores;
      _markers = markers;
      _bounds  = bounds;
    });
  }

  Future _focusTo({required Store store, double zoom = 17.0}) async {
    final mapController = await _mapController.future;
    await mapController.showMarkerInfoWindow(MarkerId(store.storeName));
    await mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(store.lat, store.lng),
          zoom: zoom
        )
      )
    );
  }

  Set<Marker> _computeMarkers(List<Store> stores, Function(Store) onTap) {
    return stores.map((store) =>
      Marker(
        markerId: MarkerId(store.storeName),
        position: LatLng(
          store.lat,
          store.lng
        ),
        infoWindow: InfoWindow(
          title: store.storeName,
        ),
        onTap: () {
          onTap(store);
        },
      )
    ).toSet();
  }

  LatLngBounds? _computeBounds(List<LatLng> positions) {
    if (positions.isEmpty) {
      return null;
    }

    var first = positions.first;
    var s = first.latitude,
        n = first.latitude,
        w = first.longitude,
        e = first.longitude;

    if (positions.length == 1) {
      positions.add(LatLng(s - 0.003, w - 0.003));
      positions.add(LatLng(s + 0.003, w + 0.003));
    }

    for (final latlng in positions) {
      s = min(s, latlng.latitude);
      n = max(n, latlng.latitude);
      w = min(w, latlng.longitude);
      e = max(e, latlng.longitude);
    }
    return LatLngBounds(southwest: LatLng(s, w), northeast: LatLng(n, e));
  }

  void _handleError(String error) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        icon: const Icon(Icons.error),
        title: const Text('Error'),
        content: Text(error),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      );
    });
  }
}
