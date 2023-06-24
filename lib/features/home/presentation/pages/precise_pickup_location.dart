import 'dart:async';

import 'package:campusgo/core/widgets/primarybutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/info_handler/app_info.dart';
import '../../assistant/assistant.dart';
import '../../data/models/directions.dart';

class PrecisePickUpPage extends StatefulWidget {
  static String routeName = 'PrecisePickUpPage';
  const PrecisePickUpPage({super.key});

  @override
  State<PrecisePickUpPage> createState() => _PrecisePickUpPageState();
}

class _PrecisePickUpPageState extends State<PrecisePickUpPage> {
  final GlobalKey<ScaffoldState> _scaffoldstate = GlobalKey<ScaffoldState>();

  Position? userCurrentPosition;
  double bottomPaddingofMap = 0;
  LatLng? pickLocation;
  loc.Location location = loc.Location();
  String? _address;
  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();
  GoogleMapController? newGoogleController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 15);

    newGoogleController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    if (!mounted) return;
    String humanReadableAddress =
        await AssistantMethods.searchAddressforGeographicCoordinates(
            userCurrentPosition!, context);
    print('This is our address= $humanReadableAddress');

    // initializeGeoFireListener();

    // AssistantMethods.readTripsKeysForOnlineUser(context);
  }

  getAddressFromLatLng() async {
    try {
      GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: pickLocation!.latitude,
        longitude: pickLocation!.longitude,
        googleMapApiKey: kMapKey,
      );

      setState(() {
        Directions userPickUpAddress = Directions();
        userPickUpAddress.locationLatitude = pickLocation!.latitude;
        userPickUpAddress.locationLongitude = pickLocation!.longitude;
        userPickUpAddress.locationName = data.address;
        Provider.of<AppInfo>(context, listen: false)
            .updatePickUpLocationAddress(userPickUpAddress);
        // _address = data.address;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(top: 100.h, bottom: bottomPaddingofMap),
            initialCameraPosition: _kGooglePlex,
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleController = controller;
              setState(() {
                bottomPaddingofMap = 50.h;
              });
              locateUserPosition();
            },
            onCameraMove: (CameraPosition? position) {
              if (pickLocation != position!.target) {
                setState(() {
                  pickLocation = position.target;
                });
              }
            },
            onCameraIdle: () {
              getAddressFromLatLng();
            },
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: 60.h, bottom: bottomPaddingofMap),
              child: Image.asset(
                kPinn,
                height: 45.h,
                width: 45.w,
                color: kPrimaryColor2,
              ),
            ),
          ),
          Positioned(
            top: 40.h,
            right: 20.w,
            left: 20.w,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: kPrimaryColor2, width: 2),
                borderRadius: BorderRadius.circular(20.r),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 8.h,
                vertical: 8.w,
              ),
              child: Text(
                Provider.of<AppInfo>(context).userPickUpLocation != null
                    ? Provider.of<AppInfo>(context)
                        .userPickUpLocation!
                        .locationName!
                    : 'Loading...',
                textAlign: TextAlign.center,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.black,
                      fontSize: 15.sp,
                    ),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: PrimaryButton(
                  text: 'Set Current Location',
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
          )
        ],
      ),
    );
  }
}
