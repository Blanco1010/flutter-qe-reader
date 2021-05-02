import 'package:flutter/material.dart';
import 'dart:async';

import 'package:qr_reader/models/scan_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  Completer<GoogleMapController> _controller = Completer();
  MapType mapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    //Recibier la informacion por utils.dart
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    final CameraPosition puntoInicial =
        CameraPosition(target: scan.getLatLng(), zoom: 17, tilt: 50);

    //Marcaodes
    Set<Marker> markers = new Set<Marker>();
    markers.add(new Marker(
        markerId: MarkerId('geo-location'), position: scan.getLatLng()));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Mapa'),
        actions: [
          IconButton(
              icon: Icon(Icons.local_activity),
              onPressed: () async {
                final GoogleMapController controller = await _controller.future;
                controller.animateCamera(
                    CameraUpdate.newCameraPosition(puntoInicial));
              })
        ],
      ),
      body: GoogleMap(
        myLocationButtonEnabled: false,
        mapType: mapType,
        markers: markers,
        initialCameraPosition: puntoInicial,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.symmetric(horizontal: 50),
        child: FloatingActionButton(
          child: Icon(Icons.layers),
          onPressed: () {
            setState(() {
              if (mapType == MapType.normal) {
                mapType = MapType.hybrid;
              } else {
                mapType = MapType.normal;
              }
            });
          },
        ),
      ),
    );
  }
}
