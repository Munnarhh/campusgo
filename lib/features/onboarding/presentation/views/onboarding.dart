import 'package:campusgo/core/constants/constants.dart';
import 'package:campusgo/features/login/presentation/views/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/onboarding_content.dart';

class OnboardingScreen extends StatefulWidget {
  static String routeName = 'Onboarding';
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  PageController _controller = PageController();
  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(kPrimaryColor),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        //foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 30.w, top: 20.h),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, LoginRegister.routeName);
              },
              child: Text(
                'Skip',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemCount: contents.length,
                itemBuilder: (_, i) {
                  return Padding(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      children: [
                        Image.asset(
                          contents[i].image,
                          height: 330.h,
                          width: 330.w,
                        ),
                        SizedBox(
                          height: 80.h,
                        ),
                        Text(
                          contents[i].title,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          contents[i].description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            GestureDetector(
              child: SvgPicture.asset('assets/icons/next.svg'),
              onTap: () {
                if (currentIndex == contents.length - 1) {
                  Navigator.pushNamed(context, LoginRegister.routeName);
                }
                _controller.nextPage(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeInOutCubicEmphasized,
                );
              },
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
