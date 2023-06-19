import 'package:campusgo/core/widgets/primarybutton.dart';
import 'package:campusgo/core/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/constants.dart';
import '../../../authentication/presentation/views/createpassword.dart';

class PromoCodePage extends StatefulWidget {
  static String routeName = 'PromoCodePage';
  const PromoCodePage({super.key});

  @override
  State<PromoCodePage> createState() => _PromoCodePageState();
}

class _PromoCodePageState extends State<PromoCodePage> {
  final TextEditingController _promoCodeController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(kBackgroundColor),
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: kPrimaryColor2),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleText(text: 'Enter promo code'),
            SizedBox(height: 20.h),
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.done,
                      controller: _promoCodeController,
                      cursorColor: Colors.black.withOpacity(0.7),
                      decoration: const InputDecoration(
                        hintText: 'Promo code',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter promocode';
                        }

                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10.sp,
                    ),
                    Text(
                      'The promo will be applied to your next ride.',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            fontSize: 13.sp,
                            color: Colors.black.withOpacity(0.7),
                          ),
                    ),
                    const Spacer(),
                    PrimaryButton(
                      text: 'Apply',
                      onPressed: _submitForm,
                      isLoading: _isLoading,
                    ),
                    SizedBox(
                      height: 16.sp,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: const Color(0XFFA495FF),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 40.sp,
                              width: 40.sp,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: kPrimaryColor2,
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  kWhiteTag,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Don't have a code yet?",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                      ),
                                ),
                                Text(
                                  "Get free rides",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                        fontSize: 12.sp,
                                        color: Colors.black,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    )
                  ],
                ),
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

        Navigator.pushNamed(
          context,
          CreatePassword.routeName,
        );
      });
    }
  }
}
