import 'package:campusgo/features/home/assistant/request_assistant.dart';
import 'package:campusgo/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/constants.dart';
import '../../../core/info_handler/app_info.dart';
import '../data/models/direction_details_info.dart';
import '../data/models/directions.dart';
import '../data/models/user_model.dart';

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
}
