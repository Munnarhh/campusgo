import 'package:campusgo/features/ride/presentation/pages/options_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/primarybutton.dart';

class ForgotPasswordPage extends StatelessWidget {
  static String routeName = 'ForgotPasswordPage';
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(kBackgroundColor),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 136.h,
            ),
            Text(
              'Forgot Password?',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.black,
                  ),
            ),
            // RichText(
            //   textAlign: TextAlign.center,
            //   text: TextSpan(
            //     children: [
            //       TextSpan(
            //         text: "Forgot ",
            //         style: Theme.of(context)
            //             .textTheme
            //             .bodyLarge!
            //             .copyWith(color: Colors.black),
            //       ),
            //       TextSpan(
            //         text: 'Password?',
            //         style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            //               color: const Color(kPrimaryColor),
            //             ),
            //       )
            //     ],
            //   ),
            // ),
            SizedBox(height: 24.h),
            Text(
              'Please enter your email address to reset your password.',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.black.withOpacity(0.7),
                  ),
            ),
            SizedBox(height: 24.h),
            Text(
              'E-mail',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.black, fontSize: 16.sp),
            ),
            SizedBox(
              height: 4.h,
            ),

            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'student@example.com',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!EmailValidator.validate(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.black, fontSize: 15.sp),
            ),
            SizedBox(height: 24.h),
            PrimaryButton(
              text: 'Submit',
              onPressed: () {
                Navigator.pushNamed(context, OptionsPage.routeName);
                // Add send email functionality here
              },
            ),
            DraggableScrollableSheet(builder: (_, controller) {
              return Column();
            })
          ],
        ),
      ),
    );
  }
}
