
import 'package:flutter/material.dart';

import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:otoge_mobile_app/model/store.dart';

class StoreCard extends StatelessWidget {
  const StoreCard({super.key, required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(top: 0, bottom: 10, left: 5, right: 5),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SizedBox(
        width: 290,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: ListTile(
                      //leading: const Icon(Icons.business),
                      title: Text(store.storeName),
                      subtitle: Visibility(
                        visible: store.alternateStoreName != null,
                        child: Text(
                          store.alternateStoreName ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                          )
                        )
                      ),
                      visualDensity: const VisualDensity(vertical: VisualDensity.minimumDensity),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.orange.shade700,
                        minimumSize: const Size(45, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // <-- Radius
                        )
                      ),
                      onPressed: () {
                        _launchMap(context, store);
                      },
                      child: const Icon(Icons.map, color: Colors.white)
                    )
                  )
                ],
              ),

              ListTile(
                //leading: const Icon(Icons.location_pin),
                title: Text(
                    store.address,
                    style: const TextStyle(fontSize: 12)
                ),
                subtitle: Visibility(
                  visible: store.alternateAddress != null,
                  child: Text(
                    store.alternateAddress ?? '',
                    style: const TextStyle(
                      fontSize: 8,
                    )
                  )
                ),
                dense: true,
                isThreeLine: true,
                visualDensity: const VisualDensity(vertical: VisualDensity.minimumDensity),
              ),
              ListTile(
                minLeadingWidth: 0,
                minVerticalPadding: 10,
                title: Wrap(
                  spacing: 4.0,
                  runSpacing: 1,
                  children: store.cabinets.map((cab) =>
                    Chip(
                      label: Text(cab.game.name, style: const TextStyle(fontSize: 10, color: Colors.white)),
                      backgroundColor: Colors.orange.shade700,
                      padding: EdgeInsets.zero,
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity
                      ),
                    )
                  ).toList()
                ),
              ),
            ],
          ),
        )
      )
    );
  }

  Future _launchMap(BuildContext context, Store store) async {
    MapType? mapType = MapType.google;
    if (await MapLauncher.isMapAvailable(MapType.google) != true) {
      var maps = await MapLauncher.installedMaps;
      if (maps.isNotEmpty) {
        mapType = maps.first.mapType;
      } else {
        mapType = null;
      }
    }

    if (mapType != null) {
      await MapLauncher.showMarker(
        mapType: mapType,
        coords: Coords(store.lat, store.lng),
        title: store.storeName,
        description: store.address
      );
    } else {
      // No map application installed, launch google map in web
      var uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=${store.lat},${store.lng}");
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else if (context.mounted) {
        await showDialog(context: context, builder: (context) {
          return AlertDialog(
            icon: const Icon(Icons.error),
            title: const Text('Error'),
            content: const Text('Failed to launch the map.'),
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
  }
}