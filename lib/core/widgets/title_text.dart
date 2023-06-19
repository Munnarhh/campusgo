import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleText extends StatelessWidget {
  final String text;
  const TitleText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Colors.black,
            fontSize: 24.sp,
          ),
    );
  }
}
