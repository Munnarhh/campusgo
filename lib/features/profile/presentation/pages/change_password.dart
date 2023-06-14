import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utilities/validation.dart';
import '../../../../core/widgets/password_validator.dart';
import '../../../../core/widgets/primarybutton.dart';

class ChangePasswordPage extends StatefulWidget {
  static const String routeName = 'ChangePasswordPage';
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  final FocusNode _currentPasswordFocusNode = FocusNode();
  bool _isLoading = false;
  bool _showValidator = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmNewPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(kBackgroundColor),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 136.h),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Change ',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'Password',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.black,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Password',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.black, fontSize: 15.sp),
                    ),
                    SizedBox(height: 4.h),
                    TextFormField(
                      controller: _currentPasswordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      focusNode: _currentPasswordFocusNode,
                      obscureText: _obscureCurrentPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter current password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter current password',
                        suffixIcon: IconButton(
                          color: Colors.black.withOpacity(0.7),
                          icon: Icon(_obscureCurrentPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscureCurrentPassword =
                                  !_obscureCurrentPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'New Password',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.black, fontSize: 15.sp),
                    ),
                    SizedBox(height: 4.h),
                    TextFormField(
                      controller: _newPasswordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onTap: () {
                        setState(() {
                          _showValidator = true;
                        });
                      },
                      obscureText: _obscureNewPassword,
                      validator: (value) {
                        if (_currentPasswordController.text.isEmpty) {
                          return 'Enter Current Password';
                        } else {
                          validatePassword(value!);
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter new password',
                        // suffixIcon: IconButton(
                        //   color: Colors.black.withOpacity(0.7),
                        //   icon: Icon(_obscureNewPassword
                        //       ? Icons.visibility_off
                        //       : Icons.visibility),
                        //   onPressed: () {
                        //     setState(() {
                        //       _obscureNewPassword = !_obscureNewPassword;
                        //     });
                        //   },
                        // ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    _showValidator
                        ? Column(
                            children: [
                              PasswordValidator(
                                  controller: _newPasswordController),
                              SizedBox(height: 14.h),
                            ],
                          )
                        : Container(),
                    Text(
                      'Confirm New Password',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.black, fontSize: 15.sp),
                    ),
                    SizedBox(height: 4.h),
                    TextFormField(
                      controller: _confirmNewPasswordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: _obscureConfirmNewPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your new password';
                        }
                        if (value != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Confirm new password',
                        // suffixIcon: IconButton(
                        //   color: Colors.black.withOpacity(0.7),
                        //   icon: Icon(_obscureConfirmNewPassword
                        //       ? Icons.visibility_off
                        //       : Icons.visibility),
                        //   onPressed: () {
                        //     setState(() {
                        //       _obscureConfirmNewPassword =
                        //           !_obscureConfirmNewPassword;
                        //     });
                        //   },
                        // ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    PrimaryButton(
                      text: 'Change Password',
                      isLoading: _isLoading,
                      onPressed: () => _submitForm(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      Future.delayed(
        const Duration(seconds: 2),
        () {
          setState(() {
            _isLoading = false;
          });
        },
      );
    }
  }
}
