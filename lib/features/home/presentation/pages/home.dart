import 'package:campusgo/core/constants/constants.dart';
import 'package:campusgo/features/menu/presentation/pages/promo_page.dart';
import 'package:campusgo/features/profile/presentation/pages/profile_page.dart';
import 'package:campusgo/features/ride/presentation/pages/my_ride.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/home_drawer.dart';
import '../widgets/home_tile.dart';

class Home extends StatefulWidget {
  static String routeName = 'Home';
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double _percent = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Positioned.fill(
            bottom: MediaQuery.of(context).size.height * 0.2,
            child: Image.asset(
              kSchool,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 16,
            top: 50,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              child: SvgPicture.asset(kMenu),
            ),
          ),
          Positioned.fill(
            // top: MediaQuery.of(context).size.height * 0.1,

            child: NotificationListener<DraggableScrollableNotification>(
              onNotification: (notification) {
                setState(() {
                  _percent = 2 * notification.extent - 0.8;
                });

                return true;
              },
              child: DraggableScrollableSheet(
                maxChildSize: 0.9,
                minChildSize: 0.4,
                initialChildSize: 0.4,
                // expand: false,
                builder: (_, controller) {
                  return ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Material(
                      color: const Color(kBackgroundColor),
                      elevation: 10,
                      child: Container(
                        color: const Color(kBackgroundColor),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    height: 2.h,
                                    width: 50.h,
                                    color: kPrimaryColor2,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                'It is good to see you',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                      color: Colors.black,
                                      fontSize: 14.sp,
                                    ),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Text(
                                'Where are you going?',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Colors.black,
                                      fontSize: 20.sp,
                                    ),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              const TextField(
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: kPrimaryColor2,
                                    ),
                                    hintText: 'Search Destination'),
                              ),
                              Expanded(
                                child: ListView.builder(
                                    padding: EdgeInsets.only(bottom: 40.h),
                                    itemCount: 20,
                                    controller: controller,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        // minLeadingWidth: 0.w,
                                        leading: const Icon(
                                          Icons.location_on_outlined,
                                          size: 25,
                                          color: kPrimaryColor2,
                                        ),
                                        title: Text(
                                          'Address: $index',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                color: Colors.black,
                                                fontSize: 15.sp,
                                              ),
                                        ),
                                        subtitle: Text(
                                          'City $index',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall!
                                              .copyWith(
                                                color: Colors.black,
                                                fontSize: 14.sp,
                                              ),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: -170 * (1 - _percent),
            child: Opacity(
              opacity: _percent,
              child: const _SearchDestination(),
            ),
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: -50 * (1 - _percent),
            child: Opacity(
              opacity: _percent,
              child: const _PickPlaceInMap(),
            ),
          ),
          // Positioned(
          //   right: 16,
          //   bottom: 310,
          //   child: FloatingActionButton(
          //     backgroundColor: Colors.white,
          //     onPressed: () {
          //       // Add your onPressed logic here
          //     },
          //     child: const Icon(
          //       Icons.navigation_sharp,
          //       color: Colors.black,
          //     ),
          //   ),
          // ),
        ],
      ),
      drawer: const HomeDrawer(),
    );
  }
}

class _PickPlaceInMap extends StatelessWidget {
  const _PickPlaceInMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.place_sharp,
              color: kPrimaryColor2,
            ),
            SizedBox(
              width: 10.w,
            ),
            Text(
              'Pick in map',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.black,
                    fontSize: 14.sp,
                    //fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchDestination extends StatelessWidget {
  const _SearchDestination({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(kBackgroundColor),
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const BackButton(),
              Text(
                'Choose Destination',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.black,
                      fontSize: 20.sp,
                    ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        const Icon(
                          Icons.circle,
                          color: Colors.red,
                          size: 12,
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Avenue 24 NO 219',
                          fillColor: Colors.grey[100],
                          filled: true,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Column(
                      children: [
                        const Icon(
                          Icons.circle,
                          color: Colors.green,
                          size: 12,
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Where are you going?',
                          fillColor: Colors.grey[100],
                          filled: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}















// Stack(
//         children: [
//           // Map widget
//           Container(
//             width: double.infinity,
//             height: double.infinity,
//             // Replace this with your map widget
//             color: Colors.blue,
//           ),

//           // Snackbar menu
//           Positioned(
//               top: 50.0,
//               left: 16.0,
//               child: GestureDetector(
//                 onTap: () {
//                   _scaffoldKey.currentState!.openDrawer();
//                 },
//                 child: CircleAvatar(
//                   backgroundColor: Colors.white,
//                   child: SvgPicture.asset(kMenu),
//                 ),
//               )),

//           // Search field
//           DraggableScrollableSheet(
//             initialChildSize: 0.2,
//             minChildSize: 0.2,
//             maxChildSize: 0.9,
//             builder: (context, scrollController) {
//               return Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(12.0),
//                     topRight: Radius.circular(12.0),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.3),
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                       offset: const Offset(0, -3),
//                     ),
//                   ],
//                 ),
//                 child: SingleChildScrollView(
//                   controller: scrollController,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         TextField(
//                           decoration: InputDecoration(
//                             hintText: 'Where to?',
//                             prefixIcon: Icon(Icons.search),
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                         SizedBox(height: 16.0),
//                         // Add more widgets to the bottom sheet as needed
//                         Text('Additional content'),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],

// Container(
//           height: 80.h,
//           width: 100.h,
//           color: Colors.white,
//           child: const SpinKitFadingFour(
//             color: Colors.black,
//           ),
//         ),
