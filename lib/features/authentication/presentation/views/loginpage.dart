import 'package:bot_toast/bot_toast.dart';
import 'package:campusgo/features/authentication/presentation/views/forgot_password.dart';
import 'package:campusgo/features/onboarding/presentation/views/splash_screen.dart';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/primarybutton.dart';
import '../../../../global/global.dart';
import '../../../home/presentation/pages/home2.dart';

class LoginPage extends StatefulWidget {
  static String routeName = 'LoginPage';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _hidePassword = true;
  bool _isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await firebaseAuth
          .signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      )
          .then((auth) async {
        DatabaseReference userRef =
            FirebaseDatabase.instance.ref().child('users');
        userRef.child(firebaseAuth.currentUser!.uid).once().then(
          (value) {
            final snap = value.snapshot;
            if (snap.value != null) {
              currentUser = auth.user;
              if (currentUser!.emailVerified) {
                // Email is verified, allow login
                BotToast.showSimpleNotification(
                    title: 'Successfully Logged In');
                Navigator.pushReplacementNamed(context, Homee.routeName);
              } else {
                // Email is not verified, show an error message
                BotToast.showSimpleNotification(
                  title: 'Please verify your email before logging in',
                );
                firebaseAuth.signOut();
              }
            } else {
              BotToast.showText(text: 'No record exists with this email');
              firebaseAuth.signOut();
              Navigator.pushNamed(context, SplashScreen.routeName);
            }
          },
        );
      }).catchError(
        (errorMessage) {
          BotToast.showText(text: 'Error occured: \n $errorMessage');
        },
      );

      setState(() {
        _isLoading = false;
      });
    } else {
      BotToast.showText(text: 'Not all fields are valid');
    }
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
              'or login with your student email',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email',
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
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.text,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black, fontSize: 15.sp),
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
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  Text(
                    'Password',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black, fontSize: 16.sp),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  TextFormField(
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black, fontSize: 15.sp),
                    controller: _passwordController,
                    textInputAction: TextInputAction.done,
                    obscureText: _hidePassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Enter Password',
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
                    child: Center(
                      child: Text(
                        'Forgot Password?',
                        style:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  color: const Color(kPrimaryColor),
                                  decoration: TextDecoration.underline,
                                ),
                        textAlign: TextAlign.center,
                      ),
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
}
