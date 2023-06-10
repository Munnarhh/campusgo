import 'package:campusgo/core/utilities/validation.dart';
import 'package:campusgo/core/widgets/primarybutton.dart';
import 'package:campusgo/home.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/theme/theme.dart';

class OtpVerification extends StatefulWidget {
  static String routeName = 'OtpVerificationPage';
  const OtpVerification({super.key});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(kBackgroundColor),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 136.h),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'OTP ',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                      ),
                      TextSpan(
                        text: 'Verification',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(kPrimaryColor),
                            ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 35.h),
              Text(
                'Enter the verification code sent to your email',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 15.sp,
                    ),
              ),
              SizedBox(height: 57.h),
              Center(
                child: Pinput(
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  validator: (value) => validateOtp(value!),
                  errorTextStyle:
                      Theme.of(context).inputDecorationTheme.errorStyle,
                  closeKeyboardWhenCompleted: true,
                  onCompleted: (value) {
                    setState(() {
                      _otpController.text = value;

                      print(_otpController.text);
                    });
                  },
                  length: 6,
                  textInputAction: TextInputAction.done,
                  defaultPinTheme: kDefaultPin(context),
                  focusedPinTheme: kFocusedPin(context),
                ),
              ),
              //to do implement timer
              // Text(
              //   '00:00',
              //   style: Theme.of(context)
              //       .textTheme
              //       .displaySmall!
              //       .copyWith(color: Colors.red),
              // ),
              SizedBox(height: 50.h),
              PrimaryButton(
                text: 'Continue',
                onPressed: () {
                  _formKey.currentState!.validate();
                  _submitForm();
                },
                isLoading: _isLoading,
              ),
              SizedBox(height: 10.h),
              GestureDetector(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Didn't receive a verification code? ",
                        style:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  color: Colors.black,
                                ),
                      ),
                      TextSpan(
                        text: 'send again',
                        style:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  color: const Color(kPrimaryColor),
                                  decoration: TextDecoration.underline,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      Future.delayed(
        const Duration(seconds: 5),
        () {
          setState(() {
            _isLoading = false;
          });
          Navigator.pushNamed(
            context,
            Home.routeName,
          );
        },
      );
    }
  }
}
