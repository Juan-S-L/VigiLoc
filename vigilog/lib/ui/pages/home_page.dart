import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:vigilog/data/incident.dart';
import 'package:vigilog/logic/incident_map_controller.dart';
import 'package:vigilog/ui/pages/add_incident_page.dart';

//  api: sk.eyJ1IjoianVhbmxvcGV6MDAiLCJhIjoiY21hZWNjMzUzMDY1NDJucHJkcGM2YXRzZyJ9.iISlOhAPSZLJ6SG8PGhoRg

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = IncidentMapController();
  final _popupController = PopupController();
  final _mapController = MapController();

  // Llevar el zoom actual del mapa
  double _currentZoom = 11.0;
  // Mismo umbral que disableClusteringAtZoom
  static const int _disableClusteringZoom = 16;

  // Busqueda y filtro
  String _searchText = '';
  final Set<Severity> _activeFilters = {
    Severity.low,
    Severity.medium,
    Severity.high,
  };

  @override
  Widget build(BuildContext context) {
    // 1) Aplicar búsqueda y filtros
    final filtered = _controller.incidents.where((inc) {
      final text = _searchText.toLowerCase();
      final matchesText = inc.title.toLowerCase().contains(text) ||
          inc.description.toLowerCase().contains(text);
      final matchesFilter = _activeFilters.contains(inc.severity);
      return matchesText && matchesFilter;
    }).toList();

    // 2) Crear marcadores a partir de la lista filtrada
    final markers = filtered.map((inc) {
      return Marker(
        key: ValueKey(inc.id),
        point: inc.location,
        width: 30,
        height: 30,
        child: Icon(
          Icons.circle,
          color: inc.severity.color,
          size: 30,
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Buscar incidentes...',
            border: InputBorder.none,
            icon: Icon(Icons.search, color: Colors.white),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (v) => setState(() => _searchText = v),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Filtros por gravedad
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Wrap(
              spacing: 8,
              children: Severity.values.map((sev) {
                return ChoiceChip(
                  label: Text(sev.name.toUpperCase()),
                  selected: _activeFilters.contains(sev),
                  selectedColor: sev.color.withOpacity(0.6),
                  backgroundColor: Colors.grey.shade200,
                  labelStyle: TextStyle(
                    color:
                        _activeFilters.contains(sev) ? Colors.white : sev.color,
                  ),
                  onSelected: (on) {
                    setState(() {
                      if (on) {
                        _activeFilters.add(sev);
                      } else {
                        _activeFilters.remove(sev);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          // Mapa expandido
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(4.1480, -73.6320),
                initialZoom: _currentZoom,
                maxZoom: 18,
                onPositionChanged: (pos, _) {
                  setState(() {
                    _currentZoom = pos.zoom;
                  });
                  if (_currentZoom < _disableClusteringZoom) {
                    _popupController.hideAllPopups();
                  }
                },
                onTap: (_, __) => _popupController.hideAllPopups(),
              ),
              children: [
                // Capa base Mapbox
                TileLayer(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}',
                  additionalOptions: const {
                    'accessToken':
                        'sk.eyJ1IjoianVhbmxvcGV6MDAiLCJhIjoiY21hZWNjMzUzMDY1NDJucHJkcGM2YXRzZyJ9.iISlOhAPSZLJ6SG8PGhoRg',
                  },
                ),

                // 1) Clustering cuando zoom < umbral
                if (_currentZoom < _disableClusteringZoom)
                  MarkerClusterLayerWidget(
                    options: MarkerClusterLayerOptions(
                      maxClusterRadius: 45,
                      size: const Size(50, 50),
                      markers: markers,
                      disableClusteringAtZoom: _disableClusteringZoom,
                      builder: (ctx, clustered) => Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          clustered.length.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      spiderfyCircleRadius: 40,
                      zoomToBoundsOnClick: true,
                      onMarkerTap: (marker) =>
                          _popupController.togglePopup(marker),
                    ),
                  ),

                // 2) Popups y marcadores individuales cuando zoom ≥ umbral
                if (_currentZoom >= _disableClusteringZoom)
                  PopupMarkerLayer(
                    options: PopupMarkerLayerOptions(
                      markers: markers,
                      popupController: _popupController,
                      popupDisplayOptions: PopupDisplayOptions(
                        builder: (ctx, marker) {
                          final inc = filtered.firstWhere(
                            (i) =>
                                i.id == (marker.key as ValueKey).value,
                          );
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(inc.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(inc.description),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Gravedad: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                      Icon(Icons.circle,
                                          color: inc.severity.color,
                                          size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        inc.severity.name.toUpperCase(),
                                        style: TextStyle(
                                            color: inc.severity.color),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        snap: PopupSnap.markerTop,
                      ),
                      markerTapBehavior:
                          MarkerTapBehavior.togglePopupAndHideRest(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      // Botón para agregar nuevos incidentes
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push<Incident>(
            context,
            MaterialPageRoute(
              builder: (_) => AddIncidentPage(onSave: _onNewIncident),
            ),
          );
        },
      ),
    );
  }

  void _onNewIncident(Incident incident) {
    setState(() {
      _controller.incidents.add(incident);
    });
  }
}