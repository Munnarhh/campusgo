import 'package:firebase_auth/firebase_auth.dart';

import '../features/home/data/models/direction_details_info.dart';
import '../features/home/data/models/user_model.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;

UserModel? userModelCurrentInfo;

String cloudMessagingServerToken =
    'key=AAAAxTJLnHM:APA91bGVRSRZoPQ5bGYQafzWkNDgfEzaoghfckNMYpf69SoTwUSkh0HWzZVa-tIw1PgeNnlcoh0ajqgE40y50JjUTEyVPursRJMQAGLUMMF6qDHBYE08-3wer-DkLm66vPYoH_crcagh';
String userDropOffAddress = "";
DirectionDetailsInfo? tripDirectionDetailsInfo;
String driverCarDetails = "";
String driverName = "";
String driverPhone = "";
List driversList = [];

double countRatingStars = 0.0;
String titleStarsRating = "";
