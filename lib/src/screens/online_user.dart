import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geo_chat_app/src/services/auth_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'conversation_screen.dart';

class OnlineUser extends StatefulWidget {
  @override
  State<OnlineUser> createState() => _OnlineUserState();
}

class _OnlineUserState extends State<OnlineUser> {
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
  var mapController;
  late BitmapDescriptor customIcon;
  bool isInitaled = false;

  @override
  void initState() {
    super.initState();

    setCustomMarker();
    location.onLocationChanged.listen((LocationData locat) async {
      currentLocation = getLocation();
      User? user = await FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance.collection('users').doc(user!.uid).set(
          {"lat": locat.latitude, "lng": locat.longitude},
          SetOptions(merge: true));
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
          actions: [
            IconButton(
                onPressed: () async {
                  await Provider.of<AuthService>(context, listen: false)
                      .logOut();
                },
                icon: Icon(
                  Icons.logout_outlined,
                  color: Colors.red,
                ))
          ],
        ),
        body: FutureBuilder<LocationData>(
            future: currentLocation,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context, snapshott) {
                      if (snapshot.hasError) {
                        return Text('error');
                      } else if (!snapshott.hasData || snapshott.data == null) {
                        return Text('empty');
                      } else if (snapshott.connectionState ==
                          ConnectionState.waiting) {
                        print('===============>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
                        return LinearProgressIndicator();
                      }

                      var markers = <Marker>{};
                      List<DocumentSnapshot> docs = snapshott.data!.docs;
                      // make sure to initialize before map loading

                      docs.forEach((doc) {
                        markers.add(Marker(
                            markerId: MarkerId(doc.reference.id),
                            icon: customIcon,
                            infoWindow: InfoWindow(
                              title: doc['username'],
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Conversation(
                                          id: doc.reference.id,
                                          username: doc['username']),
                                    ));
                              },
                            ),
                            position: LatLng(
                                doc['lat'] as double, doc['lng'] as double)));
                      });

                      return GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(snapshot.data!.latitude as double,
                              snapshot.data!.longitude as double),
                          zoom: 18.2,
                        ),
                        markers: markers,
                        onMapCreated: (controller) {
                          mapController = controller;
                        },
                      );
                    });
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }

  Future<LocationData> getLocation() async {
    return await location.getLocation();
  }

  void setCustomMarker() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          size: Size(-5, -5),
        ),
        'assets/ago.png') as BitmapDescriptor;
  }
}
