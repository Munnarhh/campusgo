import 'package:campusgo/features/authentication/presentation/views/loginpage.dart';
import 'package:campusgo/features/authentication/presentation/views/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/constants.dart';

class LoginRegister extends StatefulWidget {
  static String routeName = 'LoginRegister';
  const LoginRegister({super.key});

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: const Color(kBackgroundColor),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
        child: Column(
          children: [
            SizedBox(height: 136.h),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Welcome to ',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                  ),
                  TextSpan(
                    text: 'CampusGO!',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(kPrimaryColor),
                        ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 45.h,
            ),
            TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black.withOpacity(0.7),

              labelStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 15.sp),
              unselectedLabelStyle: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontSize: 15.sp),
              //dividerColor: Colors.pink[750],
              indicatorColor: Colors.black,

              indicatorWeight: 1,
              indicatorSize: TabBarIndicatorSize.tab,
              controller: _tabController,
              tabs: const [
                Tab(
                  text: 'Login',
                ),
                Tab(
                  text: 'Register',
                ),
              ],
            ),
            SizedBox(
              height: 18.h,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const ClampingScrollPhysics(),
                children: [
                  const LoginPage(),
                  Builder(
                    builder: (BuildContext context) => const RegistrationPage(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
