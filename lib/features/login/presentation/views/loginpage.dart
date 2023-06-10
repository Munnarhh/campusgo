import 'package:campusgo/core/widgets/success_page.dart';
import 'package:campusgo/features/login/presentation/views/forgot_password.dart';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/primarybutton.dart';

class LoginPage extends StatefulWidget {
  static String routename = 'LoginPage';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _matricNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _hidePassword = true;
  bool _isLoading = false;
  @override
  void dispose() {
    _matricNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(kBackgroundColor),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Log in to your account',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.black,
                  ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                SvgPicture.asset(
                  kGoogle,
                  height: 25.5.h,
                  width: 25.5.w,
                ),
                SizedBox(width: 22.w),
                SvgPicture.asset(
                  kApple,
                  height: 22.43.h,
                  width: 25.5.w,
                ),
                SizedBox(width: 22.w),
                SvgPicture.asset(
                  kMicrosoft,
                  height: 25.5.h,
                  width: 25.5.w,
                ),
              ],
            ),
            SizedBox(height: 33.h),
            Text(
              'or login with your matric number',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.black.withOpacity(0.7),
                  ),
            ),
            SizedBox(
              height: 24.h,
            ),
            Form(
              key: _formKey,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _matricNumberController,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.text,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black, fontSize: 16.sp),
                    decoration: const InputDecoration(
                      hintText: 'Matric Number',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your matric number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  TextFormField(
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black, fontSize: 16.sp),
                    controller: _passwordController,
                    textInputAction: TextInputAction.done,
                    obscureText: _hidePassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        color: Colors.black.withOpacity(0.7),
                        onPressed: () {
                          setState(() {
                            _hidePassword = !_hidePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  PrimaryButton(
                    isLoading: _isLoading,
                    text: 'Log In',
                    onPressed: () => _submitForm(),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, ForgotPasswordPage.routeName);
                    },
                    child: Text(
                      'Forgot Password?',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: const Color(kPrimaryColor),
                            decoration: TextDecoration.underline,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          _isLoading = false;
        });
        _matricNumberController.clear();
        _passwordController.clear();

        Navigator.pushNamed(
          context,
          SuccessPage.routeName,
        );
      });
    }
  }
}
