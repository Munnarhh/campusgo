import 'package:campusgo/core/constants/constants.dart';
import 'package:campusgo/core/widgets/primarybutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SuccessPage extends StatelessWidget {
  static String routeName = 'SuccessPage';
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(kBackgroundColor),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Payment ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.black),
                ),
                TextSpan(
                  text: 'Successful!',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: const Color(kPrimaryColor),
                      ),
                )
              ],
            ),
          ),
          SvgPicture.asset(
            kSuccess,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: PrimaryButton(text: 'Proceed', onPressed: () {}),
          )
        ],
      ),
    );
  }
}
