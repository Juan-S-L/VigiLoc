import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vigilog/data/incident.dart';
import 'package:vigilog/ui/pages/select_location_page.dart';

class AddIncidentPage extends StatefulWidget {
  final ValueChanged<Incident> onSave;
  const AddIncidentPage({required this.onSave, super.key});

  @override
  State<AddIncidentPage> createState() => _AddIncidentPageState();
}

class _AddIncidentPageState extends State<AddIncidentPage> {
  final _formKey = GlobalKey<FormState>();
  Severity _severity = Severity.low;
  String _title = '';
  String _description = '';
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reportar incidente')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Título'),
                onSaved: (v) => _title = v ?? '',
                validator: (v) => v!.isEmpty ? 'Obligatorio' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descripción'),
                onSaved: (v) => _description = v ?? '',
                validator: (v) => v!.isEmpty ? 'Obligatorio' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Severity>(
                decoration: const InputDecoration(labelText: 'Gravedad'),
                value: _severity,
                items: Severity.values.map((sev) {
                  return DropdownMenuItem(
                    value: sev,
                    child: Text(sev.name.toUpperCase(), 
                      style: TextStyle(color: sev.color)),
                  );
                }).toList(),
                onChanged: (sev) => setState(() => _severity = sev!),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.map),
                label: Text(
                  _pickedLocation == null
                    ? 'Seleccionar ubicación'
                    : 'Ubicación: ${_pickedLocation!.latitude.toStringAsFixed(4)}, ${_pickedLocation!.longitude.toStringAsFixed(4)}'
                ),
                onPressed: () async {
                  const center = LatLng(4.1480, -73.6320); // o pasa el centro actual del mapa
                  final result = await Navigator.push<LatLng>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SelectLocationPage(initialCenter: center),
                    ),
                  );
                  if (result != null) {
                    setState(() => _pickedLocation = result);
                  }
                },
              ),
              const Spacer(),
              ElevatedButton(
                child: const Text('Guardar'),
                onPressed: () {
                  if (_formKey.currentState!.validate() && _pickedLocation != null) {
                    _formKey.currentState!.save();
                    final newInc = Incident(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: _title,
                      description: _description,
                      location: _pickedLocation!,
                      severity: _severity,
                    );
                    widget.onSave(newInc);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}