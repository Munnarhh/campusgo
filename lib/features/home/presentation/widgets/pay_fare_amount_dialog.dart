import 'package:campusgo/core/constants/constants.dart';
import 'package:campusgo/features/onboarding/presentation/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PayFareAmountDialog extends StatefulWidget {
  double? fareAmount;
  PayFareAmountDialog({Key? key, this.fareAmount});

  @override
  State<PayFareAmountDialog> createState() => _PayFareAmountDialogState();
}

class _PayFareAmountDialogState extends State<PayFareAmountDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 10.h,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: kPrimaryColor2,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              'Fare Amount'.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: kPrimaryColor2, fontSize: 16.sp),
            ),
            SizedBox(
              height: 20.h,
            ),
            const Divider(
              thickness: 2,
              color: Colors.white,
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              '#${widget.fareAmount.toString()}',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.white,
                    fontSize: 50.sp,
                  ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 10.w,
              ),
              child: Text(
                'This is the total trip fare amount. Please pay it to your driver',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 20.h,
              ),
              child: ElevatedButton(
                onPressed: () {
                  Future.delayed(const Duration(milliseconds: 10000), () {
                    Navigator.pop(context, 'cash paid');
                    Navigator.pushNamed(context, SplashScreen.routeName);
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pay Cash',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: kPrimaryColor2, fontSize: 20.sp),
                    ),
                    Text('#${widget.fareAmount.toString()}'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 20.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(
                      'OR',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 20.h,
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Add your logic for "Pay with Card" button here
                },
                child: Text(
                  'Pay with Card',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: kPrimaryColor2, fontSize: 20.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
