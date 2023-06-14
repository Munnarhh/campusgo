import 'package:campusgo/core/constants/constants.dart';
import 'package:campusgo/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final bool enabled;
  final bool isLoading;
  final VoidCallback onPressed;
  const PrimaryButton({
    super.key,
    required this.text,
    this.enabled = true,
    this.isLoading = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(0, 4),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
          color: enabled ? kPrimaryColor2 : Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(25.r),
        ),
        width: double.infinity,
        child: isLoading
            ? const Center(
                child: SpinKitFadingFour(
                  color: Colors.white,
                  size: 20.0,
                ),
              )
            : Center(
                child: Text(
                  text,
                  style: theme(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 16.sp,
                      ),
                ),
              ),
      ),
    );
  }
}
// SizedBox(
//       width: double.infinity,
//       child: MaterialButton(
//         elevation: 5,
//         padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
//         onPressed: enabled ? onPressed : null,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(25),
//         ),
//         color: enabled ? kPrimaryColor2 : Colors.black.withOpacity(0.7),
//         child: isLoading
//             ? const SpinKitFadingFour(
//                 color: Colors.white,
//                 size: 20.0,
//               )
//             : Text(
//                 text,
//                 style: theme(context).textTheme.bodyMedium!.copyWith(
//                       fontSize: 16.sp,
//                     ),
//               ),
//       ),
//     );