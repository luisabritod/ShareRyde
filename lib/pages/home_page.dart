import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_ryde/authentication/authentication.dart';
import 'package:share_ryde/global/global.dart';
import 'package:share_ryde/methods/methods.dart';
import 'package:share_ryde/pages/search_destination_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> googleMapsController =
      Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;
  Position? currentPositionOfUser;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  CommonMethods commonMethods = CommonMethods();
  double searchContainerHeight = 276;
  double bottomMapPadding = 0;

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

  getCurrentLiveLocationOfUser() async {
    Position positionOfUser = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPositionOfUser = positionOfUser;

    LatLng postionOfUserInLatLng = LatLng(
        currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: postionOfUserInLatLng, zoom: 15);
    controllerGoogleMap!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    await getUserInfoAndCheckBlockStatus();
  }

  getUserInfoAndCheckBlockStatus() async {
    DatabaseReference usersRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(FirebaseAuth.instance.currentUser!.uid);

    await usersRef.once().then((value) {
      if (value.snapshot.value != null) {
        if ((value.snapshot.value as Map)['blockStatus'] == 'no') {
          setState(() {
            userName = (value.snapshot.value as Map)['name'];
          });
        } else {
          FirebaseAuth.instance.signOut();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
          commonMethods.displaySnackBar(
              context, 'Your account is blocked. Contact the administrator.');
        }
      } else {
        FirebaseAuth.instance.signOut();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Container(
        width: 255,
        color: const Color(0xffEFEFEF),
        child: Drawer(
          backgroundColor: const Color(0xffEFEFEF),
          child: ListView(
            children: [
              Container(
                color: const Color(0xff0C849B),
                height: 160,
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color(0xffEFEFEF),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/girlAvatar.png',
                        height: 60,
                        width: 60,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          const Text(
                            'Profile',
                            style: TextStyle(
                              color: Color(0xff414141),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 1,
                color: Color(0xff0C849B),
                thickness: 1,
              ),
              ListTile(
                leading: IconButton(
                  icon: const Icon(
                    Icons.info,
                    color: Color(0xff0C849B),
                  ),
                  onPressed: () {},
                ),
                title: const Text(
                  'About',
                  style: TextStyle(color: Color(0xff0C849B)),
                ),
              ),
              GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: ListTile(
                  leading: IconButton(
                    icon: const Icon(
                      Icons.logout,
                      color: Color(0xff0C849B),
                    ),
                    onPressed: () {},
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Color(0xff0C849B)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(top: 30, bottom: bottomMapPadding),
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: googlePlexInitialPosition,
            onMapCreated: (GoogleMapController mapController) {
              controllerGoogleMap = mapController;
              updateMapTheme(controllerGoogleMap!);
              googleMapsController.complete(controllerGoogleMap);
              getCurrentLiveLocationOfUser();
              setState(() {
                bottomMapPadding = 276;
              });
            },
          ),
          //drawer button
          Positioned(
            top: 42,
            left: 19,
            child: GestureDetector(
              onTap: () {
                scaffoldKey.currentState!.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xffEFEFEF),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xff0C849B),
                      blurRadius: 5,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: Color(0xffEFEFEF),
                  radius: 20,
                  child: Icon(
                    Icons.menu,
                    color: Color(0xff0C849B),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: -80,
            child: Container(
              height: searchContainerHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchDestinationPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(24),
                      backgroundColor: const Color(0xff0C849B),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Color(0xffEFEFEF),
                      size: 25,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(24),
                      backgroundColor: const Color(0xff0C849B),
                    ),
                    child: const Icon(
                      Icons.home,
                      color: Color(0xffEFEFEF),
                      size: 25,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(24),
                      backgroundColor: const Color(0xff0C849B),
                    ),
                    child: const Icon(
                      Icons.work,
                      color: Color(0xffEFEFEF),
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
