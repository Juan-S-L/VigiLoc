import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

enum Severity { low, medium, high }

class Incident {
  final String id;
  final String title;
  final String description;
  final LatLng location;
  final Severity severity;

  Incident({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.severity,
  });
}

extension SeverityColor on Severity {
  Color get color {
    switch (this) {
      case Severity.low: return Colors.yellow;
      case Severity.medium: return Colors.orange;
      case Severity.high: return Colors.red;
    }
  }
}