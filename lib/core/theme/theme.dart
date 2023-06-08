import 'package:campusgo/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData theme(BuildContext context) => ThemeData(
      primaryColor: const Color(0xFF7A64FF),
      scaffoldBackgroundColor: const Color(kPrimaryColor),
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.w800,
          fontSize: 26.sp,
          color: Colors.white,
          letterSpacing: -0.4,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
          color: Colors.white,
          letterSpacing: 0,
        ),
        bodySmall: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 18.sp,
          color: Colors.white,
          letterSpacing: 0,
        ),
        displaySmall: GoogleFonts.poppins(
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: Colors.black.withOpacity(0.7),
          letterSpacing: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        errorStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
          color: Colors.red,
          letterSpacing: 0,
        ),
        fillColor: Colors.white,
        filled: true,
        hintStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
          color: Colors.black.withOpacity(0.7),
          letterSpacing: 0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: const BorderSide(
            color: kPrimaryColor2,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      ),
    );
