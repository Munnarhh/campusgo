import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:campusgo/core/constants/constants.dart';
import 'package:campusgo/core/info_handler/app_info.dart';
import 'package:campusgo/core/widgets/primarybutton.dart';
import 'package:campusgo/core/assistant/assistant.dart';
import 'package:campusgo/features/home/data/models/direction_details_info.dart';
import 'package:campusgo/features/home/presentation/pages/precise_pickup_location.dart';
import 'package:campusgo/features/home/presentation/pages/search_place.dart';
import 'package:campusgo/features/home/presentation/widgets/home_drawer.dart';
import 'package:campusgo/features/home/presentation/widgets/progress_dialog.dart';
import 'package:campusgo/features/onboarding/presentation/views/splash_screen.dart';
import 'package:campusgo/features/ride/presentation/pages/calendar.dart';
import 'package:campusgo/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../core/assistant/geofire_assistant.dart';
import '../../../../core/theme/theme.dart';
import '../../data/models/active_nearby_available_drivers.dart';
import '../../data/models/directions.dart';
import '../widgets/pay_fare_amount_dialog.dart';

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
  double suggestedRidesContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;
  double searchingForDriversContainerHeight = 0;

  var geoLocation = Geolocator();
  Position? userCurrentPosition;

  LocationPermission? _locationPermission;
  double bottomPaddingofMap = 0;

  List<LatLng> pLineCoordinatedList = [];

  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};
  Set<Polyline> polylineSet = {};

  String userName = '';
  String userEmail = '';

  String selectedVehicleType = '';
  String driverRideStatus = 'Driver is coming';

  String userRequestStatus = '';
  StreamSubscription<DatabaseEvent>? tripRidesRequestInfoStreamSubscription;

  List<ActiveNearbyAvailableDrivers> onlineNearByAvailableDriversList = [];

  bool requestPositionInfo = true;

  bool openNavigationDrawer = true;
  bool activeNearbyDriversKeyLoaded = false;

  BitmapDescriptor? activeNearbyIcon;

  DatabaseReference? referenceRideRequest;

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

    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;

    initializeGeoFireListener();

    // AssistantMethods.readTripsKeysForOnlineUser(context);
  }

  initializeGeoFireListener() {
    Geofire.initialize('activeDrivers');

    Geofire.queryAtLocation(
            userCurrentPosition!.latitude, userCurrentPosition!.longitude, 10)!
        .listen((map) {
      print(map);

      if (map != null) {
        var callBack = map['callBack'];

        switch (callBack) {
          //whenever any driver become active/online
          case Geofire.onKeyEntered:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDrivers =
                ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDrivers.locationLatitude = map['latitude'];
            activeNearbyAvailableDrivers.locationLongitude = map['longitude'];
            activeNearbyAvailableDrivers.driverId = map['key'];
            GeoFireAssistant.activeNearbyAvailableDriversList
                .add(activeNearbyAvailableDrivers);
            if (activeNearbyDriversKeyLoaded == true) {
              displayActiveDriversOnUsersMap();
            }
            break;
          //whenever any driver becomnenon-active/online
          case Geofire.onKeyExited:
            GeoFireAssistant.deleteOfflineDriverFromList(map['key']);
            displayActiveDriversOnUsersMap();
            break;

          //whenever driver moves- update driver location
          case Geofire.onKeyMoved:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDrivers =
                ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDrivers.locationLatitude = map['latitude'];
            activeNearbyAvailableDrivers.locationLongitude = map['longitude'];
            activeNearbyAvailableDrivers.driverId = map['key'];
            GeoFireAssistant.updateActiveNearbyAvailableDriverLocation(
                activeNearbyAvailableDrivers);
            displayActiveDriversOnUsersMap();
            break;

          //display those online active drivers onuser's map
          case Geofire.onGeoQueryReady:
            activeNearbyDriversKeyLoaded = true;
            displayActiveDriversOnUsersMap();
            break;
        }
      }
      setState(() {});
    });
  }

  createActiveNearbyDriverIconMarker() {
    if (activeNearbyIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, kCar).then((value) {
        activeNearbyIcon = value;
      });
    }
  }

  displayActiveDriversOnUsersMap() {
    setState(() {
      markerSet.clear();
      circleSet.clear();
      print('hello');
      Set<Marker> driversMarkerSet = <Marker>{};

      for (ActiveNearbyAvailableDrivers eachDriver
          in GeoFireAssistant.activeNearbyAvailableDriversList) {
        print(eachDriver.locationLatitude!);
        LatLng eachDriverActivePosition =
            LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);
        Marker marker = Marker(
          markerId: MarkerId(eachDriver.driverId!),
          position: eachDriverActivePosition,
          icon: activeNearbyIcon!,
          rotation: 360,
        );
        driversMarkerSet.add(marker);
      }
      setState(() {
        markerSet = driversMarkerSet;
      });
    });
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

  void showSearchingForDriversContainer() {
    setState(() {
      searchingForDriversContainerHeight = 200;
    });
  }

  void showSuggestedRidesContainer() {
    setState(() {
      suggestedRidesContainerHeight = 400.h;
      bottomPaddingofMap = 400.h;
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

  saveRideRequestInformation(String selectedVehicleType) {
//save the rideRequestInformation
    referenceRideRequest =
        FirebaseDatabase.instance.ref().child('All Ride Requests').push();

    var originLocation =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationLocation =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    Map originLocationMap = {
      //'key':'value'}
      'latitude': originLocation!.locationLatitude.toString(),
      'longitude': originLocation.locationLongitude.toString(),
    };

    Map destinationLocationMap = {
      //'key':'value'}
      'latitude': destinationLocation!.locationLatitude.toString(),
      'longitude': destinationLocation.locationLongitude.toString(),
    };

    Map userInformationMap = {
      'origin': originLocationMap,
      'destination': destinationLocationMap,
      'time': DateTime.now().toString(),
      'userName': userModelCurrentInfo!.name,
      'userPhone': userModelCurrentInfo!.phone,
      'originAddress': originLocation.locationName,
      'destinationAddress': destinationLocation.locationName,
      'driverId': 'waiting',
    };

    referenceRideRequest!.set(userInformationMap);

    tripRidesRequestInfoStreamSubscription =
        referenceRideRequest!.onValue.listen(
      (eventSnap) async {
        if (eventSnap.snapshot.value == null) {
          return;
        }
        if ((eventSnap.snapshot.value as Map)['car_details'] != null) {
          setState(() {
            driverCarDetails =
                (eventSnap.snapshot.value as Map)['car_details'].toString();
          });
        }
        if ((eventSnap.snapshot.value as Map)['driverPhone'] != null) {
          setState(() {
            driverCarDetails =
                (eventSnap.snapshot.value as Map)['driverPhone'].toString();
          });
        }
        if ((eventSnap.snapshot.value as Map)['driverName'] != null) {
          setState(() {
            driverCarDetails =
                (eventSnap.snapshot.value as Map)['driverName'].toString();
          });
        }
        if ((eventSnap.snapshot.value as Map)['status'] != null) {
          setState(() {
            userRequestStatus =
                (eventSnap.snapshot.value as Map)['status'].toString();
          });
        }
        if ((eventSnap.snapshot.value as Map)['driverLocation'] != null) {
          double driverCurrentPositionLat = double.parse(
              (eventSnap.snapshot.value as Map)['driverLocation']['latitude']
                  .toString());

          double driverCurrentPositionLng = double.parse(
              (eventSnap.snapshot.value as Map)['driverLocation']['longitude']
                  .toString());
          LatLng driverCurrentPositionLatLng =
              LatLng(driverCurrentPositionLat, driverCurrentPositionLng);

          //status = accepted
          if (userRequestStatus == 'accepted') {
            updateArrivalTimeToUserPickUpLocation(driverCurrentPositionLatLng);
          }

          //status = arrived
          if (userRequestStatus == 'arrived') {
            setState(() {
              driverRideStatus = 'Driver has arrived';
            });
          }

          //status = on trip
          if (userRequestStatus == 'ontrip') {
            updateReachingTimeToUserDropOffLocation(
                driverCurrentPositionLatLng);
          }

          //status = ended
          if (userRequestStatus == 'ended') {
            if ((eventSnap.snapshot.value as Map)['fareAmount'] != null) {
              double fareAmount = double.parse(
                  (eventSnap.snapshot.value as Map)['fareAmount'].toString());

              var response = await showDialog(
                context: context,
                builder: (BuildContext context) => PayFareAmountDialog(
                  fareAmount: fareAmount,
                ),
              );
              if (response == 'Cash Paid') {
                //user can rate driver now

                if ((eventSnap.snapshot.value as Map)['driverId'] != null) {
                  String assignedDriverId =
                      (eventSnap.snapshot.value as Map)['driverId'].toString();
                  // Navigator.pushNamed(context, RateDriverPage.routeName);

                  referenceRideRequest!.onDisconnect();
                  tripRidesRequestInfoStreamSubscription!.cancel();
                }
              }
            }
          }
        }
      },
    );
    onlineNearByAvailableDriversList =
        GeoFireAssistant.activeNearbyAvailableDriversList;
    searchNearestOnlineDrivers(selectedVehicleType);
  }

  searchNearestOnlineDrivers(String selectedVehicleType) async {
    if (onlineNearByAvailableDriversList.isEmpty) {
      //cancel/delete therideRequest Information

      referenceRideRequest!.remove();

      setState(() {
        polylineSet.clear();
        markerSet.clear();
        circleSet.clear();
        pLineCoordinatedList.clear();
      });
      BotToast.showText(text: 'No online nearest Driver Available');
      BotToast.showText(text: 'NSearch Again. \n Restarting App');

      Future.delayed(
        Duration(microseconds: 4000),
        () {
          referenceRideRequest!.remove();
          Navigator.pushNamed(context, SplashScreen.routeName);
        },
      );
      return;
    }
    await retrieveOnlineDriversInformation(onlineNearByAvailableDriversList);
    print("Driver list ${driversList.toString()}");
    print("i am okenyi");
    for (int i = 0; i < driversList.length; i++) {
      print('hello my name is ${driversList[i]}');
      if (driversList[i]['car_details']['car_type'] == selectedVehicleType) {
        print('yesss babbyyyyy');
        // print('goall ${driversList[i]['car_details']['type']}');
        // if (!mounted) return;
        AssistantMethods.sendNotificationToDriverNow(
            driversList[i]['token'], referenceRideRequest!.key!, context);
        print('the device is ${driversList[i]['token']}');
      }
    }
    BotToast.showSimpleNotification(title: 'Notification sent successfully');
    showSearchingForDriversContainer();

    await FirebaseDatabase.instance
        .ref()
        .child('All Ride Requests')
        .child(referenceRideRequest!.key!)
        .child('driverId')
        .onValue
        .listen((eventRideRequestSnapShot) {
      print('EventSnapshot: ${eventRideRequestSnapShot.snapshot.value}');
      if (eventRideRequestSnapShot.snapshot.value != 'waiting') {
        showDesignForAssignedDriverInfo();
      }
    });
  }

  showDesignForAssignedDriverInfo() {
    setState(() {
      waitingResponsefromDriverContainerHeight = 0;
      searchLocationContainerHeight = 0;
      assignedDriverInfoContainerHeight = 200;
      suggestedRidesContainerHeight = 0;
      bottomPaddingofMap = 200;
    });
  }

  retrieveOnlineDriversInformation(List onlineNearestDriversList) async {
    driversList.clear();
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('drivers');
    print(onlineNearestDriversList);
    for (int i = 0; i < onlineNearestDriversList.length; i++) {
      await ref
          .child(onlineNearestDriversList[i].driverId.toString())
          .once()
          .then((dataSnapshot) {
        var driverKeyInfo = dataSnapshot.snapshot.value;
        driversList.add(driverKeyInfo);
        print('driver key information = ${driversList.toString()}');
      });
    }
  }

  updateArrivalTimeToUserPickUpLocation(driverCurrentPositionLatLng) async {
    if (requestPositionInfo == true) {
      requestPositionInfo = false;
      LatLng userPickUpLocation =
          LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

      var directionDetailsInfo =
          await AssistantMethods.obtainOriginToDestinationDirectionDetails(
        driverCurrentPositionLatLng,
        userPickUpLocation,
      );

      if (directionDetailsInfo == null) {
        return;
      }
      setState(() {
        driverRideStatus =
            "Driver is coming: ${directionDetailsInfo.durationText}";
      });
      requestPositionInfo = true;
    }
  }

  updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng) async {
    if (requestPositionInfo == true) {
      requestPositionInfo = false;

      var dropOffLocation =
          Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

      LatLng userDestinationPosition = LatLng(
        dropOffLocation!.locationLatitude!,
        dropOffLocation.locationLongitude!,
      );

      var directionDetailsInfo =
          await AssistantMethods.obtainOriginToDestinationDirectionDetails(
        driverCurrentPositionLatLng,
        userDestinationPosition,
      );

      if (directionDetailsInfo == null) {
        return;
      }
      setState(() {
        driverRideStatus =
            'Going towards Destination ${directionDetailsInfo.durationText}';
      });
      requestPositionInfo = true;
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfLocationPermissionAllowed();
    // createActiveNearbyDriverIconMarker();
  }

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  @override
  Widget build(BuildContext context) {
    createActiveNearbyDriverIconMarker();
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
                // createActiveNearbyDriverIconMarker();
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
                                    child: InkWell(
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, PrecisePickUpPage.routeName);
                                  },
                                  child: Container(
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
                                              fontSize: 15.sp,
                                              color: kPrimaryColor2),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (Provider.of<AppInfo>(context,
                                                listen: false)
                                            .userDropOffLocation !=
                                        null) {
                                      showSuggestedRidesContainer();
                                    } else {
                                      BotToast.showSimpleNotification(
                                          title:
                                              'Please Select Destination Location');
                                    }
                                  },
                                  child: Container(
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
                                      '           Show Fare          ',
                                      style: theme(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontSize: 15.sp,
                                          ),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                )),

            //ui for suggested rides
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: suggestedRidesContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: kPrimaryColor2,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: const Icon(
                              Icons.star,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          Expanded(
                            child: Text(
                              Provider.of<AppInfo>(context)
                                          .userPickUpLocation !=
                                      null
                                  ? Provider.of<AppInfo>(context)
                                      .userPickUpLocation!
                                      .locationName!
                                  : 'Loading...',
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                  ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: kPrimaryColor2.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: const Icon(
                                Icons.star,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            Text(
                              Provider.of<AppInfo>(context)
                                          .userDropOffLocation !=
                                      null
                                  ? Provider.of<AppInfo>(context)
                                      .userDropOffLocation!
                                      .locationName!
                                  : 'Loading...',
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                  ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'SUGGESTED RIDES',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.black,
                              fontSize: 15.sp,
                            ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedVehicleType = 'Private';
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: selectedVehicleType == 'Private'
                                    ? kPrimaryColor2
                                    : Colors.grey[100],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      kPrivate,
                                      height: 90,
                                      width: 80,
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Text(
                                      'Private',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontSize: 14.sp,
                                            color:
                                                selectedVehicleType == 'Private'
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    Text(
                                      tripDirectionDetailsInfo != null
                                          ? '#${((AssistantMethods.calCulateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!) * 2) * 107).toStringAsFixed(1)}'
                                          : 'null',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color:
                                                selectedVehicleType == 'Private'
                                                    ? Colors.white
                                                    : Colors.black54,
                                            fontSize: 14.sp,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedVehicleType = 'Shared';
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: selectedVehicleType == 'Shared'
                                    ? kPrimaryColor2
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      kShared,
                                      height: 90,
                                      width: 80,
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Text(
                                      'Shared',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontSize: 14.sp,
                                            color:
                                                selectedVehicleType == 'Shared'
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    Text(
                                      tripDirectionDetailsInfo != null
                                          ? '#${((AssistantMethods.calCulateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!) * 1.5) * 107).toStringAsFixed(1)}'
                                          : 'null',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color:
                                                selectedVehicleType == 'Shared'
                                                    ? Colors.white
                                                    : Colors.black54,
                                            fontSize: 14.sp,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedVehicleType = 'Commercial';
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: selectedVehicleType == 'Commercial'
                                    ? kPrimaryColor2
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      kCommercial,
                                      height: 90,
                                      width: 80,
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Text(
                                      'Commercial',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontSize: 14.sp,
                                            color: selectedVehicleType ==
                                                    'Commercial'
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    Text(
                                      tripDirectionDetailsInfo != null
                                          ? '#${((AssistantMethods.calCulateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!) * 0.8) * 107).toStringAsFixed(1)}'
                                          : 'null',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color: selectedVehicleType ==
                                                    'Commercial'
                                                ? Colors.white
                                                : Colors.black54,
                                            fontSize: 14.sp,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, SelectDatePage.routeName);
                              },
                              child: Container(
                                // width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.h, horizontal: 10.w),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: kPrimaryColor2, width: 2),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: Text(
                                    'Schedule Trip',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 15.sp,
                                          color: kPrimaryColor2,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (selectedVehicleType != '') {
                                  saveRideRequestInformation(
                                      selectedVehicleType);
                                } else {
                                  BotToast.showSimpleNotification(
                                      title:
                                          'Please select a vehicle from suggested rides');
                                }
                              },
                              child: Container(
                                // width: double.infinity,
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
                                child: Center(
                                  child: Text(
                                    'Book Now',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 15.sp,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            // Requesting a Ride
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Container(
                height: searchingForDriversContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 18.h,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const LinearProgressIndicator(
                        backgroundColor: Colors.white,
                        color: kPrimaryColor2,
                      ),
                      // SpinKitDancingSquare(
                      //   size: 20,
                      // ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Center(
                        child: Text(
                          'Searching for a driver...',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.grey,
                                    fontSize: 22.sp,
                                  ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          referenceRideRequest!.remove();
                          setState(() {
                            searchingForDriversContainerHeight = 0;
                            suggestedRidesContainerHeight = 0;
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 25,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        'Cancel',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.red,
                              fontSize: 13.sp,
                            ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}





// Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 selectedVehicleType = 'Private';
//                               });
//                             },
//                             child: Container(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 15.w, vertical: 10.h),
//                               decoration: BoxDecoration(
//                                 color: selectedVehicleType == 'Private'
//                                     ? kPrimaryColor2
//                                     : Colors.grey[400],
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Column(
//                                 children: [
//                                   Image.asset(
//                                     kShared,
//                                     height: 90,
//                                     width: 80,
//                                   ),
//                                   SizedBox(
//                                     height: 8.h,
//                                   ),
//                                   Text(
//                                     'Private',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodySmall!
//                                         .copyWith(
//                                           color:
//                                               selectedVehicleType == 'Private'
//                                                   ? Colors.white
//                                                   : Colors.black,
//                                           fontSize: 14.sp,
//                                         ),
//                                   ),
//                                   SizedBox(
//                                     height: 2.h,
//                                   ),
//                                   Text(
//                                     tripDirectionDetailsInfo != null
//                                         ? '#${((AssistantMethods.calCulateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!) * 2) * 107).toStringAsFixed(1)}'
//                                         : 'null',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodySmall!
//                                         .copyWith(
//                                           color: Colors.black,
//                                           fontSize: 14.sp,
//                                         ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 selectedVehicleType = 'Shared';
//                               });
//                             },
//                             child: Container(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 15.w, vertical: 15.h),
//                               decoration: BoxDecoration(
//                                 color: selectedVehicleType == 'Shared'
//                                     ? kPrimaryColor2
//                                     : Colors.grey[400],
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 10.h, horizontal: 10.w),
//                                 child: Column(
//                                   children: [
//                                     Image.asset(
//                                       kPin,
//                                       height: 90,
//                                       width: 80,
//                                     ),
//                                     SizedBox(
//                                       height: 8.h,
//                                     ),
//                                     Text(
//                                       'Shared',
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .bodySmall!
//                                           .copyWith(
//                                             color:
//                                                 selectedVehicleType == 'Shared'
//                                                     ? Colors.white
//                                                     : Colors.black,
//                                             fontSize: 14.sp,
//                                           ),
//                                     ),
//                                     SizedBox(
//                                       height: 2.h,
//                                     ),
//                                     Text(
//                                       tripDirectionDetailsInfo != null
//                                           ? '#${((AssistantMethods.calCulateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!) * 1.5) * 107).toStringAsFixed(1)}'
//                                           : 'null',
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .bodySmall!
//                                           .copyWith(
//                                             color: Colors.black,
//                                             fontSize: 14.sp,
//                                           ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 selectedVehicleType = 'Commercial';
//                               });
//                             },
//                             child: Container(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 15.w, vertical: 15.h),
//                               decoration: BoxDecoration(
//                                 color: selectedVehicleType == 'Commercial'
//                                     ? kPrimaryColor2
//                                     : Colors.grey[400],
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 25.h, horizontal: 25.w),
//                                 child: Column(
//                                   children: [
//                                     Image.asset(
//                                       kPin,
//                                       height: 30,
//                                       width: 30,
//                                     ),
//                                     SizedBox(
//                                       height: 8.h,
//                                     ),
//                                     Text(
//                                       'Commercial',
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .bodySmall!
//                                           .copyWith(
//                                             color: selectedVehicleType ==
//                                                     'Commercial'
//                                                 ? Colors.white
//                                                 : Colors.black,
//                                             fontSize: 14.sp,
//                                           ),
//                                     ),
//                                     SizedBox(
//                                       height: 2.h,
//                                     ),
//                                     Text(
//                                       tripDirectionDetailsInfo != null
//                                           ? '#${((AssistantMethods.calCulateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!) * 0.8) * 107).toStringAsFixed(1)}'
//                                           : 'null',
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .bodySmall!
//                                           .copyWith(
//                                             color: Colors.black,
//                                             fontSize: 14.sp,
//                                           ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),

