import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

class ShowMap extends StatelessWidget {
  const ShowMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ubicacion en tiempo real')),
      backgroundColor: const Color.fromARGB(162, 7, 206, 159),
      body: StreamBuilder<dynamic>(
        stream: FirebaseFirestore.instance
            .collection('coordenadasoficial/user1/ubicacion')
            .snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final document = snapshot.data!.docs;
          return ListView.builder(
            itemCount: document.length,
            itemBuilder: (context, index) => Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(
                    document[index]['latitud'].toString(),
                    style: const TextStyle(color: Colors.blue),
                  ),
                  Text(
                    document[index]['longitud'].toString(),
                    style: const TextStyle(color: Colors.red),
                  ),
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: FlutterMap(
                      options: MapOptions(
                        center: LatLng(document[index]['latitud'],
                            document[index]['longitud']),
                        zoom: 12,
                      ),
                      nonRotatedChildren: [
                        AttributionWidget.defaultWidget(
                          source: 'OpenStreetMap',
                          onSourceTapped: null,
                        ),
                      ],
                      children: [
                        TileLayer(
                          urlTemplate:
                              "https://api.mapbox.com/styles/v1/dransil/clbpomr5n002j14n1u54blx3b/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZHJhbnNpbCIsImEiOiJjbHBsbm4wNDYwMGN6Mmlxbm1yZzh0bWU5In0.FaLWUvLUP6DSgcGcArA35A",
                          additionalOptions: const {
                            "access_token":
                                "<pk.eyJ1IjoiZHJhbnNpbCIsImEiOiJjbHBsbm4wNDYwMGN6Mmlxbm1yZzh0bWU5In0.FaLWUvLUP6DSgcGcArA35A>",
                          },
                          userAgentPackageName: 'com.example.app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(document[index]['latitud'],
                                  document[index]['longitud']),
                              width: 40,
                              height: 40,
                              builder: (context) => const Icon(
                                Icons.person_pin_rounded,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
