import 'package:firebase_auth/firebase_auth.dart';

import '../features/home/data/models/direction_details_info.dart';
import '../features/home/data/models/user_model.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;

UserModel? userModelCurrentInfo;

String cloudMessagingServerToken =
    '';
String userDropOffAddress = "";
DirectionDetailsInfo? tripDirectionDetailsInfo;
String driverCarDetails = "";
String driverName = "";
String driverPhone = "";
List driversList = [];

double countRatingStars = 0.0;
String titleStarsRating = "";
