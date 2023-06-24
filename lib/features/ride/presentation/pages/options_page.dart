import 'package:campusgo/core/constants/constants.dart';
import 'package:campusgo/core/widgets/primarybutton.dart';
import 'package:campusgo/features/home/presentation/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OptionsPage extends StatefulWidget {
  static String routeName = 'OptionsPage';
  const OptionsPage({super.key});

  @override
  State<OptionsPage> createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  String selectedOption = '';
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(kBackgroundColor),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 136.h,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Welcome ",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.black),
                  ),
                  TextSpan(
                    text: 'Muna!',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: selectedOption.isNotEmpty
                              ? kPrimaryColor2
                              : Colors.black,
                        ),
                  )
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'What would you like to book for?',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.h),
            buildOptionCard(
              'Vacation',
              'Enjoy your journey home with convenient rides.',
              Icons.home_sharp,

              kUnselectedHouse, // Updated illustration image for selected state
              kHouse,
            ),
            SizedBox(height: 16.h),
            buildOptionCard(
              'Resumption',
              'Enjoy hassle-free rides to school.              ',
              Icons.school,

              kUnselectedSchool, // Updated illustration image for selected state
              kSchool,
            ),
            SizedBox(height: 16.h),
            Text(
              getOptionInformation(selectedOption),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 16.h),
            if (showError)
              Text(
                'Please select an option',
                style: Theme.of(context).inputDecorationTheme.errorStyle,
              ),
            SizedBox(height: 30.h),
            PrimaryButton(
              text: 'Continue',
              enabled: selectedOption.isNotEmpty ? true : false,
              onPressed: () {
                if (selectedOption.isNotEmpty) {
                  if (selectedOption == 'vacation') {
                    Navigator.pushNamed(context, Home.routeName);
                  } else if (selectedOption == 'resumption') {
                    Navigator.pushNamed(context, '/resumption');
                  }
                } else {
                  setState(() {
                    showError = true;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOptionCard(
    String title,
    String description,
    IconData iconData,
    String illustrationImage,
    String selectedIllustrationImage,
  ) {
    bool isSelected = selectedOption == title.toLowerCase();

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = isSelected ? '' : title.toLowerCase();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? kPrimaryColor2.withOpacity(0.1)
              : const Color(kBackgroundColor),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected ? kPrimaryColor2 : Colors.black.withOpacity(0.7),
            width: 3.5.w,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(kBackgroundColor),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (isSelected)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Container(
                  decoration: const BoxDecoration(
                    color: kPrimaryColor2,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(4.w),
                  child: Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 20.sp,
                  ),
                ),
              ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Icon(
                    iconData,
                    color: isSelected
                        ? kPrimaryColor2
                        : Colors.black.withOpacity(0.7),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 25.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? kPrimaryColor2
                                : Colors.black.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isSelected
                                ? Colors.black
                                : Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isSelected)
                  Image.asset(
                    selectedIllustrationImage,
                    height: 120.h,
                    width: 120.w,
                    fit: BoxFit.contain,
                  ),
                if (!isSelected)
                  Image.asset(
                    illustrationImage,
                    height: 100.h,
                    width: 100.w,
                    fit: BoxFit.contain,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String getOptionInformation(String option) {
  if (option == 'vacation') {
    return 'Make your journey back home an enjoyable experience by booking convenient and reliable rides.';
  } else if (option == 'resumption') {
    return 'Resume to school on the right note with our transportation services, providing a reliable and comfortable journey for students.';
  } else {
    return '';
  }
}

// Scaffold(
//       backgroundColor: const Color(kBackgroundColor),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 24.w),
//         child: Column(
//           // mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 136.h),
//             Text(
//               'Welcome!',
//               style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                     color: Colors.black,
//                   ),
//             ),
//             SizedBox(height: 16.h),
//             Text(
//               'Please select your desired option:',
//               style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                     color: Colors.black.withOpacity(0.7),
//                   ),
//             ),
//             SizedBox(height: 32.h),
//             OptionCard(
//               imagePath: 'assets/images/resumption_option.jpg',
//               title: 'Resumption',
//               onPressed: () {
//                 // Handle resumption option selection
//                 // Navigate to the appropriate screen
//               },
//             ),
//             SizedBox(height: 16.h),
//             OptionCard(
//               imagePath: 'assets/images/vacation_option.jpg',
//               title: 'Vacation',
//               onPressed: () {
//                 // Handle vacation option selection
//                 // Navigate to the appropriate screen
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class OptionCard extends StatelessWidget {
//   final String imagePath;
//   final String title;
//   final VoidCallback onPressed;

//   const OptionCard({
//     Key? key,
//     required this.imagePath,
//     required this.title,
//     required this.onPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         height: 200.0,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16.0),
//           color: kPrimaryColor2,
//           image: DecorationImage(
//             image: AssetImage(imagePath),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16.0),
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.transparent,
//                 Colors.black.withOpacity(0.5),
//               ],
//             ),
//           ),
//           child: Center(
//             child: Text(
//               title,
//               style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//             ),
//           ),
//         ),
//       ),
//     );