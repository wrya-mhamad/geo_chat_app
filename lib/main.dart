import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ViewOnline(),
    );
  }
}

class ViewOnline extends StatefulWidget {
  const ViewOnline({Key? key}) : super(key: key);

  @override
  _ViewOnlineState createState() => _ViewOnlineState();
}

class _ViewOnlineState extends State<ViewOnline> {
  final Location location = Location();
  var currentLocation;
  late GoogleMapController mapController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    location.onLocationChanged.listen((LocationData locat) {
      setState(() {
        currentLocation = getLocation();
      });
    });
    currentLocation = getLocation();
    if (mapController != null) {
      mapController.moveCamera(CameraUpdate.newLatLng(
          LatLng(currentLocation.latitude, currentLocation.longitude)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Online Users'),
        ),
        body: FutureBuilder<LocationData>(
            future: currentLocation,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(snapshot.data!.latitude as double,
                        snapshot.data!.longitude as double),
                    zoom: 18.2,
                  ),
                  markers: {
                    Marker(
                        markerId: MarkerId('11'),
                        position: LatLng(snapshot.data!.latitude as double,
                            snapshot.data!.longitude as double))
                  },
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }

  Future<LocationData> getLocation() async {
    return await location.getLocation();
  }
}
