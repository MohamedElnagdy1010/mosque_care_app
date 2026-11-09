import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../data/repositories/local_mosque_repository.dart';
import '../../domain/utils/mosque_location_validator.dart';

class MosqueMapScreen extends StatelessWidget {
  const MosqueMapScreen({super.key});

  static final _mosquesFuture = LocalMosqueRepository().getMosques().then(
    (mosques) =>
        mosques.where(MosqueLocationValidator.hasValidCoordinates).toList(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('خريطة المساجد')),

      body: FutureBuilder(
        future: _mosquesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('تعذر تحميل مواقع المساجد'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final mosques = snapshot.data!;

          return Stack(
            children: [
              FlutterMap(
                options: const MapOptions(
                  initialCenter: LatLng(24.4686, 46.2736),
                  initialZoom: 12,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.mosque_care_app',
                  ),
                  MarkerLayer(
                    markers: mosques.map((mosque) {
                      return Marker(
                        point: LatLng(mosque.latitude!, mosque.longitude!),
                        width: 44,
                        height: 44,
                        child: const Icon(
                          Icons.location_on,
                          color: Color(0xFF8A5A2B),
                          size: 40,
                        ),
                      );
                    }).toList(),
                  ),
                  const RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution('OpenStreetMap contributors'),
                    ],
                  ),
                ],
              ),
              if (mosques.isEmpty)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'لا توجد مواقع مساجد متاحة على الخريطة حاليًا',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
