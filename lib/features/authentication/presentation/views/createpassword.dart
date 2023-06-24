import 'package:bot_toast/bot_toast.dart';
import 'package:campusgo/core/utilities/validation.dart';
import 'package:campusgo/core/widgets/password_validator.dart';
import 'package:campusgo/features/authentication/presentation/views/login.dart';
import 'package:campusgo/features/authentication/presentation/views/loginpage.dart';
import 'package:campusgo/features/authentication/presentation/views/otp_verification.dart';
import 'package:campusgo/features/home/presentation/pages/home2.dart';
import 'package:campusgo/global/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/primarybutton.dart';

class CreatePassword extends StatefulWidget {
  static String routeName = 'CreatePassword';
  const CreatePassword({super.key});

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _showValidator = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  late String email;
  late String firstName;
  late String lastName;
  late String userName;
  late String phoneNumber;
  late String address;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      BotToast.showText(text: 'Email verification link sent');
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, LoginRegister.routeName);
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await firebaseAuth
          .createUserWithEmailAndPassword(
        email: email,
        password: _confirmPasswordController.text.trim(),
      )
          .then((auth) {
        currentUser = auth.user;
        if (currentUser != null) {
          Map userMap = {
            'id': currentUser!.uid,
            'name': '$lastName $firstName',
            'email': email,
            'username': userName,
            'address': address,
            'phone': phoneNumber,
          };

          DatabaseReference userRef =
              FirebaseDatabase.instance.ref().child('users');
          userRef.child(currentUser!.uid).set(userMap);
        }

        BotToast.showSimpleNotification(title: 'Successfully Registered');
        _sendEmailVerification();
        // Navigator.pushReplacementNamed(
        //   context,
        //   Homee.routeName,
        // );
      }).catchError((errorMessage) {
        BotToast.showText(text: 'Error occured: \n $errorMessage');
      });
      setState(() {
        _isLoading = false;
      });
    } else {
      BotToast.showText(text: 'Not all fields are valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    firstName = arguments['firstName'];
    email = arguments['email'];
    lastName = arguments['lastName'];
    userName = arguments['userName'];
    phoneNumber = arguments['phoneNumber'];
    address = arguments['address'];
    return Scaffold(
      backgroundColor: const Color(kBackgroundColor),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 25.w,
        ),
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   'Create a password',
              //   style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              //         fontWeight: FontWeight.w700,
              //         color: Colors.black,
              //       ),
              // ),
              SizedBox(
                height: 136.h,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Create a ",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'Password!',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: const Color(kPrimaryColor),
                          ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              // Other widgets

              // Container or Card to wrap the form fields
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.black, fontSize: 15.sp),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      focusNode: _passwordFocusNode,
                      obscureText: _obscurePassword,
                      validator: (value) => validatePassword(value!),
                      decoration: InputDecoration(
                        hintText: 'Enter password',
                        suffixIcon: IconButton(
                          color: Colors.black.withOpacity(0.7),
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _showValidator = true;
                        });
                      },
                    ),
                    SizedBox(height: 24.h),
                    _showValidator
                        ? Column(
                            children: [
                              PasswordValidator(
                                  controller: _passwordController),
                              SizedBox(height: 14.h),
                            ],
                          )
                        : Container(),
                    Text(
                      'Re-enter Password',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.black, fontSize: 15.sp),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Re-enter password',
                      ),
                    ),
                    SizedBox(height: 30.h),
                    SizedBox(height: 30.h),
                    PrimaryButton(
                      text: 'Continue',
                      isLoading: _isLoading,
                      onPressed: () => _submitForm(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
