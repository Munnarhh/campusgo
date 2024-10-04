import 'package:campusgo/core/constants/constants.dart';
import 'package:campusgo/core/info_handler/app_info.dart';

import 'package:campusgo/core/assistant/request_assistant.dart';
import 'package:campusgo/features/home/data/models/directions.dart';
import 'package:campusgo/features/home/data/models/predicted_places.dart';
import 'package:campusgo/features/home/presentation/widgets/progress_dialog.dart';
import 'package:campusgo/global/global.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PredictionPlaceTileDesign extends StatefulWidget {
  final PredictedPlaces? predictedPlaces;
  const PredictionPlaceTileDesign({super.key, this.predictedPlaces});

  @override
  State<PredictionPlaceTileDesign> createState() =>
      _PredictionPlaceTileDesignState();
}

class _PredictionPlaceTileDesignState extends State<PredictionPlaceTileDesign> {
  getPlaceDirectionDetails(String? placeId, context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const ProgressDialog(
        message: 'Setting Up Please wait....',
      ),
    );
    String placeDirectionDetailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$kMapKey';
    var responseApi =
        await RequestAssistant.receiveRequest(placeDirectionDetailsUrl);
    Navigator.pop(context);

    if (responseApi == 'Error Occured. Failed. No Response') {
      return;
    }
    if (responseApi['status'] == 'OK') {
      Directions directions = Directions();
      directions.locationName = responseApi['result']['name'];
      directions.locationId = placeId;
      directions.locationLatitude =
          responseApi['result']['geometry']['location']['lat'];
      directions.locationLongitude =
          responseApi['result']['geometry']['location']['lng'];

      Provider.of<AppInfo>(context, listen: false)
          .updateDropOffLocationAddress(directions);

      setState(() {
        userDropOffAddress = directions.locationName!;
      });

      Navigator.pop(context, "obtainedDropOff");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        getPlaceDirectionDetails(widget.predictedPlaces!.placeId, context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        child: Row(
          children: [
            const Icon(
              Icons.location_on,
              color: kPrimaryColor2,
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.predictedPlaces!.mainText!,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.black,
                          fontSize: 15.sp,
                        ),
                  ),
                  Text(
                    widget.predictedPlaces!.secondaryText!,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.black,
                          fontSize: 15.sp,
                        ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
