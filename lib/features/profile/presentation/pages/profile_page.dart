import 'package:campusgo/core/constants/constants.dart';
import 'package:campusgo/features/profile/presentation/pages/change_password.dart';
import 'package:campusgo/features/ride/presentation/pages/calendar.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/logout_button.dart';
import '../widgets/profile_button.dart';

class ProfilePage extends StatelessWidget {
  static String routeName = 'ProfilePage';
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(kBackgroundColor),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SizedBox(height: 80.h),
            Center(
              child: Image.asset(
                kProfileAvatar,
                width: 100.w,
                height: 110.h,
              ),
            ),
            SizedBox(height: 5.h),

            /// User Name
            Text(
              'Emeka Chukwudi',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.black, fontSize: 22.sp),
            ),

            /// View Profile Button
            GestureDetector(
              onTap: () {},
              child: Text(
                'View Profile',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 14.sp,
                    ),
              ),
            ),
            SizedBox(height: 25.h),

            ///Change Password
            ProfileButton(
              icon: kLock,
              title: 'Change Password',
              onPressed: () {
                Navigator.pushNamed(context, ChangePasswordPage.routeName);
              },
            ),

            /// Change Pin
            ProfileButton(
              title: 'Update Profile',
              icon: kKey,
              onPressed: () {
                Navigator.pushNamed(context, SelectDatePage.routeName);
              },
            ),

            /// Terms and Condition
            ProfileButton(
              title: 'Terms and Condition',
              icon: kTerms,
              onPressed: () {
                //Navigator.pushNamed(context, TermsAndConditionScreen.id);
              },
            ),

            /// Privacy Policy
            ProfileButton(
              title: 'Privacy Policy',
              icon: kPrivacy,
              onPressed: () {
                // Navigator.pushNamed(context, PrivacyPolicyScreen.id);
              },
            ),

            /// Help and Support
            ProfileButton(
              title: 'Help and Support',
              icon: kHelp,
              onPressed: () {
                // Navigator.pushNamed(context, HelpAndSupportScreen.id);
              },
            ),
            SizedBox(height: 30.h),

            /// Log Out Button
            LogOutButton(
              text: 'Log Out',
              onPressed: () {
                // Navigator.pushNamedAndRemoveUntil(
                //     context, LoginScreen.id, (route) => false);
              },
            )
          ],
        ),
      ),
    );
  }
}
