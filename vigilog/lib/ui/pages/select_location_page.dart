import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({super.key, this.initialCenter});
  final LatLng? initialCenter;

  @override
  State<SelectLocationPage> createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  late LatLng _pickedLocation;

  @override
  void initState() {
    super.initState();
    _pickedLocation = widget.initialCenter ?? const LatLng(4.1480, -73.6320);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context, _pickedLocation);
            },
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: widget.initialCenter ?? const LatLng(4.1480, -73.6320),
          initialZoom: 13.0,
          onTap:(tapPosition, latlng) {
            setState(() {
              _pickedLocation = latlng;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}',
            additionalOptions: const {
              'accessToken': 'Tu token de Mapbox aquí',
            },
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _pickedLocation,
                width: 30,
                height: 30,
                child: const Icon(
                  Icons.location_on, 
                  color: Colors.blue, 
                  size: 30
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}