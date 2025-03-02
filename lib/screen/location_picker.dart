import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:linkjo/service/location_service.dart';
import 'package:linkjo/utils/log.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({super.key});

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  final MapController _mapController = MapController();
  List<Marker> _markers = [];
  String _address = '';
  String _city = '';
  double _latitude = -6.2088;
  double _longitude = 106.8456;

  void animatedMove(
      MapController mapController, LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
      begin: mapController.camera.center.latitude,
      end: destLocation.latitude,
    );

    final lngTween = Tween<double>(
      begin: mapController.camera.center.longitude,
      end: destLocation.longitude,
    );

    final zoomTween = Tween<double>(
      begin: mapController.camera.zoom,
      end: destZoom,
    );

    const int animationDuration = 1000; 
    const int frameRate = 60; 
    const int frameTime = animationDuration ~/ frameRate; 

    for (int i = 0; i <= frameRate; i++) {
      Future.delayed(Duration(milliseconds: i * frameTime), () {
        final progress = i / frameRate;

        final newLat = latTween.lerp(progress);
        final newLng = lngTween.lerp(progress);
        final newZoom = zoomTween.lerp(progress);

        mapController.moveAndRotate(
          LatLng(newLat, newLng),
          newZoom,
          0,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(-6.2088, 106.8456),
              initialZoom: 15.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom,
              ),
              onTap: (tapPosition, point) async {
                setState(() {
                  _address = 'Loading...';
                  _city = '';
                });
                final adr = await LocationService.getAddressFromLocation(
                  point.latitude,
                  point.longitude,
                );
                animatedMove(_mapController, point, 15.0);
                if (adr != null) {
                  Log.d(adr);
                  setState(() {
                    _address = adr['display_name'];
                    var address = adr['address'];
                    _city = address['county'] ?? address['city'];
                  });
                }
                setState(() {
                  _latitude = point.latitude;
                  _longitude = point.longitude;
                  _markers = [
                    Marker(
                      width: 60.0,
                      height: 60.0,
                      point: LatLng(_latitude, _longitude),
                      alignment: Alignment.topCenter,
                      child: const Icon(
                        Icons.location_on,
                        size: 60.0,
                        color: Colors.redAccent,
                      ),
                    ),
                  ];
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(markers: _markers),
            ],
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Selected Address:",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Text(_address),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, {
                          'latitude': _latitude,
                          'longitude': _longitude,
                          'address': _address,
                          'city': _city,	
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: Text(
                        'Select Location',
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: Colors.white,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
