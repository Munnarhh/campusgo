import 'package:campusgo/core/assistant/request_assistant.dart';
import 'package:campusgo/features/home/data/models/predicted_places.dart';
import 'package:campusgo/features/home/presentation/widgets/place_prediction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/constants.dart';

class SearchPlacePlage extends StatefulWidget {
  static String routeName = 'SearchPlace';
  const SearchPlacePlage({super.key});

  @override
  State<SearchPlacePlage> createState() => _SearchPlacePlageState();
}

class _SearchPlacePlageState extends State<SearchPlacePlage> {
  List<PredictedPlaces> placesPredictedList = [];
  findPlaceAutoCompleteSearch(String inputText) async {
    if (inputText.length > 1) {
      String urlAutoCompleteSearch =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$kMapKey&components=country:NG";

      var responseAutoCompleteSearch =
          await RequestAssistant.receiveRequest(urlAutoCompleteSearch);

      if (responseAutoCompleteSearch == 'Error Ocurred. Failed. No Response.') {
        return;
      }

      if (responseAutoCompleteSearch['status'] == 'OK') {
        var placePredictions = responseAutoCompleteSearch['predictions'];

        var placePredictionsList = (placePredictions as List)
            .map((jsonData) => PredictedPlaces.fromJson(jsonData))
            .toList();

        setState(() {
          placesPredictedList = placePredictionsList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          //leadingWidth: 1,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: const Color(kPrimaryColor),
          centerTitle: true,
          title: Text(
            'Search and Set Dropoff Location',
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 20.sp,
                ),
          ),
        ),
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: kPrimaryColor2,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white54,
                    blurRadius: 8,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.adjust_sharp,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 18.w,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 8.h),
                            child: TextField(
                              onChanged: (value) {
                                findPlaceAutoCompleteSearch(value);
                              },
                              decoration: const InputDecoration(
                                  hintText: 'Search Location here...'),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            //display placeredictions result
            (placesPredictedList.isNotEmpty)
                ? Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return PredictionPlaceTileDesign(
                          predictedPlaces: placesPredictedList[index],
                        );
                      },
                      physics: const ClampingScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          height: 0,
                          color: kPrimaryColor2,
                          thickness: 0,
                        );
                      },
                      itemCount: placesPredictedList.length,
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
