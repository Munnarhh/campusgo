import 'dart:async';

import 'package:campusgo/core/constants/constants.dart';
import 'package:campusgo/core/info_handler/app_info.dart';
import 'package:campusgo/core/widgets/primarybutton.dart';
import 'package:campusgo/features/home/assistant/assistant.dart';
import 'package:campusgo/features/home/data/models/direction_details_info.dart';
import 'package:campusgo/features/home/presentation/pages/precise_pickup_location.dart';
import 'package:campusgo/features/home/presentation/pages/search_place.dart';
import 'package:campusgo/features/home/presentation/widgets/home_drawer.dart';
import 'package:campusgo/features/home/presentation/widgets/progress_dialog.dart';
import 'package:campusgo/global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/theme.dart';
import '../../data/models/directions.dart';

class Homee extends StatefulWidget {
  static String routeName = 'Homee';
  const Homee({super.key});

  @override
  State<Homee> createState() => _HomeeState();
}

class _HomeeState extends State<Homee> {
  final GlobalKey<ScaffoldState> _scaffoldstate = GlobalKey<ScaffoldState>();

  LatLng? pickLocation;
  loc.Location location = loc.Location();
  String? _address;
  double searchLocationContainerHeight = 220;
  double waitingResponsefromDriverContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;

  var geoLocation = Geolocator();
  Position? userCurrentPosition;

  LocationPermission? _locationPermission;
  double bottomPaddingofMap = 0;

  List<LatLng> pLineCoordinatedList = [];

  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};
  Set<Polyline> polylineSet = {};

  String username = '';
  String userEmail = '';

  bool openNavigationDrawer = true;
  bool activeNearyDriverKeysLoaded = false;

  BitmapDescriptor? activeNearbyIcon;

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

    String humanReadableAddress =
        await AssistantMethods.searchAddressforGeographicCoordinates(
            userCurrentPosition!, context);
    print('This is our address= $humanReadableAddress');

    // initializeGeoFireListener();

    // AssistantMethods.readTripsKeysForOnlineUser(context);
  }

  Future<void> drawPolyLineFromOriginToDestination() async {
    var originPosition =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var originLatLng = LatLng(
        originPosition!.locationLatitude!, originPosition.locationLongitude!);
    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!,
        destinationPosition.locationLongitude!);

    showDialog(
        context: context, builder: (BuildContext context) => ProgressDialog());
    var directionDetailsInfo =
        await AssistantMethods.obtainOriginToDestinationDirectionDetails(
            originLatLng, destinationLatLng);

    setState(() {
      tripDirectionDetailsInfo = directionDetailsInfo;
    });

    Navigator.pop(context);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodePolyLinePointsResultList =
        pPoints.decodePolyline(directionDetailsInfo.ePoints!);
    pLineCoordinatedList.clear();

    if (decodePolyLinePointsResultList.isNotEmpty) {
      decodePolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoordinatedList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.pink,
        polylineId: const PolylineId(
          'PolylineID',
        ),
        jointType: JointType.round,
        points: pLineCoordinatedList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
        width: 5,
      );

      polylineSet.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
          southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
          northeast:
              LatLng(destinationLatLng.latitude, originLatLng.longitude));
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      boundsLatLng =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    newGoogleController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarker = Marker(
      markerId: const MarkerId('originID'),
      infoWindow:
          InfoWindow(title: originPosition.locationName, snippet: 'Origin'),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinamtionMarker = Marker(
      markerId: const MarkerId('destinationID'),
      infoWindow: InfoWindow(
          title: destinationPosition.locationName, snippet: 'Destination'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      markerSet.add(originMarker);
      markerSet.add(destinamtionMarker);
    });

    Circle originCircle = Circle(
      circleId: CircleId('originID'),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId('destinationID'),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );

    setState(() {
      circleSet.add(originCircle);
      circleSet.add(destinationCircle);
    });
  }

  // getAddressFromLatLng() async {
  //   try {
  //     GeoData data = await Geocoder2.getDataFromCoordinates(
  //       latitude: pickLocation!.latitude,
  //       longitude: pickLocation!.longitude,
  //       googleMapApiKey: kMapKey,
  //     );

  //     setState(() {
  //       Directions userPickUpAddress = Directions();
  //       userPickUpAddress.locationLatitude = pickLocation!.latitude;
  //       userPickUpAddress.locationLongitude = pickLocation!.longitude;
  //       userPickUpAddress.locationName = data.address;
  //       Provider.of<AppInfo>(context, listen: false)
  //           .updatePickUpLocationAddress(userPickUpAddress);
  //       // _address = data.address;
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfLocationPermissionAllowed();
  }

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: _scaffoldstate,
        drawer: const HomeDrawer(),
        body: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(top: 30.h, bottom: bottomPaddingofMap),
              initialCameraPosition: _kGooglePlex,
              mapType: MapType.normal,
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              polylines: polylineSet,
              markers: markerSet,
              circles: circleSet,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleController = controller;
                setState(() {
                  bottomPaddingofMap = 250.h;
                });
                locateUserPosition();
              },
              // onCameraMove: (CameraPosition? position) {
              //   if (pickLocation != position!.target) {
              //     setState(() {
              //       pickLocation = position.target;
              //     });
              //   }
              // },
              // onCameraIdle: () {
              //   getAddressFromLatLng();
              // },
            ),
            // Align(
            //   alignment: Alignment.center,
            //   child: Padding(
            //     padding: EdgeInsets.only(bottom: 35.h),
            //     child: Image.asset(
            //       kPinn,
            //       height: 45.h,
            //       width: 45.w,
            //       color: kPrimaryColor2,
            //     ),
            //   ),
            // ),
            Positioned(
              left: 20,
              top: 50,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  _scaffoldstate.currentState!.openDrawer();
                },
                child: SvgPicture.asset(kMenu),
              ),
            ),
            //ui for searching locations
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 50.h, 20.w, 16.h),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Material(
                      elevation: 10,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(13.w, 2.h, 13.w, 12.h),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Location Details',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: kPrimaryColor2,
                                    fontSize: 18.sp,
                                  ),
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.w, vertical: 12.h),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          color: kPrimaryColor2,
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'From',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    color: kPrimaryColor2,
                                                    fontSize: 12.sp,
                                                  ),
                                            ),
                                            SizedBox(
                                              width: 284.w,
                                              child: Text(
                                                Provider.of<AppInfo>(context)
                                                            .userPickUpLocation !=
                                                        null
                                                    ? Provider.of<AppInfo>(
                                                            context)
                                                        .userPickUpLocation!
                                                        .locationName!
                                                    : 'Loading...',
                                                //textAlign: TextAlign.center,
                                                maxLines: 1,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                      color: Colors.black,
                                                      fontSize: 14.sp,
                                                    ),
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 1.h,
                                    thickness: 2,
                                    color: kPrimaryColor2,
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5.w,
                                      vertical: 12.h,
                                    ),
                                    child: GestureDetector(
                                      onTap: () async {
                                        //go to search places screen
                                        var responseFromSearchScreen =
                                            await Navigator.pushNamed(context,
                                                SearchPlacePlage.routeName);
                                        if (responseFromSearchScreen ==
                                            'ObtainedDropOff') {
                                          setState(() {
                                            openNavigationDrawer = false;
                                          });
                                        }
                                        await drawPolyLineFromOriginToDestination();
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on_outlined,
                                            color: kPrimaryColor2,
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'To',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                      color: kPrimaryColor2,
                                                      fontSize: 12.sp,
                                                    ),
                                              ),
                                              Text(
                                                Provider.of<AppInfo>(context)
                                                            .userDropOffLocation !=
                                                        null
                                                    ? Provider.of<AppInfo>(
                                                            context)
                                                        .userDropOffLocation!
                                                        .locationName!
                                                    : 'Where to?',
                                                //textAlign: TextAlign.center,
                                                maxLines: 1,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                      color: Colors.black,
                                                      fontSize: 14.sp,
                                                    ),
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, PrecisePickUpPage.routeName);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6.h, horizontal: 10.w),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: kPrimaryColor2, width: 2),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Text(
                                      'Change Pick Up',
                                      style: theme(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontSize: 16.sp,
                                              color: kPrimaryColor2),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.h, horizontal: 10.w),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          offset: const Offset(0, 4),
                                          blurRadius: 4,
                                          spreadRadius: 0,
                                        ),
                                      ],
                                      //color: kPrimaryColor2,
                                      borderRadius: BorderRadius.circular(8),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF7A64FF),
                                          Color(0xFF9E8AFF),
                                        ],
                                      ),
                                    ),
                                    child: Text(
                                      '         Book a Ride        ',
                                      style: theme(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontSize: 16.sp,
                                          ),
                                    ),
                                  ),

                                  // ElevatedButton(
                                  //   onPressed: () {},
                                  //   style: ElevatedButton.styleFrom(
                                  //       primary: kPrimaryColor2),
                                  //   child: Text(
                                  //     '      Book a Ride      ',
                                  //     style: theme(context)
                                  //         .textTheme
                                  //         .bodyMedium!
                                  //         .copyWith(
                                  //           fontSize: 16.sp,
                                  //         ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),

            // Positioned(
            //   top: 40.h,
            //   right: 20.w,
            //   left: 20.w,
            //   child: Container(
            //     decoration: BoxDecoration(
            //       border: Border.all(color: kPrimaryColor2, width: 2),
            //       borderRadius: BorderRadius.circular(20.r),
            //       color: Colors.white,
            //     ),
            //     padding: EdgeInsets.symmetric(
            //       horizontal: 8.h,
            //       vertical: 8.w,
            //     ),
            //     child: Provider.of<AppInfo>(context).userPickUpLocation != null
            //         ? Text(
            //             Provider.of<AppInfo>(context)
            //                 .userPickUpLocation!
            //                 .locationName!,
            //             textAlign: TextAlign.center,
            //             maxLines: 1,
            //             style: Theme.of(context).textTheme.bodySmall!.copyWith(
            //                   color: Colors.black,
            //                   fontSize: 15.sp,
            //                 ),
            //             overflow: TextOverflow.ellipsis,
            //             softWrap: true,
            //           )
            //         : const SpinKitCircle(
            //             size: 25,
            //             color: Colors.black,
            //           ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
