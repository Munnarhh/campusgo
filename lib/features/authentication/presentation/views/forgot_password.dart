import 'package:bot_toast/bot_toast.dart';
import 'package:campusgo/global/global.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/primarybutton.dart';

class ForgotPasswordPage extends StatefulWidget {
  static String routeName = 'ForgotPasswordPage';
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      firebaseAuth
          .sendPasswordResetEmail(email: _emailController.text.trim())
          .then((value) {
        BotToast.showSimpleNotification(
            title:
                'We have sent you an email to recover password, please check email');
      }).catchError((errorMessage) {
        BotToast.showSimpleNotification(
            title: 'Error Occurred:\n$errorMessage');
      }).whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(kBackgroundColor),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Form(
          key: _formKey,
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
                controller: _emailController,
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
                text: 'Reset Password',
                isLoading: _isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
