import 'package:campusgo/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RideTile extends StatelessWidget {
  final String title;

  final VoidCallback onTap;
  final String subtitle;
  final String trailing;
  const RideTile({
    super.key,
    required this.title,
    required this.onTap,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        minLeadingWidth: 0.w,
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
          height: 55.h,
          width: 55.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: kPrimaryColor2,
          ),
          child: Image.asset(
            kCar,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.black,
                fontSize: 14.sp,
              ),
        ),
        trailing: Text(
          trailing,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
            color: Colors.black,
            letterSpacing: 0,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: Colors.black,
                fontSize: 12.sp,
              ),
        ),
        onTap: onTap);
  }
}
