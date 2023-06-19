import 'package:campusgo/core/constants/constants.dart';
import 'package:campusgo/features/menu/presentation/pages/promo.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/widgets/title_text.dart';

class PromoPage extends StatelessWidget {
  static String routeName = 'PromoPage';
  const PromoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(kBackgroundColor),
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: kPrimaryColor2),
      ),
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: const TitleText(text: 'Promotions'),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                color: Colors.grey[300],
                height: 3.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ListTile(
                  minLeadingWidth: 0.w,
                  contentPadding: EdgeInsets.zero,
                  leading: SvgPicture.asset(
                    kTag,
                    width: 24.w,
                    height: 24.h,
                  ),
                  title: Text(
                    'Enter promo code',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.black,
                          fontSize: 16.sp,
                        ),
                  ),
                  trailing: SvgPicture.asset(
                    kRight,
                    color: kPrimaryColor2,
                    width: 7.w,
                    height: 12.w,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, PromoCodePage.routeName);
                  },
                ),
              ),
            ],
          ),
          Container(
            color: Colors.grey[300],
            height: 3.h,
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50.sp,
                    width: 50.sp,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: Center(
                      child: SvgPicture.asset(kFilledTag),
                    ),
                  ),
                  Text(
                    'Your promotions\n will appear here',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: 14.sp,
                          color: const Color(0XFF5C5C5C),
                        ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
