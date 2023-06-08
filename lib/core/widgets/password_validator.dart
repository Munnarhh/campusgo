import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utilities/validation.dart';

class PasswordValidator extends StatefulWidget {
  const PasswordValidator({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  State<PasswordValidator> createState() => _PasswordValidatorState();
}

class _PasswordValidatorState extends State<PasswordValidator> {
  bool charLenth = false;
  bool lowerCase = false;
  bool hasNumb = false;
  bool upperCase = false;
  bool specChar = false;

  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {
        charLenth = has8Characters(widget.controller.text);
        lowerCase = hasLowercase(widget.controller.text);
        hasNumb = hasANumber(widget.controller.text);
        upperCase = hasUppercase(widget.controller.text);
        specChar = hasSpecialCharacter(widget.controller.text);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 5.h),
          child: Row(
            children: [
              Icon(
                charLenth ? Icons.check : Icons.close,
                size: 18.sp,
                color: charLenth ? Colors.green : Colors.red,
              ),
              SizedBox(width: 10.w),
              Text('8 characters or more',
                  style: Theme.of(context).textTheme.displaySmall),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5.h),
          child: Row(
            children: [
              Icon(
                lowerCase ? Icons.check : Icons.close,
                size: 18.sp,
                color: lowerCase ? Colors.green : Colors.red,
              ),
              SizedBox(width: 10.w),
              Text('Has a lowercase letter',
                  style: Theme.of(context).textTheme.displaySmall),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5.h),
          child: Row(
            children: [
              Icon(
                hasNumb ? Icons.check : Icons.close,
                size: 18.sp,
                color: hasNumb ? Colors.green : Colors.red,
              ),
              SizedBox(width: 10.w),
              Text('Has a number',
                  style: Theme.of(context).textTheme.displaySmall),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5.h),
          child: Row(
            children: [
              Icon(
                upperCase ? Icons.check : Icons.close,
                size: 18.sp,
                color: upperCase ? Colors.green : Colors.red,
              ),
              SizedBox(width: 10.w),
              Text('Has a uppercase letter',
                  style: Theme.of(context).textTheme.displaySmall),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5.h),
          child: Row(
            children: [
              Icon(
                specChar ? Icons.check : Icons.close,
                size: 18.sp,
                color: specChar ? Colors.green : Colors.red,
              ),
              SizedBox(width: 10.w),
              Text('Has a special character',
                  style: Theme.of(context).textTheme.displaySmall),
            ],
          ),
        ),
      ],
    );
  }
}
