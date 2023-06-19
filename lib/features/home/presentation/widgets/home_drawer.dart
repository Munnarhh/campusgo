import 'package:campusgo/features/home/presentation/widgets/home_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/constants.dart';
import '../../../menu/presentation/pages/promo_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../ride/presentation/pages/my_ride.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 30.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ProfilePage.routeName);
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35.r,
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Eren',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.black, fontSize: 16.sp),
                      ),
                      Text(
                        'Edit profile',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(color: Colors.black, fontSize: 14.sp),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const Divider(
            color: kDividerColor,
            thickness: 1.5,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeTile(
                  leading: kCreditCard,
                  title: 'Payments',
                  onTap: () {
                    // Handle payments tap
                  },
                ),
                HomeTile(
                  title: 'Promotions',
                  leading: kTag,
                  onTap: () {
                    Navigator.pushNamed(context, PromoPage.routeName);
                  },
                  subtitle: 'Enter Promo Code',
                ),
                HomeTile(
                  leading: kClock,
                  title: 'My Rides',
                  onTap: () {
                    Navigator.pushNamed(context, MyRidesPage.routeName);
                  },
                ),
                HomeTile(
                  leading: kMessage,
                  title: 'Support',
                  onTap: () {
                    // Handle support tap
                  },
                ),
                HomeTile(
                  leading: kAlertCircle,
                  title: 'About',
                  onTap: () {
                    // Handle about tap
                  },
                ),
                HomeTile(
                  leading: kBriefcase,
                  title: 'Campus Rides',
                  onTap: () {
                    // Handle campus rides tap
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                CircleAvatar(
                  radius: 25.r,
                  backgroundColor: kErrorColor,
                  child: Text(
                    'SOS',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white, fontSize: 18.sp),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
