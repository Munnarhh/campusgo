import 'package:campusgo/features/ride/presentation/widgets/ride_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/title_text.dart';

class MyRidesPage extends StatefulWidget {
  static String routeName = 'MyRidesPage';
  const MyRidesPage({super.key});

  @override
  State<MyRidesPage> createState() => _MyRidesPageState();
}

class _MyRidesPageState extends State<MyRidesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(kBackgroundColor),
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: kPrimaryColor2),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleText(text: 'My Rides'),
            SizedBox(height: 20.h),
            Text(
              'Oct 2022',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 14.sp, color: Colors.black),
            ),
            RideTile(
              title: 'Isolo',
              onTap: () {},
              subtitle: '20 Oct, 2:00',
              trailing: "₦ 15,000",
            ),
            const Divider(
              color: Color(0xFFD6D6D6),
              thickness: 2,
            ),
            RideTile(
              title: 'MurItala Muhammed Airport',
              onTap: () {},
              subtitle: '20 Oct, 2:00',
              trailing: "₦ 15,000",
            ),
            const Divider(
              color: Color(0xFFD6D6D6),
              thickness: 2,
            ),
            RideTile(
              title: 'Victoria Island',
              onTap: () {},
              subtitle: '20 Oct, 2:00',
              trailing: "₦ 15,000",
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Nov 2022',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 14.sp, color: Colors.black),
            ),
            RideTile(
              title: 'Victoria Island',
              onTap: () {},
              subtitle: '20 Oct, 2:00',
              trailing: "₦ 15,000",
            ),
            const Divider(
              color: Color(0xFFD6D6D6),
              thickness: 2,
            ),
            RideTile(
              title: 'Okota',
              onTap: () {},
              subtitle: '20 Oct, 2:00',
              trailing: "₦ 15,000",
            ),
          ],
        ),
      ),
    );
  }
}
