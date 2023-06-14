import 'package:campusgo/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  final String? title;
  final String? icon;
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: kPrimaryColor2,
                ),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(icon!),
                Text(
                  title!,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 16.sp,
                        color: Colors.black,
                        //fontWeight: FontWeight.w700,
                      ),
                ),
                SvgPicture.asset(kRightArrow)
              ],
            ),
          ),
          SizedBox(height: 10.h)
        ],
      ),
    );
  }
}
