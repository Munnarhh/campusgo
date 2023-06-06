import 'package:campusgo/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData theme(BuildContext context) => ThemeData(
      scaffoldBackgroundColor: const Color(kPrimaryColor),
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.w800,
          fontSize: 26.sp,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
          color: Colors.white,
        ),
        bodySmall: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 18.sp,
          color: Colors.white,
        ),
      ),
    );
