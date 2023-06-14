import 'package:campusgo/core/constants/constants.dart';
import 'package:campusgo/core/widgets/primarybutton.dart';
import 'package:campusgo/features/authentication/presentation/views/createpassword.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegistrationPage extends StatefulWidget {
  static String routeName = 'RegistrationPage';
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedGender;
  bool _isChecked = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();

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
              'Create an account',
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
              'or register with your email',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'First Name',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black, fontSize: 15.sp),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  TextFormField(
                    controller: _firstNameController,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.text,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black, fontSize: 16.sp),
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Enter First Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your firstname';
                      } else {}
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  Text(
                    'Last Name',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black, fontSize: 16.sp),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  TextFormField(
                    controller: _lastNameController,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.text,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black, fontSize: 15.sp),
                    decoration: const InputDecoration(hintText: 'Lastname'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your lastname';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  Text(
                    'Username',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black, fontSize: 16.sp),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  TextFormField(
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.text,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black, fontSize: 15.sp),
                    decoration: const InputDecoration(
                        hintText: 'Enter your Unique Username'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
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
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black, fontSize: 15.sp),
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(hintText: 'student@example.com'),
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
                    'Gender',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black, fontSize: 16.sp),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  DropdownButtonFormField<String>(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black, fontSize: 15.sp),
                    elevation: 0,
                    itemHeight: 60.h,
                    //isExpanded: true,
                    value: _selectedGender,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Select Gender',
                    ),
                    items: <String>['Male', 'Female', 'LGBTQ']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your gender';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  Text(
                    'Phone Number',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black, fontSize: 16.sp),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  TextFormField(
                    controller: _phoneNumberController,
                    textInputAction: TextInputAction.done,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black, fontSize: 15.sp),
                    decoration: const InputDecoration(
                      hintText: '08102481227',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      } else if (value.length < 11) {
                        return 'Please enter a valid phone number';
                      }
                      // Add additional phone number validation logic if needed
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value!;
                          });
                        },
                        activeColor: const Color(kPrimaryColor),
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            text: 'I hereby agree to the ',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.black,
                                  fontSize: 13.sp,
                                ),
                            children: [
                              TextSpan(
                                text: 'Terms and Conditions',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: kPrimaryColor2, fontSize: 13.sp),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Handle Terms and Conditions link tap
                                  },
                              ),
                              TextSpan(
                                text: ' guiding this app.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Colors.black, fontSize: 13.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  PrimaryButton(
                    enabled: _isChecked,
                    isLoading: _isLoading,
                    text: 'Continue',
                    onPressed: () => _submitForm(),
                  ),
                  SizedBox(height: 24.h),
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
        _firstNameController.clear();
        _lastNameController.clear();
        _usernameController.clear();
        _emailController.clear();
        _phoneNumberController.clear();

        Navigator.pushNamed(
          context,
          CreatePassword.routeName,
        );
      });
    }
  }
}
