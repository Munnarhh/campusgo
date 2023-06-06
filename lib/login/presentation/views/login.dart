import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/constants.dart';

class LoginRegister extends StatefulWidget {
  static String routeName = 'LoginRegister';
  const LoginRegister({super.key});

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(kBackgroundColor),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
          child: Column(
            children: [
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
                unselectedLabelColor: Colors.grey[750],
                labelStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 15.sp),
                unselectedLabelStyle: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 15.sp),

                // dividerColor: Colors.pink[750],
                indicatorColor: Colors.black,
                indicatorWeight: 1,
                indicatorSize: TabBarIndicatorSize.tab,

                controller: _tabController,
                tabs: const [
                  Tab(
                    text: 'LoginRegister',
                  ),
                  Tab(text: 'Sign Up'),
                ],
              ),
              Expanded(
                  child: TabBarView(
                physics: const BouncingScrollPhysics(),
                controller: _tabController,
                children: [
                  Container(
                    color: Colors.yellow,
                    child: Center(
                      child: Text('LoginRegister content'),
                    ),
                  ),
                  // Sign Up tab content
                  Container(
                    color: Colors.orange,
                    child: Center(
                      child: Text('Sign Up content'),
                    ),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
