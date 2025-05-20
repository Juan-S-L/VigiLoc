import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

// sk.eyJ1IjoianVhbmxvcGV6MDAiLCJhIjoiY21hZWNjMzUzMDY1NDJucHJkcGM2YXRzZyJ9.iISlOhAPSZLJ6SG8PGhoRg

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final String _mapboxToken = 'sk.eyJ1IjoianVhbmxvcGV6MDAiLCJhIjoiY21hZWNjMzUzMDY1NDJucHJkcGM2YXRzZyJ9.iISlOhAPSZLJ6SG8PGhoRg';

  // Lista de marcadores incidentes
  final List<Marker> _incidentMarkers = [
    // Comuna 4
    const Marker(point: LatLng(4.148845272770422, -73.62181266930513), width: 30, height: 30, child: Icon(Icons.circle, color: Colors.red, size: 20)),
    const Marker(point: LatLng(4.1501270821783605, -73.61967168205477), width: 30, height: 30, child: Icon(Icons.circle, color: Colors.red, size: 20)),
    const Marker(point: LatLng(4.150890990854768, -73.62340732069507), width: 30, height: 30, child: Icon(Icons.circle, color: Colors.red, size: 20)),
    const Marker(point: LatLng(4.152777092010187, -73.6205172044197), width: 30, height: 30, child: Icon(Icons.circle, color: Colors.red, size: 20)),
    const Marker(point: LatLng(4.148755776530934, -73.61931596238315), width: 30, height: 30, child: Icon(Icons.circle, color: Colors.red, size: 20)),
    const Marker(point: LatLng(4.150831679393795, -73.61704430720373), width: 30, height: 30, child: Icon(Icons.circle, color: Colors.red, size: 20)),
    const Marker(point: LatLng(4.151033338238222, -73.61918513407439), width: 30, height: 30, child: Icon(Icons.circle, color: Colors.red, size: 20)),
    const Marker(point: LatLng(4.149087921354136, -73.61522460393455), width: 30, height: 30, child: Icon(Icons.circle, color: Colors.red, size: 20)),
    const Marker(point: LatLng(4.152551709097587, -73.61501052135566), width: 30, height: 30, child: Icon(Icons.circle, color: Colors.red, size: 20)),
    const Marker(point: LatLng(4.1503334632228945, -73.62514376944236), width: 30, height: 30, child: Icon(Icons.circle, color: Colors.red, size: 20)),
    const Marker(point: LatLng(4.153313120750094, -73.62768905773348), width: 30, height: 30, child: Icon(Icons.circle, color: Colors.red, size: 20)),

    // Comuna 1
    const Marker(point: LatLng(4.1610497365615515, -73.6492560153921), width: 30, height: 30, child: Icon(Icons.circle, color: Colors.red, size: 20)),
    const Marker(point: LatLng(4.161422131129303, -73.64751358077757), width: 30, height: 30, child: Icon(Icons.circle, color: Colors.red, size: 20)),
    const Marker(point: LatLng(4.160698030417179, -73.65212895835937), width: 30, height: 30, child: Icon(Icons.circle, color: Colors.red, size: 20)),
    const Marker(point: LatLng(4.162435871013938, -73.65183855252653), width: 30, height: 30, child: Icon(Icons.circle, color: Colors.red, size: 20)),
    const Marker(point: LatLng(4.162239329709549, -73.65082213234327), width: 30, height: 30, child: Icon(Icons.circle, color: Colors.red, size: 20)),
    const Marker(point: LatLng(4.1601911595392185, -73.65023094907755), width: 30, height: 30, child: Icon(Icons.circle, color: Colors.red, size: 20)),
    const Marker(point: LatLng(4.158484346961666, -73.65221193135118), width: 30, height: 30, child: Icon(Icons.circle, color: Colors.red, size: 20)),


    // La rosita
    const Marker(point: LatLng(4.114297129535982, -73.60790382420464), width: 30, height: 30, child: Icon(Icons.circle, color: Colors.red, size: 20)),
    const Marker(point: LatLng(4.112541536543145, -73.6164138536584), width: 30, height: 30, child: Icon(Icons.circle, color: Colors.red, size: 20)),
    const Marker(point: LatLng(4.113064609534211, -73.61591040709672), width: 30, height: 30, child: Icon(Icons.circle, color: Colors.red, size: 20)),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(4.1492, -73.6351),
          initialZoom: 10.0,
          maxZoom: 18.0,
        ),
        children: [
          // Capa de tiles Mapbox
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}',
            additionalOptions: {
              'accessToken': _mapboxToken,
            },
          ),

          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
              maxClusterRadius: 45,
              size: const Size(50, 50),

              // Aquí vamos: definimos todas las animaciones dentro de animationsOptions
              animationsOptions: const AnimationsOptions(
                zoom: Duration(milliseconds: 300),
                fitBound: Duration(milliseconds: 300),
                fadeInCurve: Curves.easeIn,
                fadeOutCurve: Curves.easeOut,
                clusterExpandCurve: Curves.easeInOut,
                clusterCollapseCurve: Curves.easeInOut,
                sipderifyCurve: Curves.fastOutSlowIn,
                centerMarker: Duration(milliseconds: 300),
                centerMarkerCurves: Curves.easeInOut,
              ),

              // Builder para el círculo con conteo
              builder: (context, markers) => Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  markers.length.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              markers: _incidentMarkers,
              polygonOptions: const PolygonOptions(
                borderColor: Colors.blueAccent,
                color: Colors.black12,
                borderStrokeWidth: 3,
              ),

              // Otras configuraciones opcionales
              zoomToBoundsOnClick: true,
              spiderfyCircleRadius: 40,
              disableClusteringAtZoom: 16,
            ),
          ),
        ],
      ),
    );
  }
}