import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:proyecto/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//import 'package:permission_handler/permission_handler.dart';

class LiveLocationPage extends StatefulWidget {
  static const String route = '/live_location';

  const LiveLocationPage({Key? key}) : super(key: key);

  @override
  _LiveLocationPageState createState() => _LiveLocationPageState();
}

class _LiveLocationPageState extends State<LiveLocationPage> {
  final User? user = Auth().currentUser;
  LocationData? _currentLocation;
  late final MapController _mapController;

  bool _liveUpdate = false;
  bool _permission = false;

  String? _serviceError = '';

  int interActiveFlags = InteractiveFlag.all;

  final Location _locationService = Location();
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    initLocationService();
    _checkAndAddLocationField();
    _loadUserLocations();
  }

  Future<void> _checkAndAddLocationField() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();

      // Verificar si el campo 'location' existe y es nulo
      if (!userDoc.exists || userDoc.data()!['location'] == null) {
        // Si no existe o es nulo, agregar el campo de ubicación
        print('Falta ubicacion');
        await _updateUserLocation();
      } else {
        print('Ubicacion existente');
      }
    } catch (e) {
      print('Error checking/adding location field: $e');
    }
  }

  Future<void> _updateUserLocation() async {
    if (_currentLocation != null && user != null) {
      print(
          'Updating user location: ${_currentLocation!.latitude}, ${_currentLocation!.longitude}');

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'location':
            GeoPoint(_currentLocation!.latitude!, _currentLocation!.longitude!),
      });
    }
  }

  Future<void> _loadUserLocations() async {
    try {
      final users = await FirebaseFirestore.instance.collection('users').get();

      _markers.clear();

      for (var userDoc in users.docs) {
        final userData = userDoc.data() as Map<String, dynamic>;
        final userLocation = userData['location'] as GeoPoint?;

        if (userLocation != null) {
          String photoURL = userData['photoURL'] ?? '';

          _markers.add(
            Marker(
              width: 20,
              height: 20,
              point: LatLng(userLocation.latitude, userLocation.longitude),
              child: CircleAvatar(
                radius: 15.0,
                backgroundImage: NetworkImage(photoURL),
              ),
            ),
          );
        }
      }

      // Agrega este registro de depuración
      print('Número de marcadores: ${_markers.length}');

      setState(() {});
    } catch (e) {
      print('Error loading user locations: $e');
    }
  }

  void initLocationService() async {
    await _locationService.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
    );

    LocationData? location;
    bool serviceEnabled;
    bool serviceRequestResult;

    try {
      serviceEnabled = await _locationService.serviceEnabled();

      if (serviceEnabled) {
        final permission = await _locationService.requestPermission();
        _permission = permission == PermissionStatus.granted;

        if (_permission) {
          location = await _locationService.getLocation();
          _currentLocation = location;
          _locationService.onLocationChanged
              .listen((LocationData result) async {
            if (mounted) {
              setState(() {
                _currentLocation = result;

                // // If Live Update is enabled, move map center
                // if (_liveUpdate) {
                //   _mapController.move(
                //       LatLng(_currentLocation!.latitude!,
                //           _currentLocation!.longitude!),
                //       _mapController.zoom);
                // }
                _updateUserLocation();
              });
            }
          });
        }
      } else {
        serviceRequestResult = await _locationService.requestService();
        if (serviceRequestResult) {
          initLocationService();
          return;
        }
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      if (e.code == 'PERMISSION_DENIED') {
        _serviceError = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        _serviceError = e.message;
      }
      location = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    LatLng currentLatLng;

    // Until currentLocation is initially updated, Widget can locate to 0, 0
    // by default or store previous location value to show.
    if (_currentLocation != null) {
      currentLatLng =
          LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
    } else {
      currentLatLng = LatLng(0, 0);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Tu ubicación')),
      backgroundColor: const Color.fromARGB(162, 7, 206, 159),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Flexible(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: const LatLng(-17.375306, -66.158690),
                  initialZoom: 12,
                  // interactionOptions:
                  //     InteractionOptions(debugMultiFingerGestureWinner: false),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://api.mapbox.com/styles/v1/dransil/cl2ut927z000z14nxynseyfb2/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZHJhbnNpbCIsImEiOiJjbHBsbm4wNDYwMGN6Mmlxbm1yZzh0bWU5In0.FaLWUvLUP6DSgcGcArA35A",
                    additionalOptions: const {
                      "access_token":
                          "<pk.eyJ1IjoiZHJhbnNpbCIsImEiOiJjbHBsbm4wNDYwMGN6Mmlxbm1yZzh0bWU5In0.FaLWUvLUP6DSgcGcArA35A>",
                    },
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: _markers,
                    // markers: [
                    //   Marker(
                    //     point: currentLatLng,
                    //     width: 20,
                    //     height: 20,
                    //     child: CircleAvatar(
                    //       radius: 100.0,
                    //       backgroundImage: NetworkImage('${user?.photoURL}'),
                    //     ),
                    //   ),
                    // ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Builder(builder: (BuildContext context) {
        return FloatingActionButton(
          onPressed: () {
            setState(() {
              _liveUpdate = !_liveUpdate;

              // Mueve el centro solo si _liveUpdate está desactivado
              if (!_liveUpdate && _currentLocation != null) {
                _mapController.move(
                    LatLng(_currentLocation!.latitude!,
                        _currentLocation!.longitude!),
                    _mapController.zoom);
              }

              if (_liveUpdate) {
                interActiveFlags = InteractiveFlag.rotate |
                    InteractiveFlag.pinchZoom |
                    InteractiveFlag.doubleTapZoom;

                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Centrando...'),
                ));
              } else {
                interActiveFlags = InteractiveFlag.all;
              }
            });
          },
          child: _liveUpdate
              ? const Icon(Icons.location_on)
              : const Icon(Icons.location_off),
        );
      }),
    );
  }
}
