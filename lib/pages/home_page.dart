import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_ryde/global/global.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> googleMapsController =
      Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;

  void updateMapTheme(GoogleMapController controller) {
    getJsonFileFromTheme('themes/retro_style.json').then(
      (value) => setGoogleMapTheme(value, controller),
    );
  }

  Future<String> getJsonFileFromTheme(String mapThemePath) async {
    ByteData byteData = await rootBundle.load(mapThemePath);
    var list = byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    return utf8.decode(list);
  }

  setGoogleMapTheme(String googleMapTheme, GoogleMapController controller) {
    controller.setMapStyle(googleMapTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: googlePlexInitialPosition,
            onMapCreated: (GoogleMapController mapController) {
              controllerGoogleMap = mapController;
              updateMapTheme(controllerGoogleMap!);
              googleMapsController.complete(controllerGoogleMap);
            },
          )
        ],
      ),
    );
  }
}
