import 'dart:convert';

import 'package:campusgo/core/assistant/request_assistant.dart';
import 'package:campusgo/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../info_handler/app_info.dart';
import '../../features/home/data/models/direction_details_info.dart';
import '../../features/home/data/models/directions.dart';
import '../../features/home/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class AssistantMethods {
  static void readCurrentOnlineUserInfo() async {
    currentUser = firebaseAuth.currentUser;
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('users').child(currentUser!.uid);

    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      }
    });
  }

  static Future<String> searchAddressforGeographicCoordinates(
      Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$kMapKey";
    String humanReadableAddress = '';
    // print(position.latitude);
    // print(position.latitude);

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if (requestResponse != 'Error Occured. Failed. No Response.') {
      humanReadableAddress = requestResponse['results'][0]['formatted_address'];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }
    print('human address is $humanReadableAddress');
    return humanReadableAddress;
  }

  static Future<DirectionDetailsInfo> obtainOriginToDestinationDirectionDetails(
      LatLng originPosition, LatLng destinationPosition) async {
    print(originPosition.latitude);
    print(originPosition.longitude);
    print(destinationPosition.latitude);
    print(destinationPosition.longitude);
    String urlOriginToDestinationDirectionDetails =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$kMapKey";
    var responseDirectionApi = await RequestAssistant.receiveRequest(
        urlOriginToDestinationDirectionDetails);

    if (responseDirectionApi == 'Error Ocurred. Failed. No Response') {
      print('noooooooooooooooooooooooooooooooooooooooooooooooooooooo');
    }
    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.ePoints =
        responseDirectionApi['routes'][0]['overview_polyline']['points'];
    directionDetailsInfo.distanceText =
        responseDirectionApi['routes'][0]['legs'][0]['distance']['text'];
    directionDetailsInfo.distanceValue =
        responseDirectionApi['routes'][0]['legs'][0]['distance']['value'];
    directionDetailsInfo.durationText =
        responseDirectionApi['routes'][0]['legs'][0]['duration']['text'];
    directionDetailsInfo.durationValue =
        responseDirectionApi['routes'][0]['legs'][0]['duration']['value'];
    return directionDetailsInfo;
  }

  static double calCulateFareAmountFromOriginToDestination(
      DirectionDetailsInfo directionDetailsInfo) {
    double timeTraveledFareAmountPerMinute =
        (directionDetailsInfo.durationValue! / 60) * 0.1;
    double distanceTravelledFareAmountPerKilometer =
        (directionDetailsInfo.durationValue! / 1000) * 0.1;

    //usd
    double totalFareAmount = timeTraveledFareAmountPerMinute +
        distanceTravelledFareAmountPerKilometer;
    return double.parse(totalFareAmount.toStringAsFixed(1));
  }

  static sendNotificationToDriverNow(
      String deviceRegistrationToken, String userRideRequestId, context) {
    String destinationAddress = userDropOffAddress;
    print('hello');
    print('hello my is$deviceRegistrationToken');
    Map<String, String> headerNotification = {
      'Content-Type': 'application/json',
      'Authorization': cloudMessagingServerToken,
    };

    Map bodyNotification = {
      'body': 'Destination Address: \n$destinationAddress.',
      'title': 'New Trip Request'
    };

    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'rideRequestId': userRideRequestId,
    };

    Map officialNotificationFormat = {
      'notification': bodyNotification,
      'data': dataMap,
      'priority': 'high',
      'to': deviceRegistrationToken,
    };
    var responseNotification = http.post(
      Uri.parse(
        'https://fcm.googleapis.com/fcm/send',
      ),
      headers: headerNotification,
      body: jsonEncode(officialNotificationFormat),
    );
  }
}
