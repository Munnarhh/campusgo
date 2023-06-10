import 'package:campusgo/core/utilities/validation.dart';
import 'package:campusgo/core/widgets/password_validator.dart';
import 'package:campusgo/features/login/presentation/views/otp_verification.dart';
import 'package:campusgo/home.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/primarybutton.dart';

class CreatePassword extends StatefulWidget {
  static String routename = 'CreatePassword';
  const CreatePassword({super.key});

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(kBackgroundColor),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 136.h),
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
                children: [
                  TextFormField(
                    controller: _passwordController,
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
                  ),
                  SizedBox(height: 24.h),
                  TextFormField(
                    controller: _confirmPasswordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      hintText: 'Confirm password',
                    ),
                  ),
                  SizedBox(height: 30.h),
                  PasswordValidator(
                    controller: _passwordController,
                  ),
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
    );
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
            OtpVerification.routeName,
          );
        },
      );
    }
  }
}
