import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../core/navigation/scaffold_with_nav.dart';

const _lat = 40.588217;
const _lng = 65.489448;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _State();
}

class _State extends State<MapScreen> {
  YandexMapController? _ctrl;

  @override
  void dispose() {
    _ctrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xarita'),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: ScaffoldWithNav.openDrawer,
        ),
        actions: [
          if (!kIsWeb)
            IconButton(
              icon: const Icon(Icons.my_location_rounded),
              onPressed: () => _ctrl?.moveCamera(
                CameraUpdate.newCameraPosition(
                  const CameraPosition(
                    target: Point(latitude: _lat, longitude: _lng),
                    zoom: 14.0,
                  ),
                ),
                animation: const MapAnimation(
                    type: MapAnimationType.smooth, duration: 0.8),
              ),
            ),
        ],
      ),
      body: kIsWeb ? _osmMap() : _yandexMap(),
    );
  }

  Widget _osmMap() => FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(_lat, _lng),
          initialZoom: 14.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'uz.gozgon.life',
          ),
        ],
      );

  Widget _yandexMap() => YandexMap(
        onMapCreated: (controller) async {
          _ctrl = controller;
          await controller.moveCamera(
            CameraUpdate.newCameraPosition(
              const CameraPosition(
                target: Point(latitude: _lat, longitude: _lng),
                zoom: 14.0,
              ),
            ),
            animation: const MapAnimation(
                type: MapAnimationType.smooth, duration: 1.5),
          );
        },
      );
}
