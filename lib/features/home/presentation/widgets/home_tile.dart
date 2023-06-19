import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeTile extends StatelessWidget {
  final String title;
  final String leading;
  final VoidCallback onTap;
  final String subtitle;
  const HomeTile({
    super.key,
    required this.title,
    required this.leading,
    required this.onTap,
    this.subtitle = '',
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        minLeadingWidth: 0.w,
        contentPadding: EdgeInsets.zero,
        leading: SvgPicture.asset(
          leading,
          width: 24.w,
          height: 24.h,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.black,
                fontSize: 14.sp,
              ),
        ),
        subtitle: subtitle.isNotEmpty
            ? Text(
                subtitle,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 12.sp,
                    ),
              )
            : null,
        onTap: onTap);
  }
}
